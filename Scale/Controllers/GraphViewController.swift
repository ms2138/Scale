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
        initScatterPlot()
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

    func initScatterPlot() {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineJoin = .round
        lineStyle.lineCap = .round
        lineStyle.lineWidth = 2.5
        lineStyle.lineColor = CPTColor.white()

        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill = CPTFill(color: CPTColor.white())
        plotSymbol.lineStyle = lineStyle
        plotSymbol.size = CGSize(width: 6.0, height: 6.0)

        let plot = CPTScatterPlot()
        plot.dataLineStyle = lineStyle
        plot.plotSymbol = plotSymbol
        plot.curvedInterpolationOption = .catmullCustomAlpha
        plot.interpolation = .curved
        guard let graph = hostView.hostedGraph else { return }
        plot.dataSource = (self as CPTPlotDataSource)
        graph.add(plot, to: graph.defaultPlotSpace)
    }
}

extension GraphViewController: CPTScatterPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        guard let graphData = graphData else { return 0 }
        return UInt(graphData.count)
    }

    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        switch CPTScatterPlotField(rawValue: Int(field))! {
            case .X:
                return NSNumber(value: Int(record))
            case .Y:
                guard let graphData = graphData else { return 0 }
                let record = graphData[Int(record)]
                return record.weight as NSNumber
            default:
                return 0
        }
    }
}
