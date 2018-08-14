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

    var onboardingCell: UIView?
    var tableView: UITableView

    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()

        if self.tableView.numberOfRows(inSection: 0) > 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
            if let screenShot = cell.snapshotView(afterScreenUpdates: false) {
                screenShot.bounds = tableView.convert(cell.bounds, to: tableView)
                onboardingCell = screenShot

                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
                onboardingCell!.addGestureRecognizer(panGesture)

                tableView.addSubview(onboardingCell!)
            }
        }
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

        let labelPadding: CGFloat = 10
        var editActionsWidth: CGFloat = 0
        for action in editActions.reversed() {
            let view = UIView()
            view.frame = CGRect(origin: CGPoint(x: newViewXPos, y: 0), size: onboardingCell.bounds.size)
            view.backgroundColor = action.backgroundColor
            let label = UILabel(frame: .zero)
            label.text = action.title
            label.font = UIFont(name: ".SFUIText-Medium", size: 15)
            label.sizeToFit()
            label.frame = CGRect(x: labelPadding, y: 0, width: label.frame.size.width + labelPadding, height: view.frame.size.height)
            newViewXPos = view.frame.origin.x + labelPadding + label.frame.size.width
            label.textColor = .white
            view.addSubview(label)
            actionViews.append(view)
            onboardingCell.addSubview(view)

            count += 1
            editActionsWidth +=  labelPadding + label.frame.size.width
        }

        print(editActionsWidth)

        let onboardingFrame = self.onboardingCell!.frame
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

            self.onboardingCell?.frame = CGRect(x: -editActionsWidth, y: 0, width: onboardingFrame.size.width, height: onboardingFrame.size.height)
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

                self.onboardingCell?.frame = CGRect(x: 0, y: 0, width: onboardingFrame.size.width, height: onboardingFrame.size.height)
            }) { (_) in
                onboardingCell.removeFromSuperview()
            }
        }
    }

    var previousPos: CGPoint?
    @objc func pan(_ recogniser: UIPanGestureRecognizer) {
//        previousPos = recogniser
        print("Panning")
        let translation = recogniser.translation(in: tableView)
        onboardingCell!.transform = CGAffineTransform.init(translationX: translation.x, y: 0)
    }
}