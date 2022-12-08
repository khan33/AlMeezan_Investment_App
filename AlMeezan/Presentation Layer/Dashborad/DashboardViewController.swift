//
//  DashboardViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 05/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import SwiftKeychainWrapper

struct User {
    var firstName: String?
    var lastName: String?
}


class DashboardViewController: UIViewController {
   
    @IBOutlet weak var totalInvestmentAmountLbl: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var totalPurchaseLbl: UILabel!
    @IBOutlet weak var totalWithDrawLbl: UILabel!
    @IBOutlet weak var marketValueLbl: UILabel!
    @IBOutlet weak var portfolioLbl: UILabel!
    @IBOutlet weak var tableView: InnerTableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalPortfolioAmountLbl: UILabel!
    @IBOutlet weak var percentageLbl: UILabel!
    @IBOutlet weak var idLbl: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var expandableBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var investorNameLbl: UILabel!
    @IBOutlet weak var totalIncomeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0	
    var customerInvestment: [CustomerInvestment]?
    var totalInvestmentAmount: Double = 0.0
    var selectedPortfolioID: Int = 0
    var purchaseValue: Float   =   0.0
    var withdrawValue: Float   =   0.0
    var marketValue: Double     =   0.0
    var isScrolled: Bool = false
    var extraCell = 1
    var count: Int = 4
    var isExpanded: Bool = true
    var investmentArray = [Summary]()
    var acutallSummaryArr = [Summary]()
    var notification_list: [NotificationList]?
    var cellHeight = 60
    var totalGain: Float = 0.0
    var totalLoss: Float = 0.0
    var totalIncome: Float = 0.0
    var isSurveyShow: Int = 0
    
   // var interactor: DashboardInteractorProtocol?
   // var router: DashboardRouterProtocol?
    
    @IBOutlet weak var accountStatementIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //router?.navigationController = navigationController

        let isShow = UserDefaults.standard.integer(forKey: "isSurveyShow")
        if isShow == 1 {
            //setupViews()
        }
        
