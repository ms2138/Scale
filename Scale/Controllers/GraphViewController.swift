//
//  GraphViewController.swift
//  Scale
//
//  Created by mani on 2020-06-14.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CorePlot
import CoreData

class GraphViewController: UIViewController {
    @IBOutlet weak var hostView: CPTGraphHostingView!
    var managedObjectContext: NSManagedObjectContext?
    private var graphData: [Record]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Graph"

        initGraph()
        initScatterPlot()
        setupAxis()
        setupGraphData()

        configurePlotSpace()
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
        graph.titleDisplacement = CGPoint(x: 0.0, y: 30.0)

        hostView.hostedGraph = graph
    }

    func initScatterPlot() {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineJoin = .round
        lineStyle.lineCap = .round
        lineStyle.lineWidth = 2.5
        lineStyle.lineColor = CPTColor.black()

        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill = CPTFill(color: CPTColor.black())
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

    func setupAxis() {
        guard let graph = hostView.hostedGraph else { return }
        let axisSet = graph.axisSet as! CPTXYAxisSet

        let titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.black()
        titleStyle.fontName = "HelveticaNeue-Bold"
        titleStyle.fontSize = 10.0
        titleStyle.textAlignment = .center

        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "HelveticaNeue-Bold"
        textStyle.fontSize = 10.0
        textStyle.textAlignment = .center

        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor.black()
        lineStyle.lineWidth = 5

        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.gray()
        gridLineStyle.lineWidth = 0.5


        if let x = axisSet.xAxis {
            x.title = "Number of days"
            x.titleTextStyle = titleStyle
            x.titleOffset = 25.0
            x.labelTextStyle = textStyle
            x.axisLineStyle = lineStyle
            x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
        }

        if let y = axisSet.yAxis {
            y.title = "Weight"
            y.titleOffset = 38.0
            y.titleTextStyle = titleStyle
            y.majorIntervalLength   = 5
            y.minorTicksPerInterval = 2
            y.labelTextStyle = textStyle
            y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)),
                                      CPTFill(color: CPTColor.init(componentRed: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0))]
            y.axisLineStyle = lineStyle
            y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
        }
    }

    func setupGraphData() {
        guard let context = managedObjectContext else { return }
        let fetchRequest:NSFetchRequest<Record> = Record.fetchRequest()
        let sortByCreatedAt = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortByCreatedAt]
        do {
            graphData = try context.fetch(fetchRequest)
        } catch {
            print("Failed to perform fetch request: \(error)")
        }
    }

    func configurePlotSpace() {
        guard let graph = hostView.hostedGraph else { return }
        guard let context = managedObjectContext else { return }
        let fetchRequest:NSFetchRequest<Record> = Record.fetchRequest()
        let sortByWeight = NSSortDescriptor(key: "weight", ascending: true)
        fetchRequest.sortDescriptors = [sortByWeight]
        do {
            let weightData = try context.fetch(fetchRequest)

            let xMin = 1.0
            let xMax = Double(weightData.count)
            let yMin = Double(weightData[0].weight / 2)
            let yMax = Double(weightData[weightData.count - 1].weight)

            guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
            plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax))
            plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax))
        } catch {
            print("Failed to perform fetch request: \(error)")
        }
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
