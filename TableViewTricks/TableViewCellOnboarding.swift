//
//  UITableView+Onboarding.swift
//  TableViewTricks
//
//  Created by Tim Colla on 20/07/2018.
//  Copyright © 2018 Marino Software. All rights reserved.
//

import UIKit

class TableViewCellOnboarding: NSObject {
    var editActions: [UITableViewRowAction]? {
        didSet {

            discoverablilityAnimation()
        }
    }

    static let userDefaultsFinishedKey = "onboardingFinished"

    struct Config {
        var initialDelay = 0.5
        var duration = 2.5
        var halfwayDelay = 0.5
    }

    var animationConfig: Config

    var onboardingCell: UIView?
    var tableView: UITableView

    var rtl = false

    init(with tableView: UITableView, config: Config = Config()) {
        self.tableView = tableView
        self.animationConfig = config
        super.init()

        if self.tableView.numberOfRows(inSection: 0) > 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
            rtl = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft

            let snapshot = customSnapShotFrom(view: cell)
            onboardingCell = UIView(frame: cell.bounds)
            onboardingCell?.addSubview(snapshot)

            cell.addSubview(onboardingCell!)

            // So a user can cut the animation short
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
            tapGesture.numberOfTapsRequired = 1
            onboardingCell!.addGestureRecognizer(tapGesture)
        }
    }

    func customSnapShotFrom(view:UIView) -> UIView {

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let cellImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: cellImage)
        return imageView
    }

    func createLabel(with text: String?) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.textColor = .white
        label.font = UIFont(name: ".SFUIText-Medium", size: 15)
        label.textAlignment = .center
        label.sizeToFit()

        return label
    }

    func nextViewXPos(from previousView: UIView? = nil) -> CGFloat {
        guard let onboardingCell = onboardingCell else {
            return 0
        }

        guard let previousView = previousView else {
            return rtl ? 0 : onboardingCell.bounds.size.width
        }

        if rtl {
            return previousView.frame.origin.x
        } else {
            return previousView.frame.origin.x + previousView.frame.size.width
        }
    }

    func discoverablilityAnimation() {
        guard let editActions = editActions,
              let onboardingCell = onboardingCell else {
            print("Forgot to update editActions or onboardingCell.")
            return
        }

        var actionViews = [UIView]()
        var newViewXPos: CGFloat = nextViewXPos()
        var count: CGFloat = 0

        let labelPadding: CGFloat = 12
        var editActionsWidth: CGFloat = 0
        for action in editActions.reversed() {
            let label = createLabel(with: action.title)

            let view = UIView()
            let actionWidth = label.frame.size.width + (labelPadding * 2)
            let actionX = rtl ? newViewXPos - actionWidth : newViewXPos
            view.frame = CGRect(origin: CGPoint(x: actionX, y: 0), size: CGSize(width: actionWidth, height: onboardingCell.frame.size.height))
            view.backgroundColor = action.backgroundColor

            label.frame = view.bounds
            label.isUserInteractionEnabled = false

            newViewXPos = nextViewXPos(from: view)

            view.addSubview(label)
            view.isUserInteractionEnabled = false
            actionViews.append(view)
            onboardingCell.addSubview(view)

            count += 1
            editActionsWidth +=  view.frame.size.width
        }

        onboardingCell.frame = CGRect(origin: onboardingCell.frame.origin, size: CGSize(width: onboardingCell.frame.size.width + editActionsWidth, height: onboardingCell.frame.size.height))

        // UIView delay doesn't work because snapshotView(afterScreenUpdates: true) was used before
        DispatchQueue.main.asyncAfter(deadline: .now() + animationConfig.initialDelay) {
            UIView.animate(withDuration: (self.animationConfig.duration - self.animationConfig.halfwayDelay) / 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {

                let rtlModifier: CGFloat = self.rtl ? 1 : -1
                self.onboardingCell?.transform = CGAffineTransform(translationX: editActionsWidth * rtlModifier, y: 0)
            }) { (finished) in

                if finished {
                    UIView.animate(withDuration:  (self.animationConfig.duration - self.animationConfig.halfwayDelay) / 2.0,
                                   delay: self.animationConfig.halfwayDelay,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 1,
                                   options: [.curveEaseInOut, .allowUserInteraction],
                                   animations: {
                                    self.onboardingCell?.transform = CGAffineTransform.identity
                    }) { (finished) in

                        if finished {
                            UserDefaults.standard.setValue(true, forKey: TableViewCellOnboarding.userDefaultsFinishedKey)
                        }
                        onboardingCell.removeFromSuperview()
                        self.onboardingCell?.transform = CGAffineTransform.identity
                    }
                } else {
                    onboardingCell.removeFromSuperview()
                    self.onboardingCell?.transform = CGAffineTransform.identity
                }
            }
        }
    }

    @objc func tap(_ recognizer: UITapGestureRecognizer) {
        CATransaction.begin()
        onboardingCell!.layer.removeAllAnimations()
        CATransaction.commit()
    }
}