        if isFromSideMenu {
            navigateControllerForLoggedInUser(selectedMenuItem)
        } else {
            
        }
        dateLbl.text = ""
        segmentControl.defaultConfiguration()
        segmentControl.selectedConfiguration()
        self.scrollView.delegate = self
        getNotificationData()
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.isSessionExpire), name: .sessionExpire, object: nil)
        countNotificationLbl.isHidden = true
        tableView.isScrollEnabled = false
        expandableBtn.setImage(UIImage(named: "down_Arrow"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAccountStatement))
        accountStatementIcon.addGestureRecognizer(tap)
        accountStatementIcon.isUserInteractionEnabled = true

        
        
    }
    func setupViews() {
        let vc =  SurveyViewController()
        SurveyViewConfigurator.configureModule(viewController: vc)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(countNotificationLbl)
        scrollView.flashScrollIndicators()
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
        Utility.shared.analyticsCode("dashboard")
    }
    
    @objc func isSessionExpire(notification: NSNotification) {
        self.showAlertViewWithTitle(title: "Alert", message: "Your session has been expired. Please login again.") {
            KeychainWrapper.standard.set("ibex", forKey: "CustomerId")
            KeychainWrapper.standard.set("_!b3xGl0b@L", forKey: "AccessToken")
            KeychainWrapper.standard.set("anonymous", forKey: "UserType")
        }
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InvestmentFundHeaderCell.nib, forCellReuseIdentifier: InvestmentFundHeaderCell.identifier)
        tableView.register(InvestmentFundCell.nib, forCellReuseIdentifier: InvestmentFundCell.identifier)
        tableView.register(InvestmentFundBottomCell.nib, forCellReuseIdentifier: InvestmentFundBottomCell.identifier)
        tableView.reloadData()
        heightConstraint.constant = tableView.contentSize.height + 90
    }
    
    func getNotificationData() {
        var guest_key = ""
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth != "loggedInUser" {
                if let key = UserDefaults.standard.string(forKey: "guestkey") {
                    guest_key = key
                }
            }
        }
        let bodyParam = RequestBody(Key:guest_key)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: NOTIFICATION_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Notification list", modelType: NotificationList.self, errorMessage: { (errorMessage) in
            //self.errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.notification_list = response
            let filterList = self.notification_list?.filter( { $0.read == 0 } )
            totalUnreadNotify = filterList?.count ?? 0
            UserDefaults.standard.set(totalUnreadNotify, forKey: "totalNotification")
            Utility.shared.renderNotificationCount(self.countNotificationLbl)
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }

    func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: CUSTOMER_INVESTMENT)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: CustomerInvestment.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.customerInvestment = response
            self.setUpTableView()
            
            for(index, _) in (self.customerInvestment?.enumerated())! {
                if self.customerInvestment?[index].portfolioID?.contains("-") ?? false {
                    let total = self.customerInvestment?[index].summary?.map( { Double($0.marketValue )} ).reduce(0, +)
                    
                    self.totalInvestmentAmount += total ?? 0.0
                } else {
                    self.customerInvestment?[index].portfolioID = Message.allPortfolio
                }
            }
            self.totalInvestmentAmountLbl.text = "\(String(describing: self.totalInvestmentAmount ).toCurrencyFormat(withFraction: false))"
            
            self.updateUI()
            self.tableViewRefresh()
            
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)

    }
    func filterPortfolioIds() {
        let portfolioID = self.customerInvestment?[self.selectedPortfolioID].portfolioID
        if portfolioID?.contains("-") ?? false {
            let ids = portfolioID?.components(separatedBy: "-")
               let id = Int(ids?[1] ?? "0")!
            let isExist = (900...999).contains(id)
            if isExist == false {
                UserDefaults.standard.set(portfolioID, forKey: "portfolioId")
            } else {
                UserDefaults.standard.set(self.customerInvestment?[1].portfolioID ?? "", forKey: "portfolioId")
            }
        } else {
            UserDefaults.standard.set(self.customerInvestment?[1].portfolioID ?? "", forKey: "portfolioId")
        }
        
        
    }
    
    func updateUI() {
        investorNameLbl.text = customerInvestment?[selectedPortfolioID].customerName
        self.filterPortfolioIds()
        var fundMarketValue: [String : Double]
        let commonFundGroup: [String]
        let total = customerInvestment?[selectedPortfolioID].summary?.count ?? 0
        investmentArray =   Array(customerInvestment?[selectedPortfolioID].summary ?? [])
        acutallSummaryArr = investmentArray
        investmentArray = investmentArray.sorted(by: {(obj1, obj2) -> Bool in
            let marketValue1 = obj1.marketValue
            let marketValue2 = obj2.marketValue
            return marketValue1 > marketValue2
        })
        if acutallSummaryArr.count > 0 {
            
            var ready = investmentArray.sorted(by: { Utility.shared.dateTimeConverstion($0.nav_date ?? "2019-12-20T00:00:00", "d MMMM, yyyy").compare(Utility.shared.dateTimeConverstion($1.nav_date ?? "2019-12-20T00:00:00", "d MMMM, yyyy")) == .orderedDescending })
                
                
                
//                dateFormatter.date(from:$0).compare(dateFormatter.date(from:$1)) == .orderedDescending })

            
            if let nav_date = acutallSummaryArr[0].nav_date {
                dateLbl.text = "Details as of \(Utility.shared.dateTimeConverstion(nav_date, "d MMMM, yyyy"))"
            }
        }
        purchaseValue   =   investmentArray.map({($0.purchases)}).reduce(0, +)
        withdrawValue   =   investmentArray.map({($0.redemption)}).reduce(0, +)
        marketValue     =   investmentArray.map({($0.marketValue)}).reduce(0, +)
        totalGain       =   investmentArray.map({($0.fYGain)}).reduce(0, +)
        totalLoss       =   investmentArray.map({($0.sinceInceptionGain)}).reduce(0, +)
        totalIncome     =   investmentArray.map({($0.monthyIncome)}).reduce(0, +)
        let navValue        =   investmentArray.map({(Double($0.nav ) )}).reduce(0, +)
        portfolioLbl.text   =   customerInvestment?[selectedPortfolioID].portfolioID
        if purchaseValue == 0 {
            totalPurchaseLbl.text   = "-"
        } else {
            totalPurchaseLbl.text   = "\(String(describing: purchaseValue ).toCurrencyFormat(withFraction: false))"
        }
        if withdrawValue == 0 {
            totalWithDrawLbl.text   =   "-"
        } else {
            totalWithDrawLbl.text   = "\(String(describing: withdrawValue ).toCurrencyFormat(withFraction: false))"
        }
        if marketValue == 0 {
            marketValueLbl.text     =   "-"
        } else {
            marketValueLbl.text     = "\(String(describing: marketValue ).toCurrencyFormat(withFraction: false))"
        }
        if totalIncome == 0 {
            totalIncomeLbl.text     =   "-"
        } else {
            totalIncomeLbl.text     =  "\(String(describing: totalIncome ).toCurrencyFormat(withFraction: false))"
        }
        totalPortfolioAmountLbl.text = "\(String(describing: marketValue ).toCurrencyFormat(withFraction: false))"
        if let id = customerInvestment?[selectedPortfolioID].portfolioID {
            idLbl.setTitle("\(id)", for: .normal)
        }
        let fund_array = investmentArray.filter( { return !$0.marketValue.isZero} )
        commonFundGroup = (fund_array.compactMap({ return $0.fundGroupName?.trimmingCharacters(in: .whitespacesAndNewlines)}).unique())
        fundMarketValue = (fund_array.reduce(([String : Double]())) { accumulator, value in
            var currentData = accumulator
            var commonGroupName = value.fundGroupName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if accumulator.keys.contains(commonGroupName) {
                currentData[commonGroupName] = accumulator[commonGroupName]! + (Double(value.marketValue ) )
                return currentData
            } else {
                currentData[commonGroupName] = Double(value.marketValue )
                return currentData
            }
        })

        for(key, value) in fundMarketValue {
            let totalInvestment = ( value / navValue ) * 100
            fundMarketValue[key] = totalInvestment.rounded()
        }
        
        fundMarketValue = fundMarketValue.filter { $0.value >= 1.0}
        
        setUpPieChart(fundMarketValue, commonFundGroup)
        setUpBarChart(fund_array)
    }
    
    @IBAction func clickOnTransactionsBtn(_ sender: Any) {
        let vc = StatusTransactionsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnportfolioBtn(_ sender: Any) {
        if customerInvestment?.count ?? 0 > 0 {
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 200)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.tag = selectedPortfolioID
            pickerView.selectRow(selectedPortfolioID, inComponent:0, animated:true)
            vc.view.addSubview(pickerView)
            let editRadiusAlert = UIAlertController(title: "Choose Portfolio Id", message: "", preferredStyle: UIAlertController.Style.alert)
            editRadiusAlert.setValue(vc, forKey: "contentViewController")
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
                self.portfolioLbl.text = self.customerInvestment?[self.selectedPortfolioID].portfolioID
                self.updateUI()
                self.tableViewRefresh()
            }))
            self.present(editRadiusAlert, animated: true)
        } else {
            self.showAlert(title: "Alert", message: "No Portfolio Id Exist.", controller: self) {
                
            }
        }
        

   }
    
    
    @objc func didTapOnAccountStatement() {
        print("print web view for account statement")
    }
    
    
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginOption()
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func setCustomLegend(dataPoints: [String], values: [Double]) -> [LegendEntry] {
//        var customLegendEntries: [LegendEntry] = []
//        for i in 0..<dataPoints.count {
//            customLegendEntries.append(LegendEntry(label: dataPoints[i], form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: 0.0, formLineDashLengths: nil, formColor: nil))
//        }
//        return customLegendEntries
//    }
    
    func setUpPieChart(_ values: [String: Double], _ fundNames: [String]) {
        if fundNames.count > 0 {
            let entery = (0..<values.count).flatMap { (i) -> PieChartDataEntry in
                return PieChartDataEntry(value: Double(values[fundNames[i]]!), label: fundNames[i])
            }
            let set = PieChartDataSet(entries: entery, label: "")
            set.drawIconsEnabled = false
            set.sliceSpace = 1
            set.iconsOffset = CGPoint(x: 0, y: 10.0)
//            set.yValuePosition = .insideSlice
            set.selectionShift = 1
            set.colors = ChartColorTemplates.material()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + ChartColorTemplates.vordiplom()
                + [UIColor(red: 231/255, green: 115/255, blue: 10/255, alpha: 1)]
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            
            let l = chartView.legend
            l.horizontalAlignment = .left
            l.verticalAlignment = .bottom
            l.orientation = .vertical
            l.form = .default
            l.drawInside = true
            l.enabled = true
            l.yOffset = -10.0
            
//            chartView.legend = l
            
            let data = PieChartData(dataSet: set)
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 2
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = " %"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
//            data.setValueFormatter()

            data.setValueFont(.systemFont(ofSize: 09, weight: .light))
            data.setValueTextColor(.white)
            
//
            chartView.usePercentValuesEnabled = true
            chartView.chartDescription.enabled = false
            chartView.setExtraOffsets(left: 10, top: 0, right: 0, bottom: CGFloat(5 + values.count))
            chartView.dragDecelerationFrictionCoef = 0.95
            
            chartView.holeColor = UIColor.white
            chartView.transparentCircleColor = UIColor.white
            chartView.transparentCircleRadiusPercent = 0
            chartView.holeRadiusPercent = 0
            chartView.drawCenterTextEnabled = false
            chartView.drawHoleEnabled = false
            chartView.rotationAngle = 10
            chartView.rotationEnabled = true
            chartView.highlightPerTapEnabled = true
            chartView.drawEntryLabelsEnabled = false
            chartView.entryLabelColor = UIColor.white
            chartView.entryLabelFont = UIFont.systemFont(ofSize: 11)
            chartView.data = data
            chartView.highlightValues(nil)
        }
        else {
            chartView.noDataText = "No Funds Available to show chart."
            chartView.data = nil
            chartView.noDataTextColor = UIColor.themeColor
            chartView.notifyDataSetChanged()
        }
    }
    
    func setUpBarChart(_ values: [Summary]) {
        if values.count > 0 {
            
            barChartView.chartDescription.enabled = false
            barChartView.maxVisibleCount = values.count
            barChartView.pinchZoomEnabled = false
            barChartView.drawBarShadowEnabled = false
            barChartView.drawGridBackgroundEnabled = false
            barChartView.drawValueAboveBarEnabled = true
            barChartView.legend.form = Legend.Form.none
            barChartView.rightAxis.enabled = false
            barChartView.scaleXEnabled = false
            barChartView.scaleYEnabled = false
            barChartView.leftAxis.drawGridLinesEnabled = true
            barChartView.leftAxis.drawAxisLineEnabled = false
            barChartView.leftAxis.labelTextColor = UIColor.rgb(red: 90, green: 79, blue: 90, alpha: 1)
            var dataEntries: [BarChartDataEntry] = []
            dataEntries.removeAll()
            
            for (index, _) in (values.enumerated()) {
                let y = Double(values[index].marketValue)
                print("value is = ", y)
                let data = values[index].fundShortName
                let dataEntry = BarChartDataEntry(x: Double(index), y: y, data: data)
                dataEntries.append(dataEntry)
            }
            
            let chartFormater = BarChartFormatter(chart: barChartView, labels: values)
            let xAxis = barChartView.xAxis
            xAxis.valueFormatter = chartFormater
            xAxis.labelPosition = .bottom
            xAxis.labelRotationAngle = 315.0
            xAxis.axisLineColor = UIColor.lightText
            xAxis.yOffset = 15
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = false
            xAxis.centerAxisLabelsEnabled = false
            xAxis.granularity = 1
            xAxis.setLabelCount(values.count, force: false)
            xAxis.labelFont = UIFont(name: "CircularStd-Book", size: 8.0)!
            
            let leftAxis = barChartView.leftAxis
            leftAxis.valueFormatter = LargeValueFormatter()
            leftAxis.drawGridLinesEnabled = true
            leftAxis.axisMinimum = 0.0
            leftAxis.setLabelCount(7, force: true)
            
            
            var set1: BarChartDataSet! = nil
            if let set = barChartView.data?.dataSets.first as? BarChartDataSet {
                set1 = set
                set1.replaceEntries(dataEntries)
                set1.valueFormatter = LargeValueFormatter()
                set1.colors = ChartColorTemplates.material()
                set1.drawValuesEnabled = true
                barChartView.data?.notifyDataChanged()
                barChartView.notifyDataSetChanged()
            } else {
                
                set1 = BarChartDataSet(entries: dataEntries, label: "")
                set1.colors = ChartColorTemplates.material()
                set1.valueFormatter = LargeValueFormatter()
                set1.drawValuesEnabled = true

                let data = BarChartData(dataSet: set1)
                data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
                barChartView.data = data
            }
            
            
            switch values.count {
            case 1:
                xAxis.yOffset = 0
                barChartView.barData?.barWidth = 0.15
                barChartView.setVisibleXRange(minXRange: 0.0, maxXRange: 0.5)
            case 2:
                barChartView.barData?.barWidth = 0.3
                barChartView.setVisibleXRange(minXRange: 1.0, maxXRange: 2.0)
            case 3:
                barChartView.barData?.barWidth = 0.4
                barChartView.setVisibleXRange(minXRange: 1.0, maxXRange: 3.0)
            case 4:
                barChartView.barData?.barWidth = 0.5
                barChartView.setVisibleXRange(minXRange: 1.0, maxXRange: 4.0)
            case 5:
                barChartView.barData?.barWidth = 0.6
                barChartView.setVisibleXRange(minXRange: 1.0, maxXRange: 5.0)
            default:
                barChartView.barData?.barWidth = 0.85
                barChartView.setVisibleXRange(minXRange: 1.0, maxXRange: 6.0)
            }
            
            
            barChartView.fitBars = true
            barChartView.animate(xAxisDuration: 3.5)
            barChartView.setExtraOffsets(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0)
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
            
        } else {
            barChartView.noDataText = "No Funds Available to show chart."
            barChartView.data = nil
            barChartView.noDataTextColor = UIColor.themeColor
            barChartView.notifyDataSetChanged()
        }
    }

    
    @IBAction func changeSegmentAction(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            chartView.isHidden = false
            barChartView.isHidden = true
            percentageLbl.text = "Percentage (%)"
        } else {
            chartView.isHidden = true
            barChartView.isHidden = false
            percentageLbl.text = "PKR"
        }
    }

    @IBAction func backToNavigate(_ sender: Any) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
   
    
    @IBAction func refreshTableView(_ sender: Any) {
        let totalRow = tableView.numberOfRows(inSection: 0)
        
        let isExpanded = customerInvestment?[selectedPortfolioID].isExpandable
        customerInvestment?[selectedPortfolioID].isExpandable = !isExpanded!
        let total = customerInvestment?[selectedPortfolioID].summary?.count ?? 0
        if isExpanded == true {
            expandableBtn.setImage(UIImage(named: "up_arrow"), for: .normal)
            count = total
            extraCell = 2
            tableView.reloadData()
            let totalHeight = cellHeight * ( count + 1 )
            heightConstraint.constant = CGFloat(totalHeight + 90)
        } else {
            extraCell = 1
            count = total > 4 ? 4 : total
            expandableBtn.setImage(UIImage(named: "down_Arrow"), for: .normal)
            tableView.reloadData()
            
            let totalHeight = cellHeight * count
            heightConstraint.constant = CGFloat(totalHeight + 90)
        
        }
    }
    private func tableViewRefresh() {
        extraCell = 1
        let total = customerInvestment?[selectedPortfolioID].summary?.count ?? 0
        count = total > 4 ? 4 : total
        tableView.reloadData()
        let totalHeight = cellHeight * count
        heightConstraint.constant = CGFloat(totalHeight + 90)
    }
}
extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            //print("down")
        } else {
            //print(scrollView.contentOffset.y)
            //print("up")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
}
extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}

