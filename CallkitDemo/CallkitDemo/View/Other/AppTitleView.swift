//
//  AppTitleView.swift
//  demo
//
//  Created by ADMIN on 2022/2/11.
//

import SwiftUI

struct AppTitleView: View {
    @EnvironmentObject var status: UserStatus
    var body: some View {
        NavigationView{
        VStack() {
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Text("请选择重置设备")
                        .font(.title3)
                        .fontWeight(.black),
            trailing: Button(action:{
                            status.trans(FsmView.Event.BACK)
                        }){Text("取消")})
                }
    }
}
struct AppTitleView_Previews: PreviewProvider {
    static var previews: some View {
        AppTitleView()
    }
}

