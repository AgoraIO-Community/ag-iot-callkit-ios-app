//
//  IotAppSdk.swift
//  demo
//
//  Created by ADMIN on 2022/2/10.
//

import Foundation

open class IotAppSdk : IAgoraIotAppSdk{
    private var _callbackFilter:(Int,String)->(Int,String) = {ec,msg in return (ec,msg)}
    private func onCallbackFilter(ec:Int,msg:String)->(Int,String){
        if(ec == ErrCode.XERR_TOKEN_EXPIRED){
            self.accountMgr.logout { ec, msg in
                log.i("sdk token expired,logout")
            }
        }
        else if(ec == ErrCode.XERR_UNKNOWN || ec == ErrCode.XERR_BAD_STATE){
            app!.rule.printState()
        }
        return _callbackFilter(ec,msg)
    }
    
    public func initialize(initParam: InitParam, sdkStatus:@escaping (SdkStatus, String)->Void,callBackFilter:@escaping(Int,String)->(Int,String)) -> Int {
        _callbackFilter = callBackFilter
        return app!.initialize(initParam: initParam,sdkStatus:sdkStatus,callBackFilter: onCallbackFilter)
    }
    
    private var app:Application?
    
    var application:Application{set{
        app = newValue
    }get{
        return app!
    }}
    
    public func release() {
        app!.release()
    }
    
    private var _accountManager : IAccountMgr? = nil
    private var _callkitManager: CallkitManager? = nil
    private var _notifyManager:INotificationMgr? = nil
    
    public var callkitMgr: ICallkitMgr{get{
        if(_callkitManager == nil){
            _callkitManager = CallkitManager(app: app!)
        }
        return _callkitManager!
        
    }}
    
    public var notificationMgr: INotificationMgr{get{
        if(_notifyManager == nil){
            _notifyManager = NotificationManager(app:app!)
        }
        return _notifyManager!
    }}
    
    
    public var accountMgr: IAccountMgr{get{
        if(_accountManager == nil){
            _accountManager = AccountManager(app: app!)
        }
        return _accountManager!
    }}
}
