//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import SwiftUI
import Foundation

struct SplashView: View {
    @EnvironmentObject var status: UserStatus
    let color = Color.black

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image("splash")
            }
            
            Spacer()
            VStack(alignment:.leading){
                Text("Welcome!")
                    .font(.system(size: 56.19,weight: .bold,design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 100)
            }
            Spacer()
        }
        .background(color)
        .onAppear(perform: {
            self.gotoLoginScreen(time: 2.5)
        })
    }

    func gotoLoginScreen(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            status.trans(FsmView.Event.CHECK)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
