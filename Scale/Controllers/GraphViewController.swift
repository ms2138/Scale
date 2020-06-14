//
//  GraphViewController.swift
//  Scale
//
//  Created by mani on 2020-06-14.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CorePlot

class GraphViewController: UIViewController {
    @IBOutlet weak var hostView: CPTGraphHostingView!
    var graphData: [Record]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Graph"
    }
}
