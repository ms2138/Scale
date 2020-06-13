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
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
