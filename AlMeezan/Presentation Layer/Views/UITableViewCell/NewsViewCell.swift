//
//  NewsViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 24/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SDWebImage


class NewsViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel! {
        didSet {
            newsTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var pubDate: UILabel!
    @IBOutlet weak var newsDescription: UILabel! {
        didSet {
            newsDescription.numberOfLines = 4
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: RSSItem! {
        didSet {
            newsTitle.text = item.title
            newsDescription.text = item.description.htmlDecoded
            let strDate =  item.pubDate.toDate(withFormat: "E, d MMM yyyy HH:mm:ss Z")
            let strValue = strDate?.toString(format: "MMM d, yyyy")
            pubDate.text = strValue
            imgView.sd_setImage(with: URL(string: item.img_link), placeholderImage: UIImage(named: "NewsViewCell"))
        }
    }
    
}