private class BarChartFormatter: NSObject, AxisValueFormatter {

    weak var chart: BarLineChartViewBase?
    var labels: [Summary]?
    init(chart: BarLineChartViewBase, labels: [Summary]) {
        self.chart = chart
        self.labels = labels
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var fundName = ""
        do {
            let index = labels?.getElement(at: Int(value))
            fundName = try index?.fundShortName ?? ""
        } catch {
            print("The file could not be loaded")
            fundName = ""
        }
        return fundName
    }
}
class AmountAxisValueFormatter: NSObject, ValueFormatter, AxisValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        return Utility.shared.formatPoints(num: value)
        //return value.kmFormatted
    }
    
    weak var chart: BarLineChartViewBase?
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
   
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Utility.shared.formatPoints(num: value)
    }
}

public class LargeValueFormatter: NSObject, ValueFormatter, AxisValueFormatter {
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    public var suffix = ["", "K", "M", "B", "T"]
    
    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?
    
    public init(appendix: String? = nil) {
        self.appendix = appendix
    }
    
    fileprivate func format(value: Double) -> String {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1
        
        while sig >= 1000.0 && length < maxLength {
            sig /= 1000.0
            length += 1
        }
        
        var r = String(format: "%0.f", sig) + suffix[length]
        
        if let appendix = appendix {
            r += appendix
        }
        
        return r
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //return value.kmFormatted
        return Utility.shared.formatPoints(num: value)
    }
    
