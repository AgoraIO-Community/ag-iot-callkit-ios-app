//
//  StateManager.swift
//  demo
//
//  Created by ADMIN on 2022/2/9.
//

import Foundation

class RuleManager{
    
    private var app:Application
    private var ctx:Context
    private var _fsmApp:FsmApp
    private var _trigger:TriggerListener
    
    init(_ app:Application,_ onPost: @escaping Fsm.PostFun){
        self.app = app
        self.ctx = app.context
        _fsmApp = FsmApp(onPost)
        _trigger = TriggerListener()
        _fsmApp.listener = AppListener(app: app)
        _fsmApp.getFsmCall().listener = CallListener(app:app)
        _fsmApp.getFsmPush().listener = PushListener(app:app)
        _fsmApp.getFsmMqtt().listener = MqttListener(app:app)
        _fsmApp.getFsmCall().getFsmRtc().listener = RtcListener(app:app)
    }
    
    var trigger:TriggerListener{get{return _trigger}}
    
    func start(queue:DispatchQueue){
        if(!Thread.current.isMainThread){
            DispatchQueue.main.async {
                self._fsmApp.start(queue: queue)
            }
        }
        else{
            _fsmApp.start(queue:queue)
            _fsmApp.getFsmPush().start(queue: queue)
            _fsmApp.getFsmCall().start(queue: queue)
            _fsmApp.getFsmCall().getFsmRtc().start(queue: queue)
            _fsmApp.getFsmMqtt().start(queue: queue)
        }
    }
    
    private func transByMain(_ fsm:Fsm, _ evt:Int,_ act:@escaping ()->Void={},_ fail:@escaping ()->Void = {}){
        if(!Thread.current.isMainThread){
        //if(false){
            DispatchQueue.main.async {
                if(!fsm.trans(evt,act)){
                    fail()
                }
            }
        }
        else{
            if(!fsm.trans(evt,act)){
                fail()
            }
        }
    }

    func trans(_ evt:FsmApp.Event,_ act:@escaping ()->Void={},_ fail:@escaping ()->Void = {}){
        transByMain(self._fsmApp,evt.rawValue,act,fail)
    }

    func trans(_ evt:FsmCall.Event,_ act:@escaping ()->Void={},_ fail:@escaping ()->Void = {}){
        transByMain(self._fsmApp.getFsmCall(),evt.rawValue,act,fail)
    }

    func trans(_ evt:FsmPush.Event,_ act:@escaping ()->Void={},_ fail:@escaping ()->Void = {}){
        transByMain(self._fsmApp.getFsmPush(),evt.rawValue,act,fail)
    }
    
    func trans(_ evt:FsmRtc.Event,_ act:@escaping ()->Void={},_ faile:@escaping ()->Void = {}){
        transByMain(self._fsmApp.getFsmCall().getFsmRtc(),evt.rawValue,act,faile)
    }
    
    func trans(_ evt:FsmMqtt.Event,_ act:@escaping ()->Void={},_ faile:@escaping ()->Void = {}){
        transByMain(self._fsmApp.getFsmMqtt(),evt.rawValue,act,faile)
    }
    
    func printState(){
        log.i("fsm state  fsmApp:   \(_fsmApp.states[_fsmApp.state])")
        log.i("          fsmPush:   \(_fsmApp.getFsmPush().states[_fsmApp.getFsmPush().state])")
        log.i("          fsmCall:   \(_fsmApp.getFsmCall().states[_fsmApp.getFsmCall().state])")
        log.i("          fsmMqtt:   \(_fsmApp.getFsmMqtt().states[_fsmApp.getFsmMqtt().state])")
    }
}
