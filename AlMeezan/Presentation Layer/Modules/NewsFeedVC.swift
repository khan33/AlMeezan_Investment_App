//
//  NewsFeedVC.swift
//  AlMeezan
//
//  Created by Atta khan on 24/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

struct RSSItem {
    var title: String
    var description: String
    var pubDate: String
    var post_link: String
    var img_link: String
}
//stringByDecodingHTMLEntities

class FeedParser: NSObject, XMLParserDelegate {
    private var rssItems: [RSSItem] = []
    
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPostLink: String = "" {
        didSet {
            currentPostLink = currentPostLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImg: String = "" {
        didSet {
            currentImg = currentImg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) ->  Void)?
    
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) ->  Void)? ) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            // parse our xml data
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    
    
    // xml parse delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentPostLink = ""
            currentImg    =   ""
        }
        
        if currentElement == "media:content" {
            currentImg    =   attributeDict["url"]!
        }
        
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        case "link":
            currentPostLink += string
        default:
            break
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let resItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate, post_link: currentPostLink, img_link: currentImg )
            self.rssItems.append(resItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}


class NewsFeedVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countNotificationLbl: UIButton!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    private var rssItems: [RSSItem]?
    private var cellStates: [CellState]?
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    
    private let refreshControl = UIRefreshControl()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        
         countNotificationLbl.isHidden = true
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    @objc private func refreshTableViewData(_ sender: Any) {
        // Fetch Weather Data
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                logoBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
                menuBtn.setImage(UIImage(named: "menu_icon"), for: .normal)
            } else {
                logoBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
                menuBtn.setImage(UIImage(named: "BackArrow"), for: .normal)
            }
        }
        
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    private func fetchData() {
        let feedParser = FeedParser()
        SVProgressHUD.show()
        feedParser.parseFeed(url: RSS_FEED_NEWS) { (rssItems) in
            self.rssItems = rssItems
            //self.cellStates = Array(repeating: .Collapsed, count: rssItems.count)
            SVProgressHUD.dismiss()
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    @IBAction func tapOnLogoutBtn(_ sender: Any) {
        loginOption()
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnMenuBtn(_ sender: Any) {
        print("here is.....")
        self.revealController.show(self.revealController.leftViewController)
    }
    
    func configTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180.0
        tableView.register(NewsViewCell.nib, forCellReuseIdentifier: NewsViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}
extension NewsFeedVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
                return 0
        }
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NewsViewCell.self, for: indexPath) as! NewsViewCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
            cell.selectionStyle = .none
//            if let cellStates = cellStates {
//                cell.newsDescription.numberOfLines = (cellStates[indexPath.row] == .Expanded) ? 0 : 4
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = rssItems?[indexPath.item] {
            let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            let link = String(item.post_link.filter { !" \n\t\r".contains($0) })

            vc.urlStr = link
            vc.titleStr = "News Feed"
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as! NewsViewCell
//
//        tableView.beginUpdates()
//        cell.newsDescription.numberOfLines = (cell.newsDescription.numberOfLines == 0) ? 4 : 0
//        cellStates?[indexPath.row] = (cell.newsDescription.numberOfLines == 0) ? .Expanded : .Collapsed
//        tableView.endUpdates()
        
        
    }
    
}
