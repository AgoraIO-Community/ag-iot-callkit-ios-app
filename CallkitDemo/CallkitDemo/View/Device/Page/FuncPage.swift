//
//  SplashView.swift
//  Demo
//
//  Created by ADMIN on 2022/2/28.
//

import SwiftUI
import Foundation
import AgoraIotCallkit
struct BtnItem:Hashable{
    let s:String
    let n:AudioEffectId
    init(_ s:String,_ e:AudioEffectId){
        self.s = s
        self.n = e
    }
}
struct EffectSelector : View{
    var items:[BtnItem]
    var act:(AudioEffectId)->Void
    var body : some View{
        VStack(){
            ForEach(items,id:\.self){item in
                Button(action:{act(item.n)}){
                    Text(item.s)
                }.padding(.top)
            }
        }
        .frame(width:140)
        .background(Color.white).cornerRadius(5)
    }
}

struct IntSlider: View {
   
    @State var value:Float
    @State private var isEditing = false
    @State private var value1:Float = 0.0
    var maxV:Float
    var done:(Int)->Void
    
    var body: some View {
        VStack {
            Text(String(Int(value)))
                .foregroundColor(isEditing ? .red : .black)
            Slider(value: $value, in: 0...maxV, step: 1, onEditingChanged: { (isEditing) in
                self.isEditing = isEditing
            }, minimumValueLabel: Text("1"), maximumValueLabel: Text(String(Int(maxV)))) {
                Text("1")
            }
            Button(action:{done(Int(value))}){
                Text("确定")
            }.padding()
            .accentColor(.green)
            .border(Color.white)
        }.background(Color.white).padding().frame(width:400).cornerRadius(5)
    }
}

struct Captured:View{
    let img:UIImage
    let clk:()->Void
    var body: some View{
        VStack{
            Image(uiImage: img)
            Button(action:clk){
                Text("确定")
            }.padding()
        }.background(Color.white).cornerRadius(10)
    }
}

struct FuncPage: View {
    @EnvironmentObject var status: UserStatus
    var info:String = "info"
    var title:String = "dev name"
    
    let view = UIView()
    let color = Color.black
    let iccolor = Color.gray
    var body: some View {
        VStack(alignment:.center){
            HStack(spacing:15){
                Button(action: {}){Text("高清").foregroundColor(.white)}
                Button(action: {}){Image("ic_save")}
                Button(action: {}){Image("ic_mute")}
                Button(action: {}){Image("ic_bar")}
            }.padding(.bottom,5).padding(.top,10)
        AgoraVideoView(v:view).onAppear {
            log.i("ui appeared,setPeerVideoView ...")
            demo.setPeerVideoView(view: view)
        }.onDisappear {
            log.i("disappeared")
            //demo.setPeerVideoView(view: nil)
        }
        .scaledToFit()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 3/5, alignment: .center)
        .background(Color.red.opacity(0.5))
        Spacer()
        }.background(Color.black)
    }
    struct DpOp{
        let op:String
        let va:()->Void
        init(_ op:String,_ va:@escaping()->Void){
            self.op = op
            self.va = va
        }
    }
    private func callDp(_ ops:[DpOp]){
        var btns:[OptionViewButton] = []
        for i in ops{
            let b = OptionViewButton(i.op,{i.va();sync()})
            btns.append(b)
        }
        MyOptionView.shared.show("",title:"操作",buttons: btns)
    }
}

struct FuncPage_Previews: PreviewProvider {
    static var previews: some View {
        FuncPage()
    }
}


