//
//  main.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit


UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(TimerUIApplication.self),
    NSStringFromClass(AppDelegate.self)
)
