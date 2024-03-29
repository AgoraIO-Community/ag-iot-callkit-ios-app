//
//  ContentView.swift
//  APAlertView
//
//  Created by Arvind on 12/04/21.
//
import Foundation
import SwiftUI


@available(iOS 13.0, *)
private struct AlertView: View {
    
    //MARK: Binding
    @Binding var isShowing: Bool
    @State var opacity: Double = 0
   
    //MARK: variables for view
    let titleText: String
    let messageText: String
    let buttonText: String
    let alertBackgroundColor: Color
    let alertTextColor: Color
    let alerteButtonTextColor: Color
    let alertButtonBackgroundColor: Color
    let action:()->Void
    
    //MARK: body
    var body: some View {
        
        ZStack(alignment: .center) {
            
            VStack(spacing: 10) {
                
                if titleText.count > 0 {
                    Text(titleText)
                        .foregroundColor(alertTextColor)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                }
                
                Text(messageText)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .foregroundColor(alertTextColor)
                    .padding(.bottom , 20)
                
                seperator()
                
                Button(action: {
                    MyAlertView.shared.hide()
                }) {
                    Text(buttonText)
                        .font(.system(size: 14))
                        .foregroundColor(alerteButtonTextColor)
                        .fontWeight(.bold)
                        .frame(width: 130, height: 40)
                }
//                .frame(width: 130, height: 40)
//                .background(alertButtonBackgroundColor)
//                .cornerRadius(20)
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
            .frame(width: 300)
            .background(alertBackgroundColor)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        }
        .opacity(opacity)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20, alignment: .center)
        .background(Color(UIColor.gray.withAlphaComponent(0.5)).opacity(opacity))
        .animation(Animation.linear(duration: 0.6))
        .onAppear() { withAnimation {
            opacity = 1
          }
        }
    }
}

@available(iOS 13.0, *)
public class MyAlertView {
    public static var shared = MyAlertView()
    private init() { }
    private var popupWindow: AlertWindow?
    
    func show(_ message: String = "",
                       title: String = "警告",
                       buttonTitle: String = "确定",
                       alertBackgroundColor: Color = .white,
                       alertTextColor: Color = .black,
                       alertButtonTextColor: Color = .black,
                       alertButtonBackgroundColor: Color = .white,
                       action:@escaping()->Void = {}) {
        
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        let alertView = AlertView(isShowing:  .constant(true),
                                  titleText: title,
                                  messageText: message,
                                  buttonText: buttonTitle,
                                  alertBackgroundColor: alertBackgroundColor,
                                  alertTextColor: alertTextColor,
                                  alerteButtonTextColor: alertButtonTextColor,
                                  alertButtonBackgroundColor: alertButtonBackgroundColor,
                                  action: action)
            
        
        if let windowScene = windowScene as? UIWindowScene {
            popupWindow = AlertWindow(windowScene: windowScene)
            popupWindow?.frame = UIScreen.main.bounds
            popupWindow?.backgroundColor = .clear
            popupWindow?.rootViewController = UIHostingController(rootView: alertView)
            popupWindow?.rootViewController?.view.backgroundColor = .clear
            popupWindow?.makeKeyAndVisible()
        }
    }
    
    func hide() {
        let alertwindows = UIApplication.shared.windows.filter { $0 is AlertWindow }
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
            alertwindows.forEach { (window) in
                window.alpha = 0
            }
        } completion: { (complete) in
            alertwindows.forEach { (window) in
                window.removeFromSuperview()
            }
            self.popupWindow = nil
        }
    }
}

// MARK: - AlertWindow
private class AlertWindow: UIWindow {
}
