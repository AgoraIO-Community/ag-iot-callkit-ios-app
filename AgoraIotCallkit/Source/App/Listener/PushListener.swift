//
//  NtfListener.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/2/16.
//

import Foundation
class PushListener : FsmPush.IListener{
    func on_destroy(_ srcEvent: FsmPush.Event) {
        log.i("listener push.on_destroy")
        app.proxy.ntf.logoutAndDestroy { succ in
            self.app.rule.trans(FsmPush.Event.DESTROYED)
        }
    }
    
    func do_LOGIN(_ srcState: FsmPush.State) {
        log.i("listener push.do_LOGIN")
        app.rule.trans(FsmPush.Event.LOGINSUCC)
    }
    
    func on_initialize(_ srcEvent: FsmPush.Event) {
        log.i("listener push.on_initialize")
        app.proxy.ntf.create(completion: {succ,eid in
            self.app.context.push.session.eid = succ ? eid : ""
            self.app.rule.trans(succ ? FsmPush.Event.INITSUCC : FsmPush.Event.INITFAIL)
        })
    }
    var app:Application
    init(app:Application){
        self.app = app
    }
}
