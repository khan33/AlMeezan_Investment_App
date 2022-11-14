//
//  NotifyViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 20/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class NotifyViewCell: UITableViewCell {

    @IBOutlet weak var notification_desc: UILabel!
    @IBOutlet weak var notification_date: UILabel!
    @IBOutlet weak var notification_title: UILabel!
    @IBOutlet weak var notification_img: UIImageView!
    @IBOutlet weak var imgBackgroundView: UIView!
    static var identifier: String{
       return String(describing: self)
    }
    static var nib: UINib{
       return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notification_date.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: NotificationList? {
        didSet {
            guard let data = data else { return }
            notification_title.text = data.title
            
            notification_desc.text = data.body
            if let date = data.timeStamp {
                notification_date.text = Utility.shared.dateTimeConverstion(date, "EEE HH:mm a, MMM d YYYY")
            }
            
            
            let notify_status = data.read
            if notify_status == 0 {
                // read
                notification_title.textColor = UIColor.themeColor
                imgBackgroundView.backgroundColor = UIColor.themeColor
            } else {
                notification_title.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
                imgBackgroundView.backgroundColor = UIColor.white
                
            }
            
            if let type = data.destination {
                print(type)
                if notify_status == 0 {
                    if type == Destination.nav.rawValue {
                        notification_img.image = UIImage(named: "nav_notification")
                    } else if type == Destination.blog.rawValue {
                        notification_img.image = UIImage(named: "Blog")
                    } else if type == Destination.fmr.rawValue {
                        notification_img.image = UIImage(named: "fmr_notification")
                    } else if type == Destination.mkt.rawValue {
                        notification_img.image = UIImage(named: "marketing")
                    } else if type == Destination.lead.rawValue {
                        notification_img.image = UIImage(named: "lead")
                    } else if type == Destination.investment.rawValue {
                        notification_img.image = UIImage(named: "invest_notification")
                    } else if type == Destination.conversion.rawValue {
                        notification_img.image = UIImage(named: "invest_notification")
                    } else if type == Destination.redemption.rawValue {
                        notification_img.image = UIImage(named: "invest_notification")
                    } else if type == Destination.news.rawValue {
                        notification_img.image = UIImage(named: "news_notification")
                    } else if type == Destination.youtube.rawValue {
                       notification_img.image = UIImage(named: "youtube")
                    } else if type == Destination.reg.rawValue {
                        notification_img.image = UIImage(named: "reg")
                    } else {
                        notification_img.image = UIImage(named: "Blog")
                    }
                } else {
                    if type == Destination.nav.rawValue {
                        notification_img.image = UIImage(named: "nav_notify")
                    } else if type == Destination.blog.rawValue {
                        notification_img.image = UIImage(named: "blog_notify")
                    } else if type == Destination.fmr.rawValue {
                        notification_img.image = UIImage(named: "fmr_notify")
                    } else if type == Destination.mkt.rawValue {
                        notification_img.image = UIImage(named: "blog_notify")
                    } else if type == Destination.lead.rawValue {
                        notification_img.image = UIImage(named: "lead_notify")
                    } else if type == Destination.investment.rawValue {
                        notification_img.image = UIImage(named: "invest_notify")
                    } else if type == Destination.conversion.rawValue {
                        notification_img.image = UIImage(named: "invest_notify")
                    } else if type == Destination.redemption.rawValue {
                        notification_img.image = UIImage(named: "invest_notify")
                    } else if type == Destination.news.rawValue {
                        notification_img.image = UIImage(named: "news_notify")
                    } else if type == Destination.youtube.rawValue {
                       notification_img.image = UIImage(named: "youtube_notify")
                    } else if type == Destination.reg.rawValue {
                        notification_img.image = UIImage(named: "reg_notify")
                    } else {
                        notification_img.image = UIImage(named: "blog_notify")
                    }
                }
            }
            
            
        }
    }
    
}
