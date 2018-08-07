//
//  AppDelegate.swift
//  malibu-etag
//
//  Created by Guilherme on 07/08/18.
//  Copyright © 2018 Guilherme. All rights reserved.
//

import UIKit
import Malibu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Malibu.clearStorages()
    return true
  }
}
