//
//  IndicesViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class IndicesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updatedTimeLbl: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var indicesIndex: [PSXIndixesModel]?
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
        bottomConstraint.constant = 10
        statusLbl.isHidden = true
        statusBtn.isHidden = true
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       getData(false)
    }
    override func viewWillAppear(_ animated: Bool) {
        getData(true)
        self.setUpTableView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    private func setUpTableView() {
        tableView.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(IndicesHeaderCell.nib, forCellReuseIdentifier: IndicesHeaderCell.identifier)
        tableView.register(IndicesExpandCell.nib, forCellReuseIdentifier: IndicesExpandCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData() 
    }
    
    private func getData(_ show: Bool) {
        let date = Date().toString(format: "yyyyMMdd") //20191125
        let bodyParam = RequestBody(Date: date)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PSX_INDIXES)!
        if show {
            SVProgressHUD.show()
        }
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "PSX SECTOR TOP", modelType: PSXIndixesModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.indicesIndex = response
            
            guard let data = self.indicesIndex else {
                return
            }
            if self.indicesIndex?.count ?? 0 > 0 {
                self.indicesIndex = self.indicesIndex?.reversed()
                if data[0].trend?.count ?? 0 > 0 {
                    let count = (data[0].trend?.count ?? 0) - 1
                    if let date = data[0].trend?[count].entrydatetime {
                        let time = Utility.shared.converTimeString(date)
                        self.updatedTimeLbl.text = "Last updated on \(time)"
                    }
                }
                self.marketStatus(self.indicesIndex?[0])
            }
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: show)
    }
    
    private func marketStatus(_ indices: PSXIndixesModel?) {
        statusLbl.text = String(describing: "\u{2022} \(indices?.status?.rawValue ?? "")")
        switch indices?.status {
        
        case .open:
            statusLbl.isHidden = false
            statusBtn.isHidden = false
            statusLbl.textColor = UIColor(red: 71, green: 174, blue: 10)
            statusBtn.backgroundColor = UIColor(red: 71, green: 174, blue: 10)
            statusBtn.alpha = 0.2
            
        case .close:
            statusLbl.isHidden = false
            statusBtn.isHidden = false
            statusLbl.textColor = UIColor(red: 245, green: 79, blue: 79)
            statusBtn.backgroundColor = UIColor(red: 245, green: 79, blue: 79)
            statusBtn.alpha = 0.2
        case .suspended:
            statusLbl.isHidden = false
            statusBtn.isHidden = false
            statusLbl.textColor = UIColor(red: 91, green: 95, blue: 120)
            statusBtn.backgroundColor = UIColor(red: 91, green: 95, blue: 120)
            statusBtn.alpha = 0.2
        case .empty:
            statusLbl.isHidden = true
            statusBtn.isHidden = true
            break
        case .none:
            break
        }
    }
    
}

