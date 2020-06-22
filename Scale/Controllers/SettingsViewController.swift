//
//  SettingsViewController.swift
//  Scale
//
//  Created by mani on 2020-06-17.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

enum UnitOfWeight: Int {
    case pounds, kilograms
}

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        let index = UserDefaults.standard.integer(forKey: kUnitOfWeightKey)
        tableView.cellForRow(at: IndexPath(row: index, section: 0))?.accessoryType = .checkmark
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetCellsAccessoryType()

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension SettingsViewController {
    func resetCellsAccessoryType() {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                cell.accessoryType = .none
            }
        }
    }
}
