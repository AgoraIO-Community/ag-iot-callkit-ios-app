//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import SwiftUI
import Foundation
import AgoraIotCallkit
struct WelcomeView: View {
    @EnvironmentObject var status: UserStatus
    let color = Color.init("black")

    var body: some View {
        ZStack(){
            VStack(){
                Image("splash").resizable().opacity(0.08).scaledToFill()
            }
            VStack(spacing: 10.0){
                Spacer()
                Text("Welcome!")
                .font(.system(size: 56.19,weight: .bold,design: .rounded))
                .foregroundColor(Color.blue)
                Text("智能·安全·便捷").font(.title3).foregroundColor(Color.black)
                Spacer()
                Button(action:{
                    status.trans(FsmView.Event.LOGIN)
                })
                {
                    Text("登录").padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }.padding()
                Spacer()
            }
        }.background(Color.white)
        .onAppear(){
//            let buttons = [
//                OptionViewButton("进入频道",{
//                    iotsdk.testMgr.enterChannel()
//                    status.trans(FsmView.Event.MAIN)
//                }),
//                OptionViewButton("离开频道",{
//                    iotsdk.testMgr.leaveChannel()
//                })]
//            MyOptionView.shared.show(" is calling",buttons: buttons)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environment(\.sizeCategory, .large)
    }
}
