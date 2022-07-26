//
//  ContentView.swift
//  APAlertView
//
//  Created by Arvind on 12/04/21.
//
import Foundation
import SwiftUI


@available(iOS 13.0, *)
struct LoadingView: View {
    
    //MARK: Binding
    @Binding var isShowing: Bool
    @State var opacity: Double = 0
   
    //MARK: variables for view
    let messageText: String
    let backgroundColor: Color
    let textColor: Color
    
    let count: UInt = 10
    let size: CGFloat = 15
    @State var scale:Double = 0.5
    @State var opaci:Double = 0.25

    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
        let x = (geometrySize.width/2 - size/2) * cos(angle)
        let y = (geometrySize.height/2 - size/2) * sin(angle)
        return Circle()
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opaci)
            .animation(
                Animation
                    .default
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) / Double(count) / 2)
            )
            .offset(x: x, y: y)
            .onAppear(){withAnimation{
                scale = 1
                opaci = 1
            }}
    }
    
    //MARK: body
    var body: some View {
        
        ZStack(alignment: .center) {
            
            VStack(spacing: 10) {
                
                GeometryReader { geometry in
                    ForEach(0..<Int(count)) { index in
                        item(forIndex: index, in: geometry.size)
                            .frame(width: geometry.size.width, height: geometry.size.height)

                    }
                }
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.blue)
                
                Text(messageText)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    
                    .foregroundColor(textColor)
                    .padding()
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
            .frame(width: 300,height: 200)
            .background(backgroundColor)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        }
        //.opacity(opacity)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20, alignment: .center)
        .background(Color(UIColor.gray.withAlphaComponent(0.5)).opacity(opacity))
//        .animation(Animation.linear(duration: 0.6))
//        .onAppear() { withAnimation {
//            opacity = 1
//          }
//        }
    }
}

@available(iOS 13.0, *)
public class MyLoadingView {
    public static var shared = MyLoadingView()
    private init() { }
    private var popupWindow: LoadingWindow?

    func show(_ message: String = "",
                       backgroundColor: Color = .white,
                       textColor: Color = .black) {
        
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        let loadingView = LoadingView(isShowing:  .constant(true),
                                  messageText: message,
                                  backgroundColor: backgroundColor,
                                  textColor: textColor)
        
        if let windowScene = windowScene as? UIWindowScene {
            popupWindow = LoadingWindow(windowScene: windowScene)
            popupWindow?.frame = UIScreen.main.bounds
            popupWindow?.backgroundColor = .clear
            popupWindow?.rootViewController = UIHostingController(rootView: loadingView)
            popupWindow?.rootViewController?.view.backgroundColor = .clear
            popupWindow?.makeKeyAndVisible()
        }
    }
    func isVisiable()->Bool{return popupWindow != nil}
    func hide() {
        let loadingwindows = UIApplication.shared.windows.filter { $0 is LoadingWindow }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            loadingwindows.forEach { (window) in
                window.alpha = 0
            }
        } completion: { (complete) in
            loadingwindows.forEach { (window) in
                window.removeFromSuperview()
            }
            self.popupWindow = nil
        }
    }
}

// MARK: - AlertWindow
private class LoadingWindow: UIWindow {
}

