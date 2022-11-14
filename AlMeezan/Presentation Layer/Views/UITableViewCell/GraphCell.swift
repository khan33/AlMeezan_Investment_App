//
//  GraphCell.swift
//  AlMeezan
//
//  Created by Atta khan on 08/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts

class GraphCell: UITableViewCell {
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var mytdLbl: UILabel!
    @IBOutlet weak var fytdLbl: UILabel!
    @IBOutlet weak var sinceInceptionlbl: UILabel!
    @IBOutlet weak var retrunFundLbl: UILabel!
    @IBOutlet weak var CAGR_Value: UILabel!
    
    
    var currentYear = Calendar.current.component(.year, from: Date())
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(currentYear)
        
    }
    var data: FundDescription? {
        didSet {
            guard let graph_data = data else { return }
            
            let mtd = graph_data.mtd
            mytdLbl.text = "\(String(describing: mtd).numberFormatter())%"
            let fytd = graph_data.fYTD
            fytdLbl.text = "\(String(describing: fytd).numberFormatter())%"
            let sinceInception = graph_data.sinceInception
            sinceInceptionlbl.text = "\(String(describing: sinceInception).toCurrencyFormat(withFraction: true))%"
            let cagr = graph_data.cAGR
            CAGR_Value.text = "\(String(describing: cagr).numberFormatter())%"
            if let fund_name = graph_data.mnemonic {
                retrunFundLbl.text = "\(fund_name) Returns"
            }
            
            self.setChartData(graph_data)
        }
    }
    
    
    func setChartData(_ data: FundDescription) {
        
        chartView.setExtraOffsets(left: 20, top: -30, right: 20, bottom: 10)
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.chartDescription.enabled = false
        
        
        let chartFormater = ChartAxisValueFormatter(chart: chartView)
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = chartFormater
        
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 5
        xAxis.granularity = 1
        
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.spaceTop = 0.25
        leftAxis.spaceBottom = 0.25
        leftAxis.zeroLineColor = .gray
        leftAxis.zeroLineWidth = 0.7
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        var years = [Int]()
        
        for i in 0...4 {
            years.append(currentYear - i)
        }
        print(years)
        
        
        var dataEntries: [BarChartDataEntry] = []
        dataEntries = [BarChartDataEntry(x: Double(years[0]), y: data.fYTD),
                     BarChartDataEntry(x: Double(years[1]), y: data.fY1),
                     BarChartDataEntry(x: Double(years[2]), y: data.fY2),
                     BarChartDataEntry(x: Double(years[3]), y: data.fY3),
                     BarChartDataEntry(x: Double(years[4]), y: data.fY4)
        ]
        
        let red = UIColor(red: 245/255, green: 79/255, blue: 79/255, alpha: 1)
        let green = UIColor(red: 71/255, green: 174/255, blue: 10/255, alpha: 1)
        let colors = dataEntries.map { (entry) -> NSUIColor in
            return entry.y > 0 ? green : red
        }
        
        let set = BarChartDataSet(entries: dataEntries, label: "")
        set.colors = colors
        set.valueColors = colors
        set.valueFormatter = ChartAxisValueFormatter(chart: chartView) as! any ValueFormatter
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 10))
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        
        
        
        //data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.barWidth = 0.61
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.legend.form = .none
        chartView.rightAxis.enabled = false
        
        chartView.data = data
    }
}

class ChartAxisValueFormatter: NSObject, AxisValueFormatter, ValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        if Int(value) == currentYear {
            return "FYTD"
        }
        return String(format: "%.0f", value)
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let days = value
        if days.isZero {
            return "-"
        } else {
            return "\(days) %"
        }
    }
    
    weak var chart: BarLineChartViewBase?
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
}
