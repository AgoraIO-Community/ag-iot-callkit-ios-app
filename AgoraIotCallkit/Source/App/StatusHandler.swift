//
//  EventManager.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/3/26.
//

import Foundation

class StatusHandler{
    let app:Application
    var _statusHandler:(SdkStatus,String)->Void = {n,s in}
    func setStatusHandler(handler:@escaping(SdkStatus,String)->Void){
        _statusHandler = handler
    }
    func onMqttStatusChanged(status:IotMqttSession.Status){
        if(status == .Connecting){
            _statusHandler(.Disconnected,"Mqtt 正在连接")
        }
        else if(status == .ConnectionError){
            _statusHandler(.Disconnected,"Mqtt 连接错误")
        }
        else if(status == .Disconnected){
            _statusHandler(.Disconnected,"Mqtt 连接断开")
        }
        else if(status == .Connected){
            _statusHandler(.Reconnected, "Mqtt 自动连接成功")
        }
    }
    init(_ app:Application){
        self.app = app;
    }
}
