//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import SwiftUI
import Foundation

struct DeviceMainView: View {
    @EnvironmentObject var status: UserStatus
    var body: some View {
        VStack(){
            ZStack(){
                HStack(){
                Button(action:{
                                demo.hangupDevice({succ,msg in})
                                status.trans(FsmView.Event.BACK)
                }){Text("返回")}.padding(.leading,10)
                Spacer()
                }
            }
            FuncPage()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceMainView()
    }
}

