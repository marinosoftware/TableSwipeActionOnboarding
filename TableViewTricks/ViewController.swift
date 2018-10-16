//
//  ViewController.swift
//  TableViewTricks
//
//  Created by Tim Colla on 20/07/2018.
//  Copyright © 2018 Marino Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var onboardingCell: TableViewCellOnboarding?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !UserDefaults.standard.bool(forKey: TableViewCellOnboarding.userDefaultsFinishedKey) {
            onboardingCell = TableViewCellOnboarding(with: tableView)
            onboardingCell?.editActions = tableView(tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.titleLabel.text = "test"
        cell.backgroundColor = .red
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            print("Action tapped")
        }
        let amend = UITableViewRowAction(style: .normal, title: "Amend") { (_, _) in
            print("Action tapped")
        }

        return [delete, amend]
    }
}
