//
//  WeightViewController.swift
//  Scale
//
//  Created by mani on 2020-06-07.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class WeightViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataManager = CoreDataManager(modelName: "Scale")
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.dataManager.managedObjectContext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