    public func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String {
        
        return Utility.shared.formatPoints(num: value)
    }
}
extension DashboardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customerInvestment?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return customerInvestment?[row].portfolioID
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        portfolioLbl.text = customerInvestment?[row].portfolioID
        selectedPortfolioID = row
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
       
        let investmentArray1 =   Array(customerInvestment?[row].summary ?? [])
        let value =   investmentArray1.map({(Int($0.marketValue ) )}).reduce(0, +)
        let valueStr = String(describing: value).toCurrencyFormat(withFraction: false)
        let portfolio_id = customerInvestment?[row].portfolioID ?? ""
        let idAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeLblColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)]
        let valueAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14)]
        let partOne = NSMutableAttributedString(string: portfolio_id, attributes: idAttributes)
        let partTwo = NSMutableAttributedString(string: " PKR \(valueStr)", attributes: valueAttributes)
        let combination = NSMutableAttributedString()

        combination.append(partOne)
        combination.append(partTwo)
        title.attributedText =  combination //"\(customerInvestment?[row].portfolioID ?? "")(PKR \(attriString.toCurrencyFormat()))"
        title.textAlignment = .center
        return title
    }
     
}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count + extraCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isExpanded = customerInvestment?[selectedPortfolioID].isExpandable
        
        if isExpanded ==  true {
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvestmentFundHeaderCell.identifier) as! InvestmentFundHeaderCell
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvestmentFundCell.identifier) as! InvestmentFundCell
                cell.selectionStyle = .none
                cell.fundBtn.tag = indexPath.row - 1
                cell.fundBtn.addTarget(self, action: #selector(tapOnFund), for: .touchUpInside)
                cell.investmentFund = investmentArray[indexPath.row - 1]
                return cell
            }
        }
        else {
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvestmentFundHeaderCell.identifier) as! InvestmentFundHeaderCell
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row ==  totalRow - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvestmentFundBottomCell.identifier) as! InvestmentFundBottomCell
                print("total Gain = ", totalGain)
                cell.gainLbl.text = "\(String(describing:totalGain).toCurrencyFormat(withFraction: false))"
                cell.lossLbl.text = "\(String(describing: totalLoss).toCurrencyFormat(withFraction: false))"
                cell.valueLbl.text = "\(String(describing: marketValue ).toCurrencyFormat(withFraction: false))"
                
                if totalGain.isZero {
                    cell.gainLbl.text = "-"
                }
                if totalLoss.isZero {
                    cell.lossLbl.text = "-"
                }
                if marketValue.isZero {
                    cell.valueLbl.text = "-"
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvestmentFundCell.identifier) as! InvestmentFundCell
                cell.selectionStyle = .none
                cell.fundBtn.tag = indexPath.row - 1
                cell.fundBtn.addTarget(self, action: #selector(tapOnFund), for: .touchUpInside)
                cell.investmentFund = investmentArray[indexPath.row - 1]
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    @objc func tapOnFund(_ sender: UIButton) {
        let tag = sender.tag
        let vc = FundDetailsViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        vc.fund_id = investmentArray[tag].fundid ?? "800100-100"
        vc.portfolio_id     = investmentArray[tag].portfolioID
        vc.totalInvestment  = investmentArray[tag].purchases
        vc.totalRedemption  = investmentArray[tag].redemption
        vc.fund_shortname   =   investmentArray[tag].fundShortName ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
