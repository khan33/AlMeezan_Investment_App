//
//  IndicesExpandCell.swift
//  AlMeezan
//
//  Created by Atta khan on 23/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts

class IndicesExpandCell: UITableViewCell {
    
    @IBOutlet weak var KSELBL: UILabel!
    @IBOutlet weak var valueLbl1: UILabel!
    @IBOutlet weak var valueLbl2: UILabel!
    @IBOutlet weak var valueLbl3: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var previousLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var volumePKRLbl: UILabel!
    @IBOutlet weak var volumeShareLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    @IBOutlet weak var dayRangeLbl2: UILabel!
    @IBOutlet weak var dayRangeLbl1: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var monthRangeLbl1: UILabel!
    @IBOutlet weak var monthRangeLbl2: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var tenHourBtn: UIButton!
    @IBOutlet weak var oneDayBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var threeMonthBtn: UIButton!
    
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.roundCornersWithoutShadow([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 8, borderColor: UIColor.themeColor, borderWidth: 0.1)
        tenHourBtn.roundCornersWithoutShadow([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 6, borderColor: UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.6), borderWidth: 0.4)
        threeMonthBtn.roundCornersWithoutShadow([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 6, borderColor: UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.6), borderWidth: 0.4)
    }
    
    var data: PSXIndixesModel? {
        didSet {
            guard let list = data else {
                return
            }
            KSELBL.text = list.symbol
           
            
            if let currentIndex = list.currentIndex {
                valueLbl1.text = String(format: "%.2f", Float(currentIndex)).toCurrencyFormat(withFraction: true)
            } else {
                valueLbl2.text = "-"
            }
            
            if let netChange = list.netChange {
                valueLbl2.text = String(format: "%.2f", Float(netChange)).toCurrencyFormat(withFraction: true)
            } else {
                valueLbl2.text = "-"
            }
            
            
            if let pNetChange = list.pNetChange {
                let netValue = String(format: "%.2f", Float(pNetChange)).toCurrencyFormat(withFraction: true)
                valueLbl3.text = "\(netValue)%"
            } else {
                valueLbl3.text = "-"
            }
            
            if let previousIndex = list.previousIndex {
                previousLbl.text = String(format: "%.2f", Float(previousIndex)).toCurrencyFormat(withFraction: true)
            } else {
                previousLbl.text = "-"
            }
            
            
            
            if let highVal = list.high {
                highLbl.text = String(format: "%.2f", Float(highVal)).toCurrencyFormat(withFraction: true)
            } else {
                highLbl.text = "-"
            }
            
            if let lowVal = list.low {
                lowLbl.text = String(describing: lowVal).toCurrencyFormat(withFraction: true)
                   // String(format: "%.2f", (lowVal)).toCurrencyFormat()
            } else {
                lowLbl.text = "-"
            }
            
            
            //return Utility.shared.formatPoints(num: value)
            
//            volumeShareLbl.text = "\(String(describing:list.volume?.kmFormatted ?? "0"))"
//            volumePKRLbl.text = "\(String(describing:list.value?.kmFormatted ?? "0"))"

            volumeShareLbl.text = "\(String(describing:  Utility.shared.formatPoints(num: list.volume ?? 0.0) ?? "0"))"
            volumePKRLbl.text = "\(String(describing: Utility.shared.formatPoints(num: list.value ?? 0.0) ?? "0"))"
            
            if let dayMaxValue = list.dayMax {
                dayRangeLbl1.text = String(format: "%.2f", Float(dayMaxValue)).toCurrencyFormat(withFraction: true)
            } else {
                dayRangeLbl1.text = "-"
            }
            
            if let dayMinValue = list.dayMin {
                dayRangeLbl2.text = String(format: "%.2f", Float(dayMinValue)).toCurrencyFormat(withFraction: true)
            } else {
                dayRangeLbl2.text = "-"
            }
            if let monthMaxValue = list.monthMax {
                monthRangeLbl2.text = String(format: "%.2f", Float(monthMaxValue)).toCurrencyFormat(withFraction: true)
            } else {
                monthRangeLbl2.text = "-"
            }
            
            if let monthMinValue = list.monthMin {
                monthRangeLbl1.text = String(format: "%.2f", Float(monthMinValue)).toCurrencyFormat(withFraction: true)
            } else {
                monthRangeLbl1.text = "-"
            }
            
            chartView.updateChart(dataPoints: list.trend!.count, values: list.trend!)
        }
    } 
    
    var chartData: [PSXIndixesTrend]? {
        didSet {
            guard let data = chartData else {
                return
            }
            if data[0].isDayTrend == true {
                timeLbl.text = "Days"
            } else {
                timeLbl.text = "Time"
            }
            chartView.updateChart(dataPoints: data.count, values: data)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension LineChartView {
    
    private class ChartFormatter: NSObject, AxisValueFormatter {
        var labels: [PSXIndixesTrend] = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if let date = labels[Int(value)].entrydatetime {
                var dateStr = ""
                if labels[0].isDayTrend == true {
                    dateStr = Utility.shared.dateTimeConverstion(date, "d MMM")
                } else {
                    dateStr = Utility.shared.dateTimeConverstion(date, "HH:mm")
                }
                return dateStr
            }
            return ""
        }
        
        init(labels: [PSXIndixesTrend]) {
            super.init()
            self.labels = labels
        }
    }
    
    func updateChart(dataPoints: Int, values: [PSXIndixesTrend]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints {
            let y = values[i].currentIndex!
            let date = values[i].entrydatetime
            print("current date is = \(date)")
            var dateVal = ""
            if values[0].isDayTrend == true {
                dateVal = Utility.shared.dateTimeConverstion(date!, "d MMM")
            } else {
                dateVal = Utility.shared.dateTimeConverstion(date!, "HH:mm")
            }
            
            let dataEntry = ChartDataEntry(x: Double(i), y: y, data: dateVal)
            dataEntries.append(dataEntry)
        }
        
        let set1 = LineChartDataSet(entries: dataEntries, label: "")
        
        set1.setColor(UIColor.themeColor)
        set1.lineWidth = 2.0
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
        let chartFormatter = ChartFormatter(labels: values)
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
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.granularityEnabled = false
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .decimal
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        //ChartValueFormatter(numberFormatter: numberFormatter)
        let marker = XYMarkerView1(color: UIColor.themeColor, font: UIFont(name: "CircularStd-Book", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        
        marker.lblString = "Index"
        if values[0].isDayTrend == true {
            marker.lbl2String = "Day"
            
        } else {
            marker.lbl2String = "Time"
        }
        
        self.marker = marker
        
        
//        let customMarker: CustomMarkerView = (CustomMarkerView.viewFromXib() as? CustomMarkerView)!
//        customMarker.chartView = self
//        self.marker = customMarker
        self.dragDecelerationFrictionCoef = 0.9
        
        self.setExtraOffsets(left: 00, top: 0, right: 40, bottom: 0)
        self.xAxis.avoidFirstLastClippingEnabled = false
        self.animate(xAxisDuration: 1.0)
        self.rightAxis.enabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.legend.form = .none
        self.data = data

    }
}
