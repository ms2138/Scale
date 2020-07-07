//
//  AddWeightViewController.swift
//  Scale
//
//  Created by mani on 2020-06-12.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class AddWeightViewController: UITableViewController {
    @IBOutlet weak var weightCell: TextInputCell!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    var dataManager: CoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Weight"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTextInputCell()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        weightCell.textField.becomeFirstResponder()
    }
}

extension AddWeightViewController {
    // MARK: - IBAction methods

    @IBAction func cancel(_ sender: UIBarButtonItem?) {
        dismiss(animated: true)
    }

    @IBAction func save(_ sender: UIBarButtonItem?) {
        guard let input = Float(weightCell.textField.text!), input > 0 else {
            showAlert(title: "Error", message: "Please enter a correct weight")
            return
        }

        guard let dataManager = dataManager else { return }

        let record = Record(context: dataManager.managedObjectContext)
        record.weight = input
        record.createdAt = Date()

        dataManager.saveContext()

        dismiss(animated: true)
    }
}

extension AddWeightViewController {
    // MARK: - View setup methods

    private func setupTextInputCell() {
        weightCell.textField.delegate = self
        weightCell.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        weightCell.textField.autocapitalizationType = .none
        weightCell.textField.placeholder = "Enter Weight"
        weightCell.textField.returnKeyType = .done
        weightCell.textField.enablesReturnKeyAutomatically = true
    }

    @objc func textDidChange(sender: UITextField) {
        saveBarButtonItem.isEnabled = !weightCell.textField.text!.isEmpty
    }
}

extension AddWeightViewController: UITextFieldDelegate {
    // MARK: - Text field delegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            save(nil)
            return true
        }
        return false
    }
}
