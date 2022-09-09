//
//  AppTitleView.swift
//  demo
//
//  Created by ADMIN on 2022/2/11.
//

import SwiftUI
import AgoraIotCallkit
struct MinePage: View {
    @EnvironmentObject var status: UserStatus
    var count:Int = 0
    @State var strCount:String = "0"
    @State var strAccount:String = "account"
    @State var showImagePicker:Bool = false
    @State var icon:String = ""
    var body: some View {
        VStack(){
            HStack(){
                Button(action:{showImagePicker.toggle()}){
                    ZStack(alignment:.bottom){
                        Image("ic_circle")
                        Image("ic_head")
                    }
                }
                .onAppear(perform: {
//                    iotsdk.accountMgr.getAccountInfo { ec, msg, info in
//                        if(ec == ErrCode.XOK && info != nil){
//                            icon = info!.avatar ?? ""
//                        }
//                    }
                })
                .sheet(isPresented: $showImagePicker) {
                            ImagePicker(sourceType: .photoLibrary) { image in
                                MyLoadingView.shared.show()
                                let prevIcon = icon
//                                icon = ""
//                                iotsdk.accountMgr.updateHeadIcon(image: image) { ec, msg,ic in
//                                    if(ec != ErrCode.XOK){
//                                        icon = prevIcon
//                                        MyLoadingView.shared.hide()
//                                        MyAlertView.shared.show(msg)
//                                    }
//                                    else{
//                                        icon = ic ?? ""
//                                        log.i("demo app icon :\(icon)")
//                                        let info = UserInfo()
//                                        info.avatar = icon
//                                        iotsdk.accountMgr.updateAccountInfo(info: info, result: {ec,msg in
//                                            MyLoadingView.shared.hide()
//                                            if(ec != ErrCode.XOK){
//                                                log.e("demo app updateAccountInfo failed:\(msg)(\(ec))")
//                                                MyAlertView.shared.show(msg)
//                                            }
//                                        })
//                                    }
//                                }
                            }
                        }
                VStack(alignment:.leading){
                    Text(status.account)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
//                    HStack(){
//                        Text(String(demo.ctx.devices == nil ? 0 : demo.ctx.devices!.count))
//                            .foregroundColor(Color.gray)
//                        Text("台 设备")
//                            .foregroundColor(Color.gray)
//                    }
                }
                Spacer()
                Image("ic_setting").padding()
            }
                
            AdsBar()
            .frame(width:UIScreen.main.bounds.width * 95/100)
            .background(Color.blue)
            .cornerRadius(10)
            Spacer()
            
            List(){
//            Button(action:{
//                userInfo()
//            })
//                {
//                    Text("用户信息").padding()
//                        .frame(minWidth:0,maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
            
//            Button(action:{
//                changePassword()
//            })
//                {
//                    Text("修改密码").padding()
//                        .frame(minWidth:0,maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//
//            Button(action:{
//                listProduct()
//            })
//                {
//                    Text("产品信息").padding()
//                        .frame(minWidth:0,maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//            Button(action:{
//                sharableList()
//            })
//            {
//                Text("可分享给他人的设备").padding()
//                    .frame(minWidth:0,maxWidth: .infinity)
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(8)
//            }
            
//            Button(action:{
//                sharedList()
//            })
//            {
//                Text("他人分享给我的设备").padding()
//                    .frame(minWidth:0,maxWidth: .infinity)
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(8)
//            }
                
//                Button(action:{
//                    queryPushList()
//                })
//                {
//                    Text("未处理的分享消息").padding()
//                        .frame(minWidth:0,maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
                
//                Button(action:{
//                    shareRemove()
//                })
//                {
//                    Text("收回共享出去的设备").padding()
//                        .frame(minWidth:0,maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
                
            Button(action:{
                logout()
            })
            {
                Text("退出").padding()
                    .frame(minWidth:0,maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
                
            Button(action:{
                unregister()
            })
            {
                Text("注销").padding()
                    .frame(minWidth:0,maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            Spacer()
            }
        }
        
    }
    func unregister(){
        MyLoadingView.shared.show()
        DemoApp.shared.unregister {succ, msg in
            MyLoadingView.shared.hide()
            if(!succ){
                MyAlertView.shared.show(msg)
            }
            else{
                status.trans(FsmView.Event.EXIT)
            }
        }
    }
    func logout(){
        DemoApp.shared.logout({
            succ,msg in
            if(!succ){
                MyAlertView.shared.show(msg,action: {
                        status.trans(FsmView.Event.EXIT)
                    })
            }
            else{
                icon = ""
                status.trans(FsmView.Event.EXIT)
            }
        })
    }
}

struct MinePage_Previews: PreviewProvider {
    static var previews: some View {
        MinePage()
    }
}


