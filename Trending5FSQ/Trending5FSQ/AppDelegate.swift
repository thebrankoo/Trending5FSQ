//
//  AppDelegate.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/19/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let vm = VenuesViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        vm.run()
        return true
    }
    
}

