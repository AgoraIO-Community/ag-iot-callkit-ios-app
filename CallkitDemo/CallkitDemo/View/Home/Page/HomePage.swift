//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import Foundation
import SwiftUI
import AgoraIotCallkit

struct HomePage: View {
    @EnvironmentObject var status: UserStatus
    @StateObject var statusObserver = StateListener()
    @State var devid:String = "IVFESSRUKNJTMNCJNVFDKLKTKVHF6VCTKRPTAMBS"
    @State var phoneid:String = "100000000000000000-727334130958385152"
    var body: some View {
        VStack(alignment:.leading){
            Text("当前账号:" + status.account).font(.system(size: (UIScreen.main.bounds.width * 19) / 414, weight: .light, design: .default))
            Text("sdk登录:" + Config.projectId + "-" + status.account).font(.system(size: (UIScreen.main.bounds.width * 19) / 414, weight: .light, design: .default))
            Text("手机Id:\n" + iotsdk.accountMgr.getUserId()).font(.system(size: (UIScreen.main.bounds.width * 19) / 414, weight: .light, design: .default))
            
            
            HStack(){
                Text("手机Id:").font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
                TextField("被叫phoneId", text: $phoneid)
                    //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                    .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                    .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    .font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
                    //.imageScale(.small)
                    .keyboardType(.default)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.padding()
            }
            HStack(alignment:.center){
                Spacer()
                Button(action:{
                    callDevice(id: phoneid,phone:true)
                }){
                    Text("呼叫手机").font(.system(size: (UIScreen.main.bounds.width * 30) / 414, weight: .light, design: .default))
                }.padding()
                Spacer()
            }
            HStack(){
                Text("产品Key:").font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
                Text(Config.productKey)
            }
            HStack(){
                Text("设备Id:").font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
                TextField("被叫deviceId", text: $devid)
                    //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                    .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                    .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    .font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
                    //.imageScale(.small)
                    .keyboardType(.default)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.padding()
            }
            HStack(alignment:.center){
                Spacer()
                Button(action:{
                    callDevice(id: devid,phone: false)
                }){
                    Text("呼叫设备").font(.system(size: (UIScreen.main.bounds.width * 30) / 414, weight: .light, design: .default))
                }.padding()
                Spacer()
            }
            if(devid != ""){
                Text("生成被叫设备id('productKey'-'deviceId'):")
                Text(DemoApp.shared.getCalleeId(deviceId: devid) ?? "").font(.system(size: (UIScreen.main.bounds.width * 18) / 414, weight: .light, design: .default))
            }
            Spacer()
        }
    }
    func callDevice(id:String,phone:Bool){
        if(id == ""){
            log.e("callDevice empty device")
            MyAlertView.shared.show("请输入设备id")
            return
        }
        log.i("callDevice \(id)")
        MyLoadingView.shared.show("正在呼叫设备...")
        DemoApp.shared.callDevice(id,phone, {(succ,msg) in
            log.i("demo app calldail ret:\(msg)(\(succ))")
            MyLoadingView.shared.hide()
            if(!succ){
                MyOptionView.shared.hide()
                MyAlertView.shared.show(msg)
            }
            else{
                
            }
        },{act in
            log.i("demo app calldail act:\(act.rawValue)")
            if(act == .CallOutgoing){
                MyLoadingView.shared.hide()
                let opts = [OptionViewButton("本机\n挂断",{
                    log.i("demo app local req Hangup")
                    iotsdk.callkitMgr.callHangup(result: { ec, msg in
                    log.i("demo app call Hangup result:\(msg)(\(ec))")})
                }),
                ]
                MyOptionView.shared.show("响铃中...",title:"测试", buttons: opts)
            }
            else if(act == .RemoteBusy){
                MyOptionView.shared.hide()
                MyAlertView.shared.show("设备忙碌")
            }
            else if(act == .RemoteHangup){
                MyOptionView.shared.hide()
                MyAlertView.shared.show("设备挂断")
            }
            else if(act == .RemoteAnswer){
                MyOptionView.shared.hide()
                status.trans(FsmView.Event.MAIN)
            }
            else if(act == .RemoteTimeout){
                MyOptionView.shared.hide()
                MyAlertView.shared.show("设备超时")
            }
            else if(act == .LocalTimeout){
                MyOptionView.shared.hide()
                MyAlertView.shared.show("本地超时")
            }
        })
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}


