//
//  FsmApp.swift
//  demo
//
//  Created by ADMIN on 2022/1/29.
//

import Foundation

class AppListener : FsmApp.IListener{
    
    func on_logout_watcher(_ srcEvent: FsmApp.Event) {
        log.i("listener app.on_logout_watcher \(srcEvent)")
        app.rule.trigger.logout_watcher()
    }
    
    func do_REMOTEJOINED(_ srcState:FsmApp.State){
        log.i("listener app.do_REMOTEJOINED:\(srcState)")
        let view = app.context.call.session.rtc.pairing.view
        if(view == nil){
            log.i("listener app.sessParing view not set yet")
        }
        else{
            app.callkitMgr.setPeerVideoView(peerView: view)
        }
    }
    
    func on_CfgRunning(_ srcEvent: FsmApp.Event) {
        log.i("listener app.on_CfgRunning:\(srcEvent)")
        app.rule.trans(FsmApp.Event.CFG_SUCC)
    }
    
    var app:Application
    init(app:Application){
        self.app = app
    }
}

