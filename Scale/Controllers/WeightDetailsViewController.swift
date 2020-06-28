//
//  WeightDetailsViewController.swift
//  Scale
//
//  Created by mani on 2020-06-13.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class WeightDetailsViewController: UITableViewController {
    @IBOutlet weak var dateDescriptionCell: UITableViewCell!
    @IBOutlet weak var weightDescriptionCell: UITableViewCell!
    @IBOutlet weak var overallChangeCell: UITableViewCell!
    var record: Record?
    var overallChange: Float?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Details"

        setupCells()
    }

}

extension WeightDetailsViewController {
    // MARK: - Setup methods
    
    private func setupCells() {
        if let overallChange = overallChange {
            overallChangeCell.detailTextLabel?.textColor = overallChange < 0.0 ? UIColor.systemRed : UIColor.systemGreen
            updateWeightInformation()
        }
    }

    func updateWeightInformation() {
        if let overallChange = overallChange,
            let record = record {
            let unitOfWeight = AppDefaults().unitOfWeight

            dateDescriptionCell.detailTextLabel?.text = record.createdAtString()
            weightDescriptionCell.detailTextLabel?.text = record.formatWeight(for: unitOfWeight)
            overallChangeCell.detailTextLabel?.text = String(format: "%.1f%%", overallChange)
        }
    }
}

extension WeightDetailsViewController {
    // MARK: - Segue methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showGraph":
                let viewController = segue.destination
                let vc = viewController as! GraphViewController
                vc.managedObjectContext = managedObjectContext
            default:
                preconditionFailure("Segue identifier did not match")
        }
    }
}
