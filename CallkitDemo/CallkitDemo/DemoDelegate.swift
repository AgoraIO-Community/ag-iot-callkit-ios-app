//
//  demoApp.swift
//  demo
//
//  Created by ADMIN on 2022/1/27.
//

import SwiftUI

@main
struct Demo: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)var appDelegate
    /*
    When your app’s state changes, UIKit notifies you by calling methods of the appropriate delegate object:
    In iOS 13 and later, use UISceneDelegate objects to respond to life-cycle events in a scene-based app.
    In iOS 12 and earlier, use the UIApplicationDelegate object to respond to life-cycle events.

    Note
    If you enable scene support in your app, iOS always uses your scene delegates in iOS 13 and later. In iOS 12 and earlier, the system uses your app delegate.
     */
    @Environment(\.scenePhase) var scenePhase
    
    let content = ContentView()
    
    let status = DemoApp.shared.status
    var body: some Scene {
        WindowGroup {
            content.environmentObject(status)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("应用启动了")
            case .inactive:
                print("应用休眠了")
            case .background:
                print("应用在后台展示")
            @unknown default:
                print("default")
            }
        }
    }
}

