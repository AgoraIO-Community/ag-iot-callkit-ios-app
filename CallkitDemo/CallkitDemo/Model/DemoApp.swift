//
//  DemoApp.swift
//  demo
//
//  Created by ADMIN on 2022/2/10.
//

import Foundation
import SwiftUI
import AgoraIotCallkit
class StateListener : ObservableObject{
    @Published var refresh:Bool = false
    public init(){
        demo.listener = self
    }
}

struct AccountInfoDiag : View{
    @State var name:String
//    @State var email:String
//    @State var phone:String
    var clk:(String)->Void
    var body: some View{
        VStack(){
            Text("修改个人信息").padding()
            HStack(){
                Text("昵称").padding()
            TextField("", text: $name)
                //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                .font(.body)
                //.imageScale(.small)
                .keyboardType(.default)
                .autocapitalization(UITextAutocapitalizationType.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            Button(action:{clk(name)}){
                Text("修改").padding()
            }
        }.frame(width:350,height: 200).background(Color.white).cornerRadius(10)
    }
}

struct EditNameDiag : View{
    @State var nickName : String
    var clk:(String)->Void
    var body: some View{
        VStack(){
            TextField("设置设备昵称", text: $nickName)
                //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                .font(.system(size: (UIScreen.main.bounds.width * 30) / 414, weight: .light, design: .default))
                //.imageScale(.small)
                .keyboardType(.default)
                .autocapitalization(UITextAutocapitalizationType.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action:{
                if(nickName == ""){
                    MyAlertView.shared.show("设备昵称不能为空")
                    return
                }
                clk(nickName)
                
            }){
                Text("确定")
            }
            }.frame(width:350,height: 200).background(Color.white).cornerRadius(10)
    }
}


class DemoApp{
    
    fileprivate var listener:StateListener? = nil
    
    func onDeviceOnOffline(online: Bool, deviceId: String, productId: String) {
        log.i("demo app deviceId:\(deviceId) productId:\(productId)  is \(online ? "online":"offline")")
        listener?.refresh.toggle()
    }
    
    func onDeviceActionUpdated(deviceId: String, actionType: String) {
        log.i("demo app deviceId:\(deviceId) \(actionType)")
        listener?.refresh.toggle()
    }
    
    func onDevicePropertyUpdated(deviceId: String,deviceNumber:String, props: [String : Any]?) {
        log.i("demo app deviceId:\(deviceId) deviceNumber:\(deviceNumber) props updated:\(String(describing: props))")
        //listener?.refresh.toggle()
    }
    
   // private var _context:Context = Context()
    private var _status = UserStatus()
    private var _fsm :FsmView?
    
    public static let shared = DemoApp()
    
    //var ctx:Context{get{return _context}}
    var status:UserStatus{get{return _status}}
    var fsm:FsmView{get{return _fsm!}}
    
    var sdk:IAgoraIotAppSdk?{get{return iotsdk}}
    
    func initialize(_ onPost:@escaping Fsm.PostFun)->Bool{
        log.level = .info
        log.i("demo app initialize()")
        
        _fsm = FsmView(onPost)
        _fsm?.listener = FsmViewListener(status)
        _status.setFsm(fsm: _fsm!)
        _fsm?.start(queue: DispatchQueue.main)
        
        var param:InitParam = InitParam()
        param.rtcAppId = Config.appId
        param.logFilePath = FileCenter.logFilePath()
        param.subscribeVideo = true
        param.subscribeAudio = true
        param.publishVideo = true
        param.publishAudio = true
        param.productKey = Config.productKey
        param.projectId = Config.projectId
        param.ntfApnsCertName = Config.ntfApnsCertName
        param.ntfAppKey = Config.ntfAppKey
        param.slaveServerUrl = Config.slaveServerUrl
        param.masterServerUrl = Config.masterServerUrl
        
        if(ErrCode.XOK != iotsdk.initialize(initParam: param,sdkStatus: {
            status,msg in
            log.w("demo app \(msg)(\(status))")
        },callBackFilter: { ec, msg in
            log.i("demo app callbackFilter result \(msg)(\(ec))")
            return (ec,msg)
        })){
            log.e("demo app initialize failed")
            return false
        }
        
        let answer:(AudioEffectId)->Void = {e in
            self.sdk?.callkitMgr.callAnswer(result: {ec,msg in
                log.i("demo app callAnswer ret:\(msg)(\(ec))")
                if(ec == ErrCode.XOK){
                    self._status.trans(FsmView.Event.MAIN)
                    self.sdk?.callkitMgr.setAudioEffect(effectId: e, result: {
                        ec,msg in
                        log.i("demo app audio effect \(msg)(\(ec))")
                    })
                }
            },actionAck: {ack in
                log.i("demo app callAnser ack:\(ack)")
                if(ack == .RemoteHangup){
                    self._status.trans(FsmView.Event.BACK)
                }
            })
        }
        
        let changeVoice = {
            let items:[BtnItem] = [
                BtnItem("普通",.NORMAL),
                BtnItem("老人",.OLDMAN),
                BtnItem("男孩",.BABYBOY),
                BtnItem("女孩",.BABYGIRL),
                BtnItem("猪八戒",.ZHUBAJIE),
                BtnItem("空灵",.ETHEREAL),
                BtnItem("低沉",.HULK)
            ]
            MyDialogView.shared.show(EffectSelector(items: items,act: {e in
                MyDialogView.shared.hide()
                answer(e)
                }))
        }
        
        sdk?.callkitMgr.register(incoming: {peer,msg,callin in
            if(callin == .CallIncoming){
                iotsdk.callkitMgr.mutePeerAudio(mute: true, result: {ec,msg in})
            let buttons = [
                OptionViewButton("接听",{answer(.NORMAL)}),
                OptionViewButton("变声接听",changeVoice),
                OptionViewButton("挂断",{self.sdk?.callkitMgr.callHangup(result: {ec,msg in
                    log.i("demo app callHangup ret:\(msg)(\(ec))")
                    self.status.trans(FsmView.Event.BACK)
                }
                                                                       
                )})]
                MyOptionView.shared.show("\(peer) is calling,msg:\(msg)",buttons: buttons)
            }
            else if(callin == .RemoteHangup){
                log.i("demo app remote hangup")
                MyOptionView.shared.hide()
                self.status.trans(FsmView.Event.BACK);
            }
            else if(callin == .RemoteVideoReady){
                log.i("demo app RemoteVideoReady")
                self.status.trans(FsmView.Event.MAIN);
            }
        })
        return true
    }
    
    func updateToken(deviceToken: Data){
        sdk?.notificationMgr.updateToken(deviceToken)
    }
    
    func register(_ acc: String, _ pwd:String,_ code:String,_ email:String?,_ phone:String?, _ cb:@escaping (Bool,String)->Void){
        log.i("demo app register(\(acc),********,\(code)")
        if(sdk == nil){
            cb(false,"sdk 未初始化")
        }
        let result = {
            (ec:Int,msg:String)->Void in
            var hint = ErrCode.XOK == ec ? "注册成功" : "注册失败"
            cb(ErrCode.XOK == ec ? true : false , hint + ":" + msg)
        }
    }
    
    func login(_ acc:String,_ cb:@escaping (Bool,String)->Void){
        log.i("demo app login(\(acc))")
        if(sdk == nil){
            cb(false,"sdk 未初始化")
        }
        let result = {
            (ec:Int,msg:String)->Void in
            var hint = ErrCode.XOK == ec ? "登录成功" : "登录失败"
            cb(ErrCode.XOK == ec ? true : false , hint + ":" + msg)
        }
        sdk?.accountMgr.login(account: acc,result: result)
    }


    func logout(_ cb:@escaping (Bool,String)->Void){
        log.i("demo app logout()")
        if(sdk == nil){
            cb(false,"sdk 未初始化")
        }
        sdk?.accountMgr.logout(result: {
            ec,msg in
            cb(ec == ErrCode.XOK ? true : false,msg)
        })
    }
    
    func setPeerVideoView(view: UIView?) -> Int{
        guard let callMgr = sdk?.callkitMgr else{
            //cb(false,"sdk 呼叫服务 未初始化")
            return ErrCode.XERR_BAD_STATE
        }
        let ret = callMgr.setPeerVideoView(peerView: view)
        if(ErrCode.XOK != ret){
            log.e("demo app iotsdk setPeerVideoView failed.\(ret)")
        }
        return ret
    }

    func hangupDevice(_ cb:@escaping(Bool,String)->Void){
        log.i("demo app local req Hangup")
        guard let callMgr = sdk?.callkitMgr else{
            cb(false,"sdk 呼叫服务 未初始化")
            return
        }
        iotsdk.callkitMgr.callHangup(result: { ec, msg in
            log.i("demo app call Hangup result:\(msg)(\(ec))")
            cb(ec == ErrCode.XOK ? true : false,msg)
        })
    }
    func getCalleeId(deviceId:String)->String? {
        let peer = Config.productKey + "-" + deviceId
        guard let bytes = peer.base32EncodedString else{
            return nil
        }
        return bytes.substring(to: bytes.findFirst("="))
    }
    func callDevice(_ devId:String,_ phone:Bool,_ cb:@escaping(Bool,String)->Void,_ action:@escaping(ActionAck)->Void){
        guard let callMgr = sdk?.callkitMgr else{
            cb(false,"sdk 呼叫服务 未初始化")
            return
        }
        let peerId = phone ? devId : getCalleeId(deviceId: devId)
        guard let peerId = peerId else {
            cb(false,"peerId is invalid")
            return
        }

        callMgr.callDial(peerId:peerId,attachMsg: "this is attach msg",result:{
            (ec,msg) in
            cb(ec == ErrCode.XOK ? true : false , msg)
        },actionAck: {s in
            var msg = "未知的设备操作"
            switch(s){
                case .RemoteAnswer:msg = "设备接听"
                case .RemoteHangup:msg = "设备挂断"
                case .RemoteBusy:msg = "设备忙碌"
                case .LocalAnswer:msg = "本地接听"
                case .LocalHangup:msg = "本地挂断"
                case .UnknownAction:msg = "未知行为"
                case .RemoteVideoReady:msg = "首次收到设备视频"
                case .RemoteAudioReady:msg = "首次收到设备音频"
                case .CallForward:msg = "呼叫中"
                case .CallIncoming:msg = "设备来电"
                case .CallOutgoing:msg = "本地拨通"
                case .RemoteTimeout:msg = "对端设备超时"
                case .LocalTimeout:msg = "本地超时"
                case .StateInited:msg = "状态初始化"
                case .RecordEnd:msg = "云录停止"
            }
            log.i("demo app 呼叫事件:\(msg)")
            if(s == .RemoteHangup){
                self._status.trans(FsmView.Event.BACK)
            }
            action(s)
        })
    }
}

let demo = DemoApp()
