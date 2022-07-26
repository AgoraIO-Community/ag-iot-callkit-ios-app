//
//  ContentView.swift
//  APAlertView
//
//  Created by Arvind on 12/04/21.
//
import Foundation
import SwiftUI

struct OptionViewButton : Identifiable{
    let id = UUID()
    let text:String
    let click:()->Void
    init(_ text:String,_ click:@escaping()->Void){
        self.text = text
        self.click = click
    }
}

@available(iOS 13.0, *)
private struct OptionView: View {
    
    //MARK: Binding
    @Binding var isShowing: Bool
    @State var opacity: Double = 0
   
    //MARK: variables for view
    let titleText: String
    let messageText: String
    let buttons: [OptionViewButton]
    let optionBackgroundColor: Color
    let optionTextColor: Color
    let optionButtonTextColor: Color
    let optionButtonBackgroundColor: Color
    
    //MARK: body
    var body: some View {
        
        ZStack(alignment: .center) {
            
            VStack(spacing: 10) {
                
                if titleText.count > 0 {
                    Text(titleText)
                        .foregroundColor(optionTextColor)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                }
                
                Text(messageText)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .foregroundColor(optionTextColor)
                    .padding(.bottom , 20)
                
                seperator()
                
                HStack(alignment:.center){
                    ForEach(buttons) { btn in
                        Spacer()
                        Button(action:{
                            btn.click()
                            MyOptionView.shared.hide()}){
                            Text(btn.text)
                                .font(.system(size: 15))
                                .foregroundColor(optionButtonTextColor)
                                .fontWeight(.bold)
                                .padding(.all)
                        }
                    }
                    Spacer()
                }
                .frame(width: 300)
                .cornerRadius(20)
                
//                Button(action: {
//                    MyOptionView.shared.removeOption()
//                }) {
//                    Text(buttonText)
//                        .font(.system(size: 14))
//                        .foregroundColor(alerteButtonTextColor)
//                        .fontWeight(.bold)
//                        .frame(width: 130, height: 40)
//                }
//                .frame(width: 130, height: 40)
//                .background(alertButtonBackgroundColor)
//                .cornerRadius(20)
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
            .frame(width: 300)
            .background(optionBackgroundColor)
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
public class MyOptionView {
    public static var shared = MyOptionView()
    private init() { }
    private var popupWindow: OptionWindow?
    
    func show(_ message: String = "",
                       title: String = "警告",
                       buttons:[OptionViewButton],
                       optionBackgroundColor: Color = .white,
                       optionTextColor: Color = .black,
                       optionButtonTextColor: Color = .black,
                       optionButtonBackgroundColor: Color = .white) {
        
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        let alertView = OptionView(isShowing:  .constant(true),
                                  titleText: title,
                                  messageText: message,
                                  buttons: buttons,
                                  optionBackgroundColor: optionBackgroundColor,
                                  optionTextColor: optionTextColor,
                                  optionButtonTextColor: optionButtonTextColor,
                                  optionButtonBackgroundColor: optionButtonBackgroundColor)
            
        
        if let windowScene = windowScene as? UIWindowScene {
            popupWindow = OptionWindow(windowScene: windowScene)
            popupWindow?.frame = UIScreen.main.bounds
            popupWindow?.backgroundColor = .clear
            popupWindow?.rootViewController = UIHostingController(rootView: alertView)
            popupWindow?.rootViewController?.view.backgroundColor = .clear
            popupWindow?.makeKeyAndVisible()
        }
    }
    
    func hide() {
        let alertwindows = UIApplication.shared.windows.filter { $0 is OptionWindow }
        
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
private class OptionWindow: UIWindow {
}

