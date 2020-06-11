//
//  WeightViewController.swift
//  Scale
//
//  Created by mani on 2020-06-07.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class WeightViewController: UIViewController, NoContentBackgroundView {
    private let reuseIdentifier = "RecordCell"

    @IBOutlet weak var tableView: UITableView!
    let dataManager = CoreDataManager(modelName: "Scale")
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.dataManager.managedObjectContext
    }()
    lazy var fetchedResultsController: NSFetchedResultsController<Record> = {
        let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var backgroundView: DTTableBackgroundView = {
        let backgroundView = DTTableBackgroundView(frame: self.view.frame)
        backgroundView.messageLabel.text = "Please add a record"
        backgroundView.buttonTitle = "Add"
        backgroundView.handler = { [unowned self] in
            self.performSegue(withIdentifier: "showAddWeight", sender: nil)
        }
        return backgroundView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Record"

        tableView.backgroundView = backgroundView
        hideBackgroundView()
    }

}

extension WeightViewController {
    // MARK: Core Data management methods

    @objc func save() {
        dataManager.saveContext()
    }

    private func fetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
}

extension WeightViewController: UITableViewDataSource {
    // MARK: Table View data source methods

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }

        let sectionInfo = sections[section]
        if sectionInfo.numberOfObjects == 0 {
            showBackgroundView()
            return 0
        }

        hideBackgroundView()
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WeightCell

        configureCell(cell, at: indexPath)

        return cell
    }
}

extension WeightViewController {
    // MARK: Table view cell setup method

    func configureCell(_ cell: WeightCell, at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
        let weightChangeBetweenDays = calculateWeightChange(for: item, at: indexPath)

        cell.dateLabel.text = item.isDateToday() ? "Today" : item.createdAtString()
        cell.percentageLabel.textColor = weightChangeBetweenDays < 0.0 ? UIColor.systemRed : UIColor.systemGreen
        cell.weightLabel.text = "Weight - \(item.formattedWeight())"
        cell.percentageLabel.text = String(format: "%.1f%%", weightChangeBetweenDays)
        cell.numberOfDaysLabel.text = "Day \(fetchedObjects.count - indexPath.row)"
    }
}

extension WeightViewController {
    private func calculateWeightChange(for record: Record, at indexPath: IndexPath) -> Float {
        var change = Float(0.0)
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return change }

        if fetchedObjects.count > indexPath.row + 1 {
            let newIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let previousItem = fetchedResultsController.object(at: newIndexPath)
            let previousWeight = previousItem.weight
            change = ((record.weight - previousWeight) / previousWeight) * 100.0
        }
        return change
    }
}

extension WeightViewController: NSFetchedResultsControllerDelegate {
    // MARK: NSFetchedResultsController delegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch (type) {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
            }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
            default:
                break
        }
    }
}
