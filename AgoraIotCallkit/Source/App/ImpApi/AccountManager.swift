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
    
    func getUserId() -> String {
//        let n = app.context.gran.session.pool_identifier.findLast("_")
//        if(n == -1){
//            return ""
//        }
//        let next = n + 1;
//        let ret = app.context.gran.session.pool_identifier.substring(from: next)
//        return ret
        let thingName = app.context.gran.session.cert.thingName
        //log.i("granwin userid is \(thingName)")
        return thingName
    }
    
    func unregister(account: String,result:@escaping(Int,String)->Void){
    }
    
        private func doLoginAL(_ account: String,_ result:@escaping (Int,String)->Void){
            let alcb = {(ec:Int,msg:String,sess:GranWinSession?) in
                log.i("granwin reqLogin: \(account) result:\(ec) \(msg)")
                if(ec == ErrCode.XOK){
                    let gwsess = sess!
                    self.app.context.gran.session = gwsess
                    self.app.proxy.al.reqSessInventCert(grawinToken: gwsess.granwin_token, {ec,msg,cert in
                        if(ec == ErrCode.XOK){
                            let succ = ec == ErrCode.XOK
                            self.app.context.account = account
                            if let cert = cert {
                                self.app.context.gran.session.cert = cert
                                result(ErrCode.XOK,msg)
                            }
                            else{
                                log.e("granwin reqSessCert cert is nil:\(msg)(\(ec))")
                                self.rule.trans(.LOGIN_FAIL)
                                self.app.context.gran.session.reset()
                                result(ErrCode.XERR_INVALID_PARAM,msg)
                            }
    
                        }
                        else{
                            log.e("granwin reqSessCert result error:\(msg)(\(ec))")
                            self.rule.trans(.LOGIN_FAIL)
                            self.app.context.gran.session.reset()
                            result(ErrCode.XERR_INVALID_PARAM,msg)
                        }
                    })
                }
                else{
                    log.e("granwin reqLogin result error:\(msg)(\(ec))")
                    self.rule.trans(.LOGIN_FAIL)
                    self.app.context.gran.session.reset()
                    result(ec,msg)
                }
            }
            let token = app.context.aglab.session.token.acessToken
            self.app.proxy.al.reqLogin(token,account, alcb)
    }
    
    private func doRegisterAl(_ account:String,_ result:@escaping(Int,String)->Void){
        self.app.proxy.al.reqRegister(account, result)
    }
    private func doGetTokenAl(_ account: String,_ result:@escaping (Int,String)->Void){
        doRegisterAl(account, {ec,msg in
            if(ec != ErrCode.XOK){
                result(ec,msg)
                return
            }
            let cb = {(ec:Int,msg:String) in
                result(ec,msg)
            }
            self.app.context.aglab.session.userName = account
            let sess = self.app.context.aglab.session
            self.app.proxy.al.reqGetToken(sess.userName, sess.password, sess.scope, sess.clientId, sess.secretKey,{ec,msg,token in
                if(token != nil){
                    self.app.context.aglab.session.token = token!
                    self.app.context.aglab.session.token.acessToken = "Bearer " + token!.acessToken
                }
                cb(ec,msg)
            })
        })
    }
    
    func doLogin(_ account: String, _ result:@escaping (Int,String)->Void) {
        let accountId = app.config.projectId + "-" + account
        self.doLoginAL(accountId, {ec,msg in
            if(ec != ErrCode.XOK){
                self.rule.trans(.LOGIN_FAIL)
                result(ec,msg)
                return
            }
            self.doGetTokenAl(accountId, {ec,msg in
                if(ec != ErrCode.XOK){
                    self.rule.trans(.LOGIN_FAIL)
                    result(ec,msg)
                    return
                }
                else{
                    self.rule.trans(.LOGIN_SUCC,
                                    {result(ec,msg)},
                                    {result(ErrCode.XERR_BAD_STATE,"当前状态错误")})
                }
            })
        })
    }
    
    var onLogoutResult:()->Void = {}
    func doLogout(_ result:@escaping (Int,String)->Void){
        self.rule.trigger.logout_watcher = {result(ErrCode.XOK,"")}
        app.rule.trans(FsmApp.Event.LOGOUT)
    }
    
    func login(account: String, result:@escaping (Int,String)->Void){
        let filter = self.app.context.callBackFilter
        app.rule.trans(FsmApp.Event.LOGIN,
                       {self.doLogin(account, {ec,msg in let ret = filter(ec,msg);result(ret.0,ret.1)})},
                       {let ret = filter(ErrCode.XERR_BAD_STATE,"状态错误");result(ret.0,ret.1)})
    }
    
    func logout(result:@escaping (Int,String)->Void){
        let filter = self.app.context.callBackFilter
        app.rule.trans(FsmApp.Event.LOGOUT,
                       {self.doLogout({ec,msg in let ret = filter(ec,msg);result(ret.0,ret.1)})},
                       {let ret = filter(ErrCode.XERR_BAD_STATE,"状态错误");result(ret.0,ret.1)})
    }
}


