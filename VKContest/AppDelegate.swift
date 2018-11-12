//
//  AppDelegate.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let assembly = ControllersAssembly.shared
        guard let window = application.windows.first else { return true }
        
        window.rootViewController = assembly.configuredNewsFeedViewController()
        assembly.rootViewController = window.rootViewController
        window.makeKeyAndVisible()
        
        ServiceLocator.shared.vkUIDelegate = assembly
        ServiceLocator.shared.configure()        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String else { return true }
        VKSdk.processOpen(url, fromApplication: sourceApplication)        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

