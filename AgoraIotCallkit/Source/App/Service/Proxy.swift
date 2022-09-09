//
//  Account.swift
//  demo
//
//  Created by ADMIN on 2022/2/7.
//

import Foundation

internal class Proxy{
    private var _al : AgoraLab!
    private var _rtc: RtcEngine!
    private var _ntf: PushNotifier!
    private var _mqtt:AWSMqtt!
    
    var al:AgoraLab{get{return _al}}
    var ntf:PushNotifier{get{return _ntf!}}
    var rtc:RtcEngine{get{return _rtc!}}
    var mqtt:AWSMqtt{get{return _mqtt}}
    
    init(event:StatusHandler, rule:RuleManager,cfg:Config,ctx:Context){
        self._rtc = RtcEngine(setting: ctx.call.setting.rtc)
        self._ntf = PushNotifier(cfg: cfg)
        self._mqtt = AWSMqtt(cfg: cfg)
        self._mqtt.onStatusChanged = event.onMqttStatusChanged
        self._al = AgoraLab(http: cfg.agoraLabUrl,awsurl: cfg.awsmqttUrl)
    }
}
 
