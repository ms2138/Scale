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
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
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

        navigationItem.leftBarButtonItem = editButtonItem

        tableView.backgroundView = backgroundView
        hideBackgroundView()

        fetch()

        setupNotifications()

        UserDefaults.standard.addObserver(self, forKeyPath: "UnitOfWeight", options: .new, context: nil)
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        Reload the rows if the user has changed the unit of weight
//        
//        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WeightCell {
//            let unit = AppDefaults().unitOfWeight.rawValue == 0 ? "lbs" : "kg"
//
//            if cell.weightLabel.text?.contains(unit) != true {
//                if let indexPaths = tableView.indexPathsForVisibleRows {
//                    tableView.reloadRows(at: indexPaths, with: .automatic)
//                }
//            }
//        }
//    }

    deinit {
        removeObserver(self, forKeyPath: "UnitOfWeight")
    }
}



extension WeightViewController {
    // MARK: Observer methods

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        calculateUnitOfWeight()
    }
}

extension WeightViewController {
    // MARK: Editing methods

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.setEditing(editing, animated: animated)
    }
}

extension WeightViewController {
    // MARK: Notification methods

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
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

    private func calculateUnitOfWeight() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext)
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)

        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        let unit = AppDefaults().unitOfWeight
        if unit == .pounds {
            batchUpdateRequest.propertiesToUpdate = ["weight": NSExpression(format: "weight / 0.4535924", argumentArray: [])]
        } else {
            batchUpdateRequest.propertiesToUpdate = ["weight": NSExpression(format: "weight * 0.4535924", argumentArray: [])]
        }

        do {
            let batchUpdateResult = try managedObjectContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            let objectIDs = batchUpdateResult.result as! [NSManagedObjectID]

            for objectID in objectIDs {
                let managedObject = managedObjectContext.object(with: objectID)
                managedObjectContext.refresh(managedObject, mergeChanges: false)
            }
            fetch()
        } catch {
            print("Failed to update items: \(error)")
        }
    }
}

extension WeightViewController: UITableViewDelegate {
    // MARK: Table View delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: "showEditDatePicker", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let item = fetchedResultsController.object(at: indexPath)

        managedObjectContext.delete(item)
    }
}

extension WeightViewController {
    // MARK: Table view cell setup method

    func configureCell(_ cell: WeightCell, at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
        let weightChangeBetweenDays = calculateWeightChange(for: item, at: indexPath)

        let unitOfWeight = AppDefaults().unitOfWeight
        cell.dateLabel.text = item.isDateToday() ? "Today" : item.createdAtString()
        cell.percentageLabel.textColor = weightChangeBetweenDays < 0.0 ? UIColor.systemRed : UIColor.systemGreen
        cell.weightLabel.text = "Weight - \(item.formatWeight(for: unitOfWeight))"
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
            case .update:
                if let indexPath = indexPath {
                    if let cell = tableView.cellForRow(at: indexPath) as? WeightCell {
                        configureCell(cell, at: indexPath)
                    }
            }
            case .move:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }

                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            default:
                break
        }
    }
}

extension WeightViewController {
    // MARK: - Segue methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showAddWeight":
                let navController = segue.destination as! UINavigationController
                guard let viewController = navController.topViewController else { return }
                let vc = viewController as! AddWeightViewController
                vc.dataManager = dataManager
            case "showEditDatePicker":
                if let indexPath = tableView.indexPathForSelectedRow {
                    let navController = segue.destination as! UINavigationController
                    guard let viewController = navController.topViewController else { return }
                    let vc = viewController as! DatePickerViewController
                    let record = fetchedResultsController.object(at: indexPath)
                    vc.currentDate = record.createdAt
                    vc.dateChangedHandler = { date in
                        record.createdAt = date
                    }
            }
            case "showWeightDetails":
                if let indexPath = tableView.indexPathForSelectedRow {
                    let item = fetchedResultsController.object(at: indexPath)
                    let vc = segue.destination as! WeightDetailsViewController
                    vc.record = item
                    vc.overallChange = calculateWeightChange(for: item, at: indexPath)
                    vc.managedObjectContext = managedObjectContext
            }
            default:
                preconditionFailure("Segue identifier did not match")
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
}
