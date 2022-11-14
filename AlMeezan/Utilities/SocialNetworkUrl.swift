//
//  SocialNetworkUrl.swift
//  AlMeezan
//
//  Created by Atta Khan on 24/03/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
struct SocialNetworkUrl {
    let scheme: String
    let page: String

    func openPage() {
        let schemeUrl = NSURL(string: scheme)!
        if UIApplication.shared.canOpenURL(schemeUrl as URL) {
            UIApplication.shared.openURL(schemeUrl as URL)
        } else {
            UIApplication.shared.openURL(NSURL(string: page)! as URL)
        }
    }
}

enum SocialNetwork {
    case Facebook, Youtube, Twitter, Instagram, Linkedin
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook: return SocialNetworkUrl(scheme: "fb://profile?id=almeezangroup", page: "https://www.facebook.com/almeezangroup")
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=almeezangroup", page: "https://twitter.com/almeezangroup")
        case .Youtube: return SocialNetworkUrl(scheme: "youtube://www.youtube.com/channel/UCvZc_VKkWlJmNArnoMU3lgQ", page: "https://www.youtube.com/channel/UCvZc_VKkWlJmNArnoMU3lgQ")
        case .Instagram: return SocialNetworkUrl(scheme: "instagram://user?username=almeezangroup", page:"https://www.instagram.com/almeezangroup")
        case .Linkedin: return SocialNetworkUrl(scheme: "linkedin://company/al-meezan-investment-management-limited/", page:"https://www.linkedin.com/company/al-meezan-investment-management-limited")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}
