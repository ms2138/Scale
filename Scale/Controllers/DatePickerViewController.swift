//
//  DatePickerViewController.swift
//  Scale
//
//  Created by mani on 2020-05-21.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class DatePickerViewController: UITableViewController {
    @IBOutlet weak var dateCell: DateCell!
    var dateChangedHandler: ((Date) -> Void)?
    var currentDate: Date?
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Date"

        if let date = currentDate {
            dateCell.datePicker.date = date
        }

        dateCell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
}

extension DatePickerViewController {
    @objc func dateChanged(_ sender: UIDatePicker) {
        if let currentDate = currentDate {
            saveBarButtonItem.isEnabled = currentDate != sender.date
        }
    }
}

extension DatePickerViewController {
    @IBAction func save(_ sender: UIBarButtonItem) {
        dismiss(animated: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dateChangedHandler?(weakSelf.dateCell.datePicker.date)
        }
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
