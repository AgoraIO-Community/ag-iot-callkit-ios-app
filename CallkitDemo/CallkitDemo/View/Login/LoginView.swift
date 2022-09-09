//
//  LoginView.swift
//  DemoSwiftUI
//
//  Created by mac-00018 on 10/10/19.
//  Copyright © 2019 mac-00018. All rights reserved.
//

import SwiftUI
//import AgoraIotSdk


struct LoginView: View {
    @EnvironmentObject var status: UserStatus
    @State var account: String = "13438383880"
    @State var password: String = "gzh8888"
    
    @State private var showForgotPassword = false
    @State private var showSignup = false
    //@State var showAlert = false
    @State var showDetails = false
    //@State var alertMessage:String = ""
    //@State var loading = false
    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
                NavigationView{
                    ZStack(){
                    VStack {
                            Text("登录")
                                .font(.title)
                                .fontWeight(.heavy).padding()
                            
                            TextField("账号", text: $account)
                                //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 30) / 414, weight: .light, design: .default))
                                //.imageScale(.small)
                                .keyboardType(.default)
                                .autocapitalization(UITextAutocapitalizationType.none)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            SecureField("密码", text: $password)
                                //.frame(height: (UIScreen.main.bounds.width * 90) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 30) / 414, weight: .light, design: .default))
                                //.imageScale(.small)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
//                        HStack() {
//                            Spacer()
//                            Button(action: {
//                                let buttons = [
//                                    OptionViewButton("邮箱找回",{
//                                        status.trans(FsmView.Event.FORGETPWD)
//                                    }),
//                                    OptionViewButton("手机找回",{
//                                        status.trans(FsmView.Event.FORGETPWDBYPHONE)
//                                    })]
//                                MyOptionView.shared.show("找回方式", buttons: buttons)
//                            }) {
//                                Text("忘记密码")
//                                    .foregroundColor(Color.black)
//                                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight:.bold, design: .default))
//                            }
//
//                        }.padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                        
                    Button(action:{
                        if (self.isValidInputs()) {
                            MyLoadingView.shared.show("登录中...")
                            DemoApp.shared.login(account,password,
                            { succ,msg in
                                MyLoadingView.shared.hide()
                                if(succ){
                                    status.account = account
                                    status.password = password
                                    status.trans(FsmView.Event.LOGINED)
                                }
                                else {
                                    MyAlertView.shared.show(msg)
                                    //status.trans(FsmView.Event.LOGIN_FAIL)
                                }
                            })
                        }
                    })
                    {
                        Text("登录").padding()
                            .frame(minWidth:0,maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }.padding()
                        
                        
                    Button(action:{
                        if (self.isValidInputs()) {
                            MyLoadingView.shared.show("注册中...")
                            DemoApp.shared.register(account,password,
                            { succ,msg in
                                MyLoadingView.shared.hide()
                                MyAlertView.shared.show(msg)
                            })
                        }
                    })
                    {
                        Text("注册").padding()
                            .frame(minWidth:0,maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }.padding()
                    Spacer()
                    }
                        .padding()
                        .padding(.top,30)
                        .navigationBarItems(leading: Button(action:{
                                status.trans(FsmView.Event.LOGINBACK)
                            }){Text("返回")}, trailing: Text("选择"))
                    }
                }
        }
    }
    
    fileprivate func isValidInputs() -> Bool {
        return true
        var alertMsg:String = ""
        if self.account == "" {
            alertMsg = "Account can't be blank."
        } else if !self.account.isValidEmail && !self.account.isValidPhone {
            alertMsg = "Account is not valid."
        } else if self.password == "" {
            alertMsg = "Password can't be blank."
        } else if !(self.password.isValidPassword) {
            alertMsg = "Please enter valid password"
        }
        if(alertMsg != ""){
            MyAlertView.shared.show(alertMsg)
        }
        return alertMsg == "" ? true : false
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

