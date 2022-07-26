//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import Foundation
import SwiftUI
import AgoraIotCallkit
struct HomeView: View {
    @EnvironmentObject var status: UserStatus
   
    //@State private var devices:[IotDevice]? = demo.ctx.devices
    @State var selection = 0

    var body: some View {
        TabView(selection: $selection,
                        content:  {
                            HomePage().tabItem() {
                                Image(systemName: "house.fill")
                                Text("首页").font(.title3).padding()
                            }.tag(0)
                            MinePage().tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("我的").font(.title3).padding()
                                            }.tag(1)
                            }).accentColor(.blue)
    }

    func gotoLoginScreen(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
//            status.trans(FsmView.Event.WELCOME)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
