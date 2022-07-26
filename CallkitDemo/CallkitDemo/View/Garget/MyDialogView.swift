//
//  MyDialogView.swift
//  SwiftUiDemo
//
//  Created by ADMIN on 2022/5/24.
//


import Foundation
import SwiftUI

@available(iOS 13.0, *)
private struct DialogView<Content>: View where Content:View {
    @State var opacity: Double = 0
    @State var content: Content
    var body: some View {
        VStack(){
            content
        }.opacity(opacity)
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
public class MyDialogView {
    public static var shared = MyDialogView()
    private init() { }
    private var popupWindow: OptionWindow?
    
    func show<Content>(_ contentView:Content) where Content:View {
        
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        let alertView = DialogView(content: contentView)
        
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

