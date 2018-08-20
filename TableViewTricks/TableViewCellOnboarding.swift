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
    }

    var animationConfig: Config

    var onboardingCell: UIView?
    var tableView: UITableView

    init(with tableView: UITableView, config: Config = Config()) {
        self.tableView = tableView
        self.animationConfig = config
        super.init()

        if self.tableView.numberOfRows(inSection: 0) > 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
            if let screenShot = cell.snapshotView(afterScreenUpdates: true) {
                screenShot.bounds = tableView.convert(cell.bounds, to: tableView)
                onboardingCell = screenShot

                tableView.addSubview(onboardingCell!)
                tableView.bringSubview(toFront: onboardingCell!)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
                tapGesture.numberOfTapsRequired = 1
                onboardingCell!.addGestureRecognizer(tapGesture)
            }
        }
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

    func discoverablilityAnimation() {
        guard let editActions = editActions,
              let onboardingCell = onboardingCell else {
            print("Forgot to update editActions or onboardingCell.")
            return
        }

        var actionViews = [UIView]()
        var newViewXPos: CGFloat = onboardingCell.bounds.size.width
        var count: CGFloat = 0

        let labelPadding: CGFloat = 12
        var editActionsWidth: CGFloat = 0
        for action in editActions.reversed() {
            let label = createLabel(with: action.title)

            let view = UIView()
            view.frame = CGRect(origin: CGPoint(x: newViewXPos, y: 0), size: CGSize(width: label.frame.size.width + (labelPadding * 2), height: onboardingCell.frame.size.height))
            view.backgroundColor = action.backgroundColor

            label.frame = view.bounds

            newViewXPos = view.frame.origin.x + view.frame.size.width

            view.addSubview(label)
            actionViews.append(view)
            onboardingCell.addSubview(view)

            count += 1
            editActionsWidth +=  view.frame.size.width
        }

        let onboardingFrame = self.onboardingCell!.frame

        self.onboardingCell?.frame = CGRect(x: 0, y: 0, width: onboardingFrame.size.width, height: onboardingFrame.size.height)

        // UIView delay doesn't work because snapshotView(afterScreenUpdates: true) was used before
        DispatchQueue.main.asyncAfter(deadline: .now() + animationConfig.initialDelay) {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {

                self.onboardingCell?.frame = CGRect(x: -editActionsWidth, y: 0, width: onboardingFrame.size.width, height: onboardingFrame.size.height)
            }) { (finished) in

                if finished {
                    UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {

                        self.onboardingCell?.frame = CGRect(x: 0, y: 0, width: onboardingFrame.size.width, height: onboardingFrame.size.height)
                    }) { (finished) in

                        if finished {
                            UserDefaults.standard.setValue(true, forKey: TableViewCellOnboarding.userDefaultsFinishedKey)
                        }
                        onboardingCell.removeFromSuperview()
                    }
                } else {
                    onboardingCell.removeFromSuperview()
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
