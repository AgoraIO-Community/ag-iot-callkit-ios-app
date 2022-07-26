//
//  FsmViewListener.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import Foundation

class FsmViewListener : FsmView.IListener{
    func do_SYSWARNING(_ srcState: FsmView.State) {
        status.view = FsmView.State.SysWarningView.rawValue
    }
    
    func do_FORGETPWDBYPHONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetWithPhoneView.rawValue
    }
    
    func do_RESETBYSMS(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetBySmsView.rawValue
    }
    
    func do_RESETPWDBYCODE(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetPwdByCodeView.rawValue
    }
    
    func do_RESETPWDBYSMS(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetPwdBySmsView.rawValue
    }
    
    func do_BACKTORESETSMS(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetBySmsView.rawValue
    }
    
    func do_BACKTOVERIFYPHONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.VerifyPhoneView.rawValue
    }
    
    func do_BACKTOLOGIN(_ srcState: FsmView.State) {
        status.view = FsmView.State.LoginView.rawValue
    }
    
    func do_BACKTORESETCODE(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetByCodeView.rawValue
    }
    
    func do_RESETPWD(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetPwdByCodeView.rawValue
    }
    
    func do_RESETBYCODE(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetByCodeView.rawValue
    }
    
    func do_BACKTORESET(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetWithEmailView.rawValue
    }
    
    func do_FORGETPWD(_ srcState: FsmView.State) {
        status.view = FsmView.State.ResetWithEmailView.rawValue
    }
    
    func do_BACKTOVERIFYEMAIL(_ srcState: FsmView.State) {
        status.view = FsmView.State.VerifyEmailView.rawValue
    }
    
    func do_REBINDPHONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.BindPhoneView.rawValue
    }
    
    func do_REBINDEMAIL(_ srcState: FsmView.State) {
        status.view = FsmView.State.BindEmailView.rawValue
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
            demo.login(status.account,{
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
    
    func do_SETPWD(_ srcState: FsmView.State) {
        status.view = FsmView.State.SetPasswordView.rawValue
    }
    
    func do_SETPWDDONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.LoginView.rawValue
    }
    
    
    func do_VERIFYPHONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.VerifyPhoneView.rawValue
    }
    
    func do_VERIFYEMAIL(_ srcState: FsmView.State) {
        status.view = FsmView.State.VerifyEmailView.rawValue
    }
    
    func do_BINDPHONE(_ srcState: FsmView.State) {
        status.view = FsmView.State.BindPhoneView.rawValue
    }
    
    func do_BINDEMAIL(_ srcState: FsmView.State) {
        status.view = FsmView.State.BindEmailView.rawValue
    }
    
    func do_BINDBACK(_ srcState: FsmView.State) {
        status.view = FsmView.State.WelcomeView.rawValue
    }
    
    func do_SD_RETURN(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_SD_CANCEL(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_SD_CLOSE(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_SD_TIMEOUT(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDTimeoutView.rawValue
    }
    
    func do_SD_FAILED(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDFailureView.rawValue
    }
    
    func do_SD_SUCCED(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDSuccessView.rawValue
    }
    
    func do_STEP1(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDStep1View.rawValue
    }
    
    func do_RESETDEV(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDStep1View.rawValue
    }

    
    func do_STEP2(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDStep2View.rawValue
    }
    
    func do_STEP3(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDStep3View.rawValue
    }
    
    func do_STEP4(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDStep4View.rawValue
    }
    
    func do_TIMEOUT(_ srcState: FsmView.State) {
        status.view = FsmView.State.SDTimeoutView.rawValue
    }
    
    
    func do_CANCELRESET(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_BACK(_ srcState: FsmView.State) {
        status.view = FsmView.State.HomeView.rawValue
    }
    
    func do_MAIN(_ srcState: FsmView.State) {
        status.view = FsmView.State.DeviceMainView.rawValue
    }
    
    func do_WARNING(_ srcState: FsmView.State) {
        status.view = FsmView.State.WarningView.rawValue
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
