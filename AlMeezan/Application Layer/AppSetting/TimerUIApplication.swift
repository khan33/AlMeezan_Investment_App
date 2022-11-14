//
//  TimerUIApplication.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class TimerUIApplication: UIApplication {

    

    // The timeout in seconds for when to fire the idle timer.

    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
        return 2 * 60
    }
    
    
    var idleTimer: Timer?
    
    
    // resent the timer because there was user interaction
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }

        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerUIApplication.timeHasExceeded),
                                         userInfo: nil,
                                         repeats: false
        )
    }

    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        let userAuth = KeychainWrapper.standard.string(forKey: "UserType")
        
        if userAuth == "loggedInUser" {
            NotificationCenter.default.post(name: .appTimeout,
                                            object: nil
            )
        }
    }
    
    
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if idleTimer != nil {
            self.resetIdleTimer()
        }

        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}
