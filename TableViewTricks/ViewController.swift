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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self
        tableView.dataSource = self
    }
    var onboardingCell: TableViewCellOnboarding?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onboardingCell = TableViewCellOnboarding(with: tableView)
        onboardingCell?.editActions = tableView(tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
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

        print(cell.titleLabel.font)
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
