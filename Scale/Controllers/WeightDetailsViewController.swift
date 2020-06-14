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
    }

}
