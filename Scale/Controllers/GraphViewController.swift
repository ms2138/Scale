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

        initGraph()
    }
}

private extension GraphViewController {
    func initGraph() {
        let graph = CPTXYGraph(frame: hostView.bounds)
        graph.plotAreaFrame?.masksToBorder = false
        graph.plotAreaFrame?.paddingLeft = 20.0
        graph.plotAreaFrame?.paddingBottom = 20.0
        graph.paddingBottom = 30.0
        graph.paddingLeft = 40.0
        graph.paddingTop = 30.0
        graph.paddingRight = 40.0
        graph.titlePlotAreaFrameAnchor = .top
        graph.backgroundColor = UIColor.black.cgColor
        graph.titleDisplacement = CGPoint(x: 0.0, y: 30.0)

        hostView.hostedGraph = graph
    }
}
