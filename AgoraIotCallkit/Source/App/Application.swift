//
//  AppSdk.swift
//  demo
//
//  Created by ADMIN on 2022/1/29.
//

import Foundation
//import UIKit

open class Application{
    func initialize(initParam: InitParam, sdkStatus: @escaping(SdkStatus, String)->Void,callBackFilter:@escaping(Int,String)->(Int,String)) -> Int {
        if(initParam.logFilePath != ""){
            log.ouput = .debugerConsoleAndFile
        }
        
        Logger.shared.removeAllAsync()
        let tempAppId = initParam.rtcAppId.substring(to: 1) + "*********************" + initParam.rtcAppId.substring(from: initParam.rtcAppId.count - 1)
        let tempAppKey = initParam.ntfAppKey.substring(to: 1) + "********" + initParam.ntfAppKey.substring(from: initParam.ntfAppKey.count - 1)
        let tempApnCer = initParam.ntfApnsCertName.substring(to: 1) + "*******" + initParam.ntfApnsCertName.substring(from: initParam.ntfApnsCertName.count - 1)
        let tempMaster = initParam.slaveServerUrl.substring(to: 10) + "*******" + initParam.slaveServerUrl.substring(from: initParam.slaveServerUrl.count - 4)
        let tempSlave = initParam.masterServerUrl.substring(to: 10) + "*******" + initParam.masterServerUrl.substring(from: initParam.masterServerUrl.count - 4)
        let tempProjectId = initParam.projectId.substring(to: 1) + "*******" + initParam.projectId.substring(from: initParam.projectId.count - 1)
        let tempProductKey = initParam.productKey.substring(to: 1) + "*******" + initParam.productKey.substring(from: initParam.productKey.count - 1)
        log.i("=================  AgoraIotSdk  ======================")
        //log.i("     version:   \(IAgoraIotSdkVersion)")
        log.i("       built:   \(Utils.dateTime())")
        log.i("       appId:   \(tempAppId)")
        log.i("      appKey:   \(tempAppKey)")
        log.i("      ApnCer:   \(tempApnCer)")
        log.i("   MasterUrl:   \(tempMaster)")
        log.i("    SlaveUrl:   \(tempSlave)")
        log.i("   ProjectId:   \(tempProjectId)")
        log.i("  productKey:   \(tempProductKey)")
        log.i("     logFile:   \(initParam.logFilePath)")
        log.i("======================================================")
        
        _config.appId = initParam.rtcAppId
        _config.logFilePath = initParam.logFilePath
        _config.ntfAppKey = initParam.ntfAppKey
        _config.ntfApnsCertName = initParam.ntfApnsCertName
        _config.agoraLabUrl = initParam.slaveServerUrl
        _config.awsmqttUrl = initParam.masterServerUrl
        _config.productKey = initParam.productKey
        _config.projectId = initParam.projectId
        
        _status?.setStatusHandler(handler: sdkStatus)
        _context.callbackFilter = callBackFilter
        
        _context.call.setting.rtc.logFilePath = initParam.logFilePath
        _context.call.setting.rtc.publishAudio = initParam.publishAudio
        _context.call.setting.rtc.publishVideo = initParam.publishVideo
        _context.call.setting.rtc.subscribeAudio = initParam.subscribeAudio
        _context.call.setting.rtc.subscribeVideo = initParam.subscribeVideo
        
        self._proxy = Proxy(event:self.status, rule:self.rule, cfg: self.config, ctx: self.context)
        
        if(initParam.rtcAppId == ""){
            log.e("sdk initParam.rtcAppId is empty");
            return ErrCode.XERR_INVALID_PARAM
        }
        if(initParam.slaveServerUrl == ""){
            log.e("sdk initParam.agoraLabUrl is empty");
            return ErrCode.XERR_INVALID_PARAM
        }
        if(initParam.masterServerUrl == ""){
            log.e("sdk initParam.granwinUrl is empty");
            return ErrCode.XERR_INVALID_PARAM
        }
        if(initParam.ntfAppKey == ""){
            log.e("sdk initParam.ntfAppKey is empty");
            return ErrCode.XERR_INVALID_PARAM
        }
        if(initParam.ntfApnsCertName == ""){
            log.e("sdk initParam.ntfApnsCertName is empty");
            return ErrCode.XERR_INVALID_PARAM
        }
        
        _rule!.start(queue:DispatchQueue.main)

        return ErrCode.XOK
    }
    
    func release() {
        
    }
    
    public static let shared = Application()
    
    var sdk:IotAppSdk{get{return _sdk}}
    var rule:RuleManager{get{return _rule!}}
    var config:Config{get{return _config}}
    var status:StatusHandler{get{return _status!}}
    var proxy:Proxy{get{return _proxy!}}
    var context:Context{get{return _context}}
    
    var callkitMgr:CallkitManager{get{return _sdk.callkitMgr as! CallkitManager}}
    
    private var _config = Config()
    private var _context = Context()
    private var _rule:RuleManager?
    private var _status:StatusHandler?
    private var _sdk:IotAppSdk = IotAppSdk()
    
    private var _proxy:Proxy?
    
    init(){
        log.level = .info
        self._sdk.application = self
        self._status = StatusHandler(self)
        self._rule = RuleManager(self,invoke)
        //self._proxy = Proxy(event:self.status, rule:self.rule, cfg: self.config, ctx: self.context)
    }
    
    let queue = DispatchQueue(label: "myQueue",qos: DispatchQoS.default,attributes: DispatchQueue.Attributes.concurrent,autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,target: nil)
    //let queue = DispatchQueue.main
    func invoke(act: @escaping ()->Void){
        queue.sync{
            act()
        }
    }
    
    static func Instance()->Application{
        return Application.shared;
    }
}


