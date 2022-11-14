//
//  CommodityViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 22/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts

class CommodityViewCell: UITableViewCell {
    
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var threeMonthBtn: UIButton!
    @IBOutlet weak var sixMonthBtn: UIButton!
    @IBOutlet weak var oneYearBtn: UIButton!
    
    
    @IBOutlet weak var differencLbl: UILabel!
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var lastdaysLbl: UILabel!
    @IBOutlet weak var rangeLbl: UILabel!
    
    @IBOutlet weak var symoblTypeLbl: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weeklyBtn.roundCornersWithoutShadow([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 6, borderColor: UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.6), borderWidth: 0.4)
        oneYearBtn.roundCornersWithoutShadow([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 6, borderColor: UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.6), borderWidth: 0.4)
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func yearsBetweenDate(startDate: Date, endDate: Date) ->  DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month,.year], from: startDate, to: endDate)
        return components
    }
    
    var trend: [Trend]? {
        didSet {
            guard  let data = trend else {
                return
            }
            let startDate   =  data[0].date!.toDate()! //data.trend![0].date!.toDate()!
            let total       =   data.count - 1
            let enddate     =   data[total].date!.toDate()!
            let day = enddate.interval(ofComponent: .day, fromDate: startDate)
            let dateComponents = yearsBetweenDate(startDate: startDate, endDate: enddate)
            
            if  let day = dateComponents.day {
                var dayStr = "Day"
                if day > 1 {
                    dayStr += "s"
                }
                lastdaysLbl.text = "Last \(day) \(dayStr)"
            }
            if let month = dateComponents.month, month != 0 {
                var monthStr = "Month"
                if month > 1 {
                    monthStr += "s"
                }
                lastdaysLbl.text = "Last \(month) \(monthStr)"
            }
            if let year = dateComponents.year, year != 0 {
                lastdaysLbl.text = "Last \(year) Year"
            }
        }
        
        
    }
    
    
    
    var commodity: CommoditiesModel? {
        didSet {
            guard  let data = commodity else {
                return
            }
            
            
            openLbl.text = "\(String(describing:data.open ?? 0).toCurrencyFormat(withFraction: true))"
            differencLbl.text = "\(String(describing:data.diff ?? 0).toCurrencyFormat(withFraction: true)) / \(String(describing:data.perc ?? 0))%"
            highLbl.text    = "\(String(describing:data.high ?? 0).toCurrencyFormat(withFraction: true))"
            lowLbl.text     = "\(String(describing:data.low ?? 0).toCurrencyFormat(withFraction: true))"
            rangeLbl.text   = "\(String(describing:data.range ?? 0).toCurrencyFormat(withFraction: true))"
            if data.symbol == "Oil Wti" {
                symoblTypeLbl.text = "USD"
                symbolLbl.text = "USD"
            } else {
                symoblTypeLbl.text = "USD/OZ"
                symbolLbl.text = "USD/OZ"
            }
            lineChartView.setChart(data.trendWeekly!.count, data.trendWeekly!, data.symbol!)
        }
    }
    // update chart by tapping duration button
    var chartData: [Trend]? {
        didSet {
            guard let data = chartData else {
                return
            }
            lineChartView.setChart(data.count, data, "")
        }
    }
    
    
    
}
extension LineChartView {
//    class ChartValueFormatter: NSObject, IValueFormatter {
//        fileprivate var numberFormatter: NumberFormatter?
//
//        convenience init(numberFormatter: NumberFormatter) {
//            self.init()
//            self.numberFormatter = numberFormatter
//        }
//
//        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//            guard let numberFormatter = numberFormatter
//                else {
//                    return ""
//            }
//            return numberFormatter.string(for: value)!
//        }
//    }

    class LineChartFormatter: NSObject, AxisValueFormatter {
        var labels: [Trend] = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            var val = value
            if val < 0 {
                val = 0
            }
            
            if Int(val) < labels.count {
            
                let date = labels[Int(val)].date
                let dateVal = date?.toDate()
                let dateStr = (dateVal?.toString(format: "d MMM"))!
                return dateStr
            }
            return ""
        }
        
        init(labels: [Trend]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setChart(_ dataPoints: Int, _ values: [Trend], _ symbol: String) {
        var dataEntries: [ChartDataEntry] = []
        
        
        for i in 0..<dataPoints {
            if let y = values[i].close {
                let y = Double(y)
                let date = values[i].date
                let dateVal = date?.toDate()
                let dateStr = (dateVal?.toString(format: "d MMM, YYYY"))!
                let dataEntry = ChartDataEntry(x: Double(i), y: y, data: dateStr)
                dataEntries.append(dataEntry)
            }
        }
        
        let set1 = LineChartDataSet(entries: dataEntries, label: "")
        
        set1.setColor(UIColor.themeColor)
        set1.lineWidth = 2.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawFilledEnabled = true
        set1.mode = LineChartDataSet.Mode.cubicBezier
        
        let gradientColors = [UIColor.init(rgb: 0xA7A7A7).cgColor, UIColor.init(rgb: 0xFFFFFF).cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
       // set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        
        let xAxis = self.xAxis
        let chartFormatter = LineChartFormatter(labels: values)
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.labelTextColor = UIColor(red: 91/255, green: 95/255, blue: 120/255, alpha: 1)
        xAxis.valueFormatter = chartFormatter
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularity = 1
        
        let leftAxis = self.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        leftAxis.labelTextColor = UIColor(red: 91/255, green: 95/255, blue: 120/255, alpha: 1)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .decimal
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        let marker = XYMarkerView1(color: UIColor.themeColor, font: UIFont(name: "CircularStd-Book", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        
        if symbol == "Oil Wti" {
            marker.lblString = "USD"
        } else {
            marker.lblString = "USD/OZ"
        }
        marker.lbl2String = "Date"
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        self.marker = marker
        
        self.xAxis.avoidFirstLastClippingEnabled = false
        self.animate(xAxisDuration: 1.5)
        self.rightAxis.enabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.setExtraOffsets(left: 0, top: 0, right: 40, bottom: 0)
        self.legend.form = .none
        self.data = data

    }
}
open class XYMarkerView1: BalloonMarker {
    var lblString: String = "Value"
    var lbl2String: String = "Date"
    override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let x = entry.data as! String
        let y = String.init(format: "%.2f", entry.y).toCurrencyFormat(withFraction: false)
        setLabel("\(lblString): \(y) \n \(lbl2String): \(x)")
    }
}
