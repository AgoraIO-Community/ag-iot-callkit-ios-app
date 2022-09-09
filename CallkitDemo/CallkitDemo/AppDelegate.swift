//
//  AppDelegate.swift
//  BehindTheScenes
//
//  Created by Simeon Saint-Saens on 4/6/19.
//  Copyright © 2019 Two Lives Left. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let queue = DispatchQueue(label: "myQueue",qos: DispatchQoS.default,attributes: DispatchQueue.Attributes.concurrent,autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,target: nil)
        DemoApp.shared.initialize({act in
            queue.sync{
                act()
            }
        })
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        log.d("didRegisterForRemoteNotificationsWithDeviceToken()")
        DemoApp.shared.updateToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.e("didFailToRegisterForRemoteNotificationsWithError(\(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.i("didReceiveRemoteNotification")
        //EMClient.shared().application(application, didReceiveRemoteNotification: userInfo)
        MyAlertView.shared.show("ddd")
    }
}

