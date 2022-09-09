//
//  Cfg.swift
//  demo
//
//  Created by ADMIN on 2022/1/28.
//

import Foundation

class Config {
    private var _appId: String = ""
    var ntfAppKey: String = ""
    var ntfApnsCertName:String = ""
    var ntfEnableConsoleLog:Bool = true //推送日志打印到console
    /*
     0, Output all logs
     1, Output warnings and errors
     2  Output errors only
     */
    var ntfLogLevel:Int = 0 //
    var mqttLogLevel:Int = 1
    
    var logFilePath : String? = nil
    
    let calloutTimeOut:Double = 40
    var appId:String{get{return _appId}set{_appId = newValue}}
    
    var productKey:String = ""
    var projectId:String = ""
    var agoraLabUrl:String = ""
    var awsmqttUrl:String = ""
}