extension IndicesViewController: UITableViewDelegate {
    
}
extension IndicesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (NetworkState().isInternetAvailable) {
            tableView.backgroundView = nil
            numOfSections = indicesIndex?.count ?? 0
        } else {
            Utility.shared.emptyTableView(tableView)
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isExpanded = (indicesIndex?[indexPath.section].isExpandable)!
        if isExpanded {
            let cell = tableView.dequeueReusableCell(withIdentifier: IndicesExpandCell.identifier, for: indexPath) as! IndicesExpandCell
            cell.selectionStyle = .none
            cell.data = indicesIndex?[indexPath.section]
            clearAllBtnStatus(cell)
            
            cell.tenHourBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
            cell.tenHourBtn.setTitleColor(UIColor.themeColor, for: .normal)
            cell.tenHourBtn.layer.borderColor = UIColor.themeColor.cgColor
            cell.expandBtn.tag = indexPath.section
            cell.expandBtn.addTarget(self, action: #selector(expandViewCell), for: .touchUpInside)
            cell.tenHourBtn.tag = indexPath.section
            cell.tenHourBtn.addTarget(self, action: #selector(tapOnTenHBtn), for: .touchUpInside)
            cell.oneDayBtn.tag = indexPath.section
            cell.oneDayBtn.addTarget(self, action: #selector(tapOneDayHBtn), for: .touchUpInside)
            cell.weeklyBtn.tag = indexPath.section
            cell.weeklyBtn.addTarget(self, action: #selector(tapOnweeklyBtn), for: .touchUpInside)
            cell.oneMonthBtn.tag = indexPath.section
            cell.oneMonthBtn.addTarget(self, action: #selector(tapOneMonthHBtn), for: .touchUpInside)
            cell.threeMonthBtn.tag = indexPath.section
            cell.threeMonthBtn.addTarget(self, action: #selector(tapThreeMonthHBtn), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: IndicesHeaderCell.identifier, for: indexPath) as! IndicesHeaderCell
            cell.selectionStyle = .none
            cell.data = indicesIndex?[indexPath.section]
            cell.expandBtn.tag = indexPath.section
            cell.expandBtn.addTarget(self, action: #selector(expandViewCell), for: .touchUpInside)
            return cell
        }
    }
    
    
    func clearAllBtnStatus(_ cell: IndicesExpandCell?) {
        
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.oneDayBtn.backgroundColor = UIColor.white
        cell?.oneDayBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.tenHourBtn.backgroundColor = UIColor.white
        cell?.tenHourBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
    }
    
    @objc func tapOnweeklyBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? IndicesExpandCell
        cell?.weeklyBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.weeklyBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.oneDayBtn.backgroundColor = UIColor.white
        cell?.oneDayBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.tenHourBtn.backgroundColor = UIColor.white
        cell?.tenHourBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        indicesIndex?[indexPath.section].trendWeekly?[indexPath.row].isDayTrend = true
        cell?.chartData = indicesIndex?[indexPath.section].trendWeekly
    }
    @objc func tapOnTenHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? IndicesExpandCell
        cell?.tenHourBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.tenHourBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.oneDayBtn.backgroundColor = UIColor.white
        cell?.oneDayBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        indicesIndex?[indexPath.section].trend?[indexPath.row].isDayTrend = false
        cell?.chartData = indicesIndex?[indexPath.section].trend
    }
    
    
    @objc func tapOneDayHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? IndicesExpandCell
        cell?.oneDayBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.oneDayBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.tenHourBtn.backgroundColor = UIColor.white
        cell?.tenHourBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        indicesIndex?[indexPath.section].trendDaily?[indexPath.row].isDayTrend = true
        cell?.chartData = indicesIndex?[indexPath.section].trendDaily
    }
    
    @objc func tapOneMonthHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? IndicesExpandCell
        cell?.oneMonthBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.oneMonthBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.tenHourBtn.backgroundColor = UIColor.white
        cell?.tenHourBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneDayBtn.backgroundColor = UIColor.white
        cell?.oneDayBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        indicesIndex?[indexPath.section].trendMonthly?[indexPath.row].isDayTrend = true
        cell?.chartData = indicesIndex?[indexPath.section].trendMonthly
    }
    @objc func tapThreeMonthHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? IndicesExpandCell
        cell?.threeMonthBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.threeMonthBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.tenHourBtn.backgroundColor = UIColor.white
        cell?.tenHourBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.tenHourBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneDayBtn.backgroundColor = UIColor.white
        cell?.oneDayBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneDayBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        indicesIndex?[indexPath.section].trendQuarterly?[indexPath.row].isDayTrend = true
        cell?.chartData = indicesIndex?[indexPath.section].trendQuarterly
    }
    @objc func expandViewCell(_ sender: UIButton) {
        let section = sender.tag
        let isExpanded =  (indicesIndex?[section].isExpandable)!
        indicesIndex?[section].isExpandable = !isExpanded
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isExpanded = (indicesIndex?[indexPath.section].isExpandable)!
        return UITableView.automaticDimension
    }
}
extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
enum IndicesStatus: String, Codable {
    case open = "Open"
    case close = "Closed"
    case suspended = "Suspended"
    case empty  =   ""
}
