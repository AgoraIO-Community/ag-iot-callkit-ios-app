//
//  FsmViewListener.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import Foundation

class FsmViewListener : FsmView.IListener{
    
    func do_BACKTOLOGIN(_ srcState: FsmView.State) {
        status.view = FsmView.State.LoginView.rawValue
    }
    
    func do_NEWUSER(_ srcState: FsmView.State) {
        status.view = FsmView.State.WelcomeView.rawValue
    }
    
    func do_OLDUSER(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func on_CheckStatus(_ srcEvent: FsmView.Event) {
        let account = status.account
        let event : FsmView.Event = account == "" || status.password == "" ? .NEWUSER : .OLDUSER;
        if(event == .OLDUSER){
            DemoApp.shared.login(status.account,status.password,{
                succ,msg in
                if(!succ){
                    log.w(msg)
                    self.status.trans(.NEWUSER)
                }
                else{
                    let ev : FsmView.Event = succ ? .OLDUSER : .NEWUSER
                    self.status.trans(ev)
                }
            })
        }
        else{
            status.trans(event)
        }
    }
    
    func do_EXIT(_ srcState: FsmView.State) {
        status.view = FsmView.State.LoginView.rawValue
        status.account = ""
        status.password = ""
    }
    
    func do_LOGINBACK(_ srcState: FsmView.State) {
        status.view = FsmView.State.WelcomeView.rawValue
    }
    
    
    
    func do_SD_RETURN(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_SD_CANCEL(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_BACK(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_MAIN(_ srcState: FsmView.State) {
        status.view = FsmView.State.DeviceMainView.rawValue
    }
    
    func do_LOGIN(_ srcState: FsmView.State) {
        status.view = FsmView.State.LoginView.rawValue
    }
    
    func do_INIT(_ srcState: FsmView.State) {
        status.view = FsmView.State.SplashView.rawValue
    }
    
    func do_LOGINED(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    var status:UserStatus
    init(_ status : UserStatus){
        self.status = status
    }
}
