//
//  WeightDetailsViewController.swift
//  Scale
//
//  Created by mani on 2020-06-13.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class WeightDetailsViewController: UITableViewController {
    @IBOutlet weak var dateDescriptionCell: UITableViewCell!
    @IBOutlet weak var weightDescriptionCell: UITableViewCell!
    @IBOutlet weak var overallChangeCell: UITableViewCell!
    var weight: String?
    var overallChange: Float?
    var date: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Details"

        setupCells()
    }

}

extension WeightDetailsViewController {
    // MARK: - Setup methods
    
    private func setupCells() {
        if let weight = weight,
            let overallChange = overallChange,
            let date = date {
            overallChangeCell.detailTextLabel?.textColor = overallChange < 0.0 ? UIColor.systemRed : UIColor.systemGreen
            dateDescriptionCell.detailTextLabel?.text = date
            weightDescriptionCell.detailTextLabel?.text = weight
            overallChangeCell.detailTextLabel?.text = String(format: "%.1f%%", overallChange)
        }
    }
}
