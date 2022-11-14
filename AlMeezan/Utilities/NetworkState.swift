//
//  NetworkState.swift
//  AlMeezan
//
//  Created by Atta khan on 02/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}
