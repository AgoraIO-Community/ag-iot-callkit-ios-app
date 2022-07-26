//
//  Object.swift
//  demo
//
//  Created by ADMIN on 2022/2/11.
//

import Foundation

class UserStatus: ObservableObject {
    static let MOCK : Bool = true
    static let TRACE : Bool = true
    @Published var view : Int = 0
    var account:String {
        get {return UserDefaults.standard.string(forKey: UserStatus.UDAccount) ?? ""}
        set {let acc:String = newValue;UserDefaults.standard.set(acc,forKey: UserStatus.UDAccount);UserDefaults.standard.synchronize()}
    }
    var password:String {
        get {return UserDefaults.standard.string(forKey: UserStatus.UDPassword) ?? ""}
        set {let pwd:String = newValue;UserDefaults.standard.set(pwd,forKey: UserStatus.UDPassword);UserDefaults.standard.synchronize()}
    }
    var fsm:FsmView?
    func setFsm(fsm:FsmView){
        self.fsm = fsm
    }
    func trans(_ event:FsmView.Event,act: @escaping ()->Void = {}){
        fsm?.trans(event.rawValue,act)
    }
    
    static let UDAccount = "account"
    static let UDPassword = "password"
    var env:Dictionary<String,Any> = [:]
}

class UserOnboard: ObservableObject {
    @Published var onboardComplete : Bool = false
}
