//
//  SummeryDetailCell.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts

class SummeryDetailCell: UITableViewCell {
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var MYTD_value: UILabel!
    @IBOutlet weak var FYTD_value: UILabel!
    @IBOutlet weak var inception_value: UILabel!
    @IBOutlet weak var fund_short_name: UILabel!
    @IBOutlet weak var repurchase_price: UILabel!
    @IBOutlet weak var offer_price: UILabel!
    @IBOutlet weak var nav_price: UILabel!
    @IBOutlet weak var offerPriceBtnImg: UIButton!
    @IBOutlet weak var detailBtn: MyButton!
    @IBOutlet weak var repurchaseBtnImg: UIButton!
     @IBOutlet weak var navBtnImg: UIButton!
    @IBOutlet weak var nav_history_dates: UILabel!
    
    @IBOutlet weak var total_days: UILabel!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        repurchase_price.text = "-"
        offer_price.text = "-"
        nav_price.text = "-"
        MYTD_value.text = "-"
        FYTD_value.text = "-"
        inception_value.text = "-"
        
    }
    var nav_history: FundHistoryModel? {
        didSet {
            guard let history = nav_history else { return }
            let count = history.history?.count ?? 0
            guard let historyArray = history.history else { return }
            
            //let historyArray = Array(values)
            
            total_days.text         = "Last Active \(count) Days"
            let start_date_history  = historyArray[0].nav_date?.toDate()
            let end_date_history    = historyArray[count - 1].nav_date?.toDate()
            
            let start_date = start_date_history?.toString(format: "MMM d, yyyy") ?? ""
            let end_date = end_date_history?.toString(format: "MMM d, yyyy") ?? ""
            
            
            nav_history_dates.text = "\(start_date) - \(end_date)"
            
            setChart(dataPoints: count, values: historyArray)
        }
    }
    
  var nav_performance_data: NavPerformance? {
        didSet {
            guard let performance = nav_performance_data else { return }
            fund_short_name.text    = performance.fundshortname
            if let sign = performance.sign {
                if sign == "+" {
                    repurchaseBtnImg.setImage(UIImage(named: "upArrowWhite"), for: .normal)
                    offerPriceBtnImg.setImage(UIImage(named: "upArrowWhite"), for: .normal)
                    navBtnImg.setImage(UIImage(named: "upArrowWhite"), for: .normal)
                    
                } else {
                    repurchaseBtnImg.setImage(UIImage(named: "downArrowWhite"), for: .normal)
                    offerPriceBtnImg.setImage(UIImage(named: "downArrowWhite"), for: .normal)
                    navBtnImg.setImage(UIImage(named: "downArrowWhite"), for: .normal)
                }
            }
            let redemptionPrice = performance.redemptionPrice
            if redemptionPrice != 0.0 {
                repurchase_price.text = "\(String(describing: redemptionPrice).numberFormatter())"
                repurchaseBtnImg.isHidden = false
            } else {
                repurchaseBtnImg.isHidden = true
                repurchase_price.text = "-"
            }
            let offerPrice = performance.offerPrice
            if offerPrice != 0.0 {
                offer_price.text = "\(String(describing: offerPrice).numberFormatter())"
                offerPriceBtnImg.isHidden = false
            } else {
                offerPriceBtnImg.isHidden = true
                offer_price.text = "-"
            }
            let navPprice = performance.nAVPrice
            if navPprice != 0.0 || navPprice != 0 {
                nav_price.text = "\(String(describing: navPprice).numberFormatter())"
                navBtnImg.isHidden = false
            } else {
                nav_price.text = "-"
                navBtnImg.isHidden = true
            }
            
            
            let mytdValue = performance.mTD
            
//            let mytdValue = String(format: "%.2f", Float(performance.cYTD))
            if mytdValue != 0.0 {
                MYTD_value.text = "\(String(describing: mytdValue).toCurrencyFormat(withFraction: true))%"
            } else {
                MYTD_value.text = "-"
            }
            let fytdValue = performance.fY.rounded(toPlaces: 2)
            if fytdValue != 0.0 {
                FYTD_value.text = "\(String(describing: fytdValue).toCurrencyFormat(withFraction: true))%"
            } else {
                FYTD_value.text = "-"
            }
            let inception = performance.sinceInception
            if inception != 0.0 {
                inception_value.text = "\(String(describing: inception).toCurrencyFormat(withFraction: true))%"
            } else {
                inception_value.text = "-"
            }
            
            detailBtn.setTitle("Go to \(performance.fundshortname!) for more Details", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setChart(dataPoints: Int, values: [History]) {
        var dataEntries: [ChartDataEntry] = []
        
        
        for i in 0..<dataPoints {
            let y = values[i].nav_value!
            let date = values[i].nav_date
            let dateVal = date?.toDate()
            let dateStr = (dateVal?.toString(format: "d MMM, YYYY"))!
            let dataEntry = ChartDataEntry(x: Double(i), y: y, data: dateStr)
            dataEntries.append(dataEntry)
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
        //set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.labelTextColor = UIColor(red: 91/255, green: 95/255, blue: 120/255, alpha: 1)
        
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.axisMinimum = 1.0
        xAxis.axisMaximum = 30
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        leftAxis.labelTextColor = UIColor(red: 91/255, green: 95/255, blue: 120/255, alpha: 1)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        
        
        let marker = XYMarkerView1(color: UIColor.themeColor, font: UIFont(name: "CircularStd-Book", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        lineChart.marker = marker
        marker.lbl2String = "Date"
        lineChart.animate(xAxisDuration: 0.9)
        lineChart.rightAxis.enabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.setExtraOffsets(left: 0, top: 0, right: 40, bottom: 0)
        lineChart.legend.form = .none
        lineChart.data = data
    }
}

