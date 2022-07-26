//
//  NotificationManager.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/5/7.
//

import Foundation

class NotificationManager : INotificationMgr{
//    func updateToken(_ deviceToken:Data){
//        app.proxy.ntf.updateToken(deviceToken)
//    }
    
    func updateToken(_ deviceToken:Data){
        app.proxy.ntf.updateToken(deviceToken)
    }

//    func queryAll(){
//        
//    }
//
//    func queryByDevice(productKey: String, deviceId: String){
//        
//    }
//
//    func delete(notificationIdList: [String]){
//        
//    }
//
//    func mark(markFlag: Int, notificationIdList: [String]){
//        
//    }

    private var app:Application
    private var rule:RuleManager
    
    init(app:Application){
        self.app = app
        self.rule = app.rule
    }
}
