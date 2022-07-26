//
//  Modifier.swift
//  Demo
//
//  Created by ADMIN on 2022/3/7.
//

import Foundation
import SwiftUI

struct AlertStyle: ViewModifier {
    @State var showAlert:Bool = true
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.red)
            .foregroundColor(Color.white)
            .font(.largeTitle)
            .cornerRadius(10)
            .shadow(radius: 3)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hello SwiftUI!"),
                      message: Text("This is some detail message"),
                      dismissButton: .default(Text("OK")))
            }
    }
}


extension Alert{
    init(_ message:String){
        self.init(title: Text("警告"),
              message: Text(message),
              dismissButton: .default(Text("确定")))
    }
}

//extension View{
//    func myAlert(_ message:Binding<String>,_ action:@escaping ()->Void)->some View{
//        var bind:Bool = message.wrappedValue == "" ? false : true
//        let show = Binding<Bool>(get:{ return bind }, set:{ bind = $0 })
// //       return self.alert(Text("警告"),isPresented: show,presenting: Text(message.wrappedValue),actions: {_ in})
//        return self.alert(isPresented: show, content: {
//            Alert(title:Text("警告"),
//                  message: Text(message.wrappedValue),
//                  dismissButton: .default(Text("确定")){
//                message.wrappedValue = ""
//                action()
//            })
//
//        })
//    }
//}
//
//struct LoadingView : View{
//    @State var isAnimating: Bool = false
//    let count: UInt = 10
//    let size: CGFloat = 15
//    var body: some View{
//        if(isAnimating){
//            HStack(){
//                    Spacer()
//                    VStack(){
//                        Spacer()
//                        VStack(){
//                            Blinking(isAnimating: $isAnimating)
////                            GeometryReader { geometry in
////                                ForEach(0..<Int(count)) { index in
////                                    item(forIndex: index, in: geometry.size)
////                                        .frame(width: geometry.size.width, height: geometry.size.height)
////
////                                }
////                            }
////                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.blue)
//                            .frame(width: 100, height: 100, alignment:.center)
//                            Text("loading")
//                        }
//                        .frame(width: 250, height: 150, alignment:.center)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        Spacer()
//                        Spacer()
//                    }
//                    Spacer()
//                }.background(Color(red: 0.841, green: 0.841, blue: 0.841,opacity:0.9))
//            }
//        else{
//            HStack(){}
//        }
//    }
//    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
//        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
//        let x = (geometrySize.width/2 - size/2) * cos(angle)
//        let y = (geometrySize.height/2 - size/2) * sin(angle)
//        return Circle()
//            .frame(width: size, height: size)
//            .scaleEffect(isAnimating ? 0.5 : 1)
//            .opacity(isAnimating ? 0.25 : 1)
//            .animation(
//                Animation
//                    .default
//                    .repeatCount(isAnimating ? .max : 1, autoreverses: true)
//                    .delay(Double(index) / Double(count) / 2)
//            )
//            .offset(x: x, y: y)
//    }
//}
