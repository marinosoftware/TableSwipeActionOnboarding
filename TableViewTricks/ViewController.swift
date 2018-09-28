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

    let animals = ["A": ["Anaconda"], "B": ["Bear", "Beaver"], "C": ["Cat", "Camel"], "D": ["Dingo"], "E": ["Elephant"]]
    let indices = ["A", "B", "C", "D", "E"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self
        tableView.dataSource = self

        UserDefaults.standard.set(false, forKey: TableViewCellOnboarding.userDefaultsFinishedKey)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !UserDefaults.standard.bool(forKey: TableViewCellOnboarding.userDefaultsFinishedKey) {
            let config = TableViewCellOnboarding.Config(initialDelay: 1, duration: 2.5, halfwayDelay: 0.5)
            onboardingCell = TableViewCellOnboarding(with: tableView, config: config)
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
        return indices.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals[indices[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell

        let section = indices[indexPath.section]
        let item = animals[section]?[indexPath.row] ?? ""

        cell.titleLabel.text = item
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indices[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
}
