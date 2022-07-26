//
//  ContentView.swift
//  demo
//
//  Created by ADMIN on 2022/1/27.
//

import SwiftUI
//import AgoraIotSdk

//#define ViewMap(view) FsmView.State.view.rawValue:view.self

struct ContentView: View {
    @EnvironmentObject var status: UserStatus
    let views:Dictionary<Int,()->AnyView> =
    [
        FsmView.State.SplashView.rawValue:{return AnyView(SplashView())},
        FsmView.State.WelcomeView.rawValue:{return AnyView(WelcomeView())},
        FsmView.State.LoginView.rawValue:{return AnyView(LoginView())},
        FsmView.State.HomeView.rawValue:{return AnyView(HomeView())},
        FsmView.State.DeviceMainView.rawValue:{return AnyView(DeviceMainView())},
    ]
    
    var body: some View {
        let v = views[status.view]
        if(v != nil){
            //return AnyView(CodeVerifyView())
            return v!()
        }
        log.e("unknown view for view id:\(status.view) ,use SplashView as default")
        return AnyView(SplashView())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
