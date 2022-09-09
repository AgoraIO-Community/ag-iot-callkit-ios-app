//
//  AccountManager.swift
//  demo
//
//  Created by ADMIN on 2022/1/29.
//

import Foundation

class AccountManager : IAccountMgr{
    
    private var app:Application
    private var rule:RuleManager
    
    init(app:Application){
        self.app = app
        self.rule = app.rule
    }
    
    private func asyncResult(_ ec:Int,_ msg:String,_ result:@escaping(Int,String)->Void) {
        DispatchQueue.main.async {
            let filter = self.app.context.callbackFilter
            let ret = filter(ec,msg)
            result(ret.0,ret.1)
        }
    }
    
    private func asyncResultData<T>(_ ec:Int,_ msg:String,_ data:T?,_ result:@escaping(Int,String,T?)->Void) {
        DispatchQueue.main.async {
            let filter = self.app.context.callbackFilter
            let ret = filter(ec,msg)
            result(ret.0,ret.1,data)
        }
    }
    
    func getUserId() -> String {
//        let n = app.context.gran.session.pool_identifier.findLast("_")
//        if(n == -1){
//            return ""
//        }
//        let next = n + 1;
//        let ret = app.context.gran.session.pool_identifier.substring(from: next)
//        return ret
        let thingName = app.context.gyiot.session.cert.thingName
        //log.i("granwin userid is \(thingName)")
        return thingName
    }
    
//    private func doLoginAL(_ account: String,_ result:@escaping (Int,String)->Void){
//        let alcb = {(ec:Int,msg:String,sess:GranWinSession?) in
//            log.i("granwin reqLogin: \(account) result:\(ec) \(msg)")
//            if(ec == ErrCode.XOK){
//                let gwsess = sess!
//                self.app.context.gran.session = gwsess
//                self.app.proxy.al.reqSessInventCert(grawinToken: gwsess.granwin_token, {ec,msg,cert in
//                    if(ec == ErrCode.XOK){
//                        let succ = ec == ErrCode.XOK
//                        self.app.context.account = account
//                        if let cert = cert {
//                            self.app.context.gran.session.cert = cert
//                            result(ErrCode.XOK,msg)
//                        }
//                        else{
//                            log.e("granwin reqSessCert cert is nil:\(msg)(\(ec))")
//                            self.rule.trans(.LOGIN_FAIL)
//                            self.app.context.gran.session.reset()
//                            result(ErrCode.XERR_INVALID_PARAM,msg)
//                        }
//
//                    }
//                    else{
//                        log.e("granwin reqSessCert result error:\(msg)(\(ec))")
//                        self.rule.trans(.LOGIN_FAIL)
//                        self.app.context.gran.session.reset()
//                        result(ErrCode.XERR_INVALID_PARAM,msg)
//                    }
//                })
//            }
//            else{
//                log.e("granwin reqLogin result error:\(msg)(\(ec))")
//                self.rule.trans(.LOGIN_FAIL)
//                self.app.context.gran.session.reset()
//                result(ec,msg)
//            }
//        }
//        let token = app.context.aglab.session.token.acessToken
//        self.app.proxy.al.reqLogin(token,account, alcb)
//    }
    
    private func doRegisterAl(_ account:String,_ result:@escaping(Int,String)->Void){
        self.app.proxy.al.reqRegister(account, result)
    }
//    private func doGetTokenAl(_ account: String,_ result:@escaping (Int,String)->Void){
//        doRegisterAl(account, {ec,msg in
//            if(ec != ErrCode.XOK){
//                result(ec,msg)
//                return
//            }
//            let cb = {(ec:Int,msg:String) in
//                result(ec,msg)
//            }
//            self.app.context.aglab.session.userName = account
//            let sess = self.app.context.aglab.session
//            self.app.proxy.al.reqGetToken(sess.userName, sess.password, sess.scope, sess.clientId, sess.secretKey,{ec,msg,token in
//                if(token != nil){
//                    self.app.context.aglab.session.token = token!
//                    self.app.context.aglab.session.token.acessToken = "Bearer " + token!.acessToken
//                }
//                cb(ec,msg)
//            })
//        })
//    }
    
    private func doLogin(_ param:LoginParam,_ result:@escaping (Int,String)->Void) {
        let data = param
        //self.app.context.aglab.session.userName = data.account
        self.app.context.aglab.session.token = AgoraLabToken(
            tokenType: data.tokenType,
            accessToken: "Bearer " + data.accessToken,
            refreshToken: data.refreshToken,
            expireIn: data.expireIn,
            scope: data.scope)
        
        self.app.context.gyiot.session = IotLinkSession(
            granwin_token: data.grawin_token,
            expiration: data.expiration,
            endPoint: data.endPoint,
            region: data.region,
            account: data.account,
            
            proof_sessionToken: data.proof_sessionToken,
            proof_secretKey: data.proof_secretKey,
            proof_accessKeyId: data.proof_accessKeyId,
            proof_sessionExpiration: data.proof_sessionExpiration,
            
            pool_token: data.pool_token,
            pool_identityId: data.pool_identityId,
            pool_identityPoolId: data.pool_identityId,
            pool_identifier: data.pool_identifier)
        
        let pool_identifier = data.pool_identifier
        let first = pool_identifier.findFirst("_")
        let last = pool_identifier.findLast("_")
        let certId = pool_identifier.substring(to: first)
        let rear = pool_identifier.substring(from: last + 1)
        let thingName = certId + "-" + rear
        
        //self.app.context.account = data.account
        self.app.context.virtualNumber = thingName
        self.app.context.gyiot.session.cert.thingName = thingName
        self.rule.trans(.LOGIN_SUCC,
                        {result(ErrCode.XOK,"登录成功")},
                        {result(ErrCode.XERR_BAD_STATE,"状态不正确")})
        
    }
    
    func login(param: LoginParam, result: @escaping (Int, String) -> Void) {
        app.rule.trans(FsmApp.Event.LOGIN,
                       {self.doLogin(param,{ec,msg in self.asyncResult(ec,msg,result)})},
                       {self.asyncResult(ErrCode.XERR_BAD_STATE,"状态错误",result)})
    }
    
    var onLogoutResult:()->Void = {}
    func doLogout(_ result:@escaping (Int,String)->Void){
        self.rule.trigger.logout_watcher = {result(ErrCode.XOK,"")}
        self.app.context.call.session.reset()
        app.rule.trans(FsmApp.Event.LOGOUT)
    }
    
//    func login(account: String, result:@escaping (Int,String)->Void){
//        let filter = self.app.context.callbackFilter
//        app.rule.trans(FsmApp.Event.LOGIN,
//                       {self.doLogin(account, {ec,msg in let ret = filter(ec,msg);result(ret.0,ret.1)})},
//                       {let ret = filter(ErrCode.XERR_BAD_STATE,"状态错误");result(ret.0,ret.1)})
//    }
    
    func logout(result:@escaping (Int,String)->Void){
        let filter = self.app.context.callbackFilter
        app.rule.trans(FsmApp.Event.LOGOUT,
                       {self.doLogout({ec,msg in let ret = filter(ec,msg);result(ret.0,ret.1)})},
                       {let ret = filter(ErrCode.XERR_BAD_STATE,"状态错误");result(ret.0,ret.1)})
    }
}


