//
//  GargetView.swift
//  demo
//
//  Created by ADMIN on 2022/2/11.
//

import SwiftUI
import AgoraIotCallkit
let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
let lightGreenColor = Color(red: 21.0/255.0, green: 183.0/255.0, blue: 177.0/255.0, opacity: 1.0)
let lightblueColor = Color(red: 85.0/255.0, green: 84.0/255.0, blue: 166.0/255.0, opacity: 1.0)

//MARK:-
//MARK:- Seperator (Bottom line view)
struct seperator: View {
    
    var body: some View {
    
        VStack {
            
            Divider().background(lightGreyColor)
            
        }.padding()
            .frame(height: 1, alignment: .center)
    }
}



struct FuncIcon : View{
    var img:String
    var txt:String
    var act:() -> Void
    var body : some View{
        Button(action:act){
            VStack(){
                if(img != ""){Image(img)}
                Text(txt).foregroundColor(.white)
            }
        }
        .frame(width:80,height: 40)
        .background(Color.gray).cornerRadius(5)
    }
}
//MARK:-
//MARK:- Rounded Image
struct RoundedImage: View {

    var body: some View {
        
        Image("logo")
           .resizable()
           .aspectRatio(contentMode: .fill)
           .frame(width: 150, height: 150)
           .clipped()
           .cornerRadius(150)
           .padding(.bottom, 40)
        
    }

}

struct RoundedRectangleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.black)
      Spacer()
    }
    .padding()
    .background(Color.yellow.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}


struct NavigationTitle: View{
    var title:String
    var leadingImg:String? = nil
    var leadingTxt:String? = nil
    var rear:String = ""
    var lclick:()->Void = {}
    var rclick:()->Void = {}
    var body: some View {
        HStack(){
            Button(action:lclick){
                if(leadingImg != nil){
                    Image(leadingImg!)
                }
                if(leadingTxt != nil){
                    Text(leadingTxt!).font(.title3).fontWeight(.semibold).foregroundColor(.white)
                }
            }
            Spacer()
            Text(title).font(.title2).fontWeight(.semibold).foregroundColor(.white)
            Spacer()
            Button(action:rclick){
                Text(rear).font(.title3).fontWeight(.semibold).foregroundColor(.white)
            }
            
        }
    }
}

struct NavigationBack: View{
    var body: some View {
        NavigationView {
           Text("Welcome to Stack Overflow")
            .navigationBarTitle("登录", displayMode: .inline)
            .navigationBarItems(leading: NavigationLink(destination: Text("Destination"))
            {
              //Image(systemName: "person.crop.circle.fill").font(.title)
                Text("<")
            }).frame(height: 100, alignment: .center)
        }.frame(height: 100, alignment: .center)
      }
}

//MARK:-
//MARK:- Button with background & shaadow
struct buttonWithBackground: View {
    
    var btnText: String
    
    var body: some View {
        
        HStack {
//            Spacer()
            Text(btnText)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 140, height: 50)
                .background(lightblueColor)
                .clipped()
                .cornerRadius(5.0)
                .shadow(color: lightblueColor, radius: 5, x: 0, y: 5)
            
//            Spacer()
        }
    }
}

struct CustomTabView: View {
    var views: [TabBarItem]
    @State var selectedIndex: Int = 4

    init(_ views: [TabBarItem]) {
        self.views = views
    }

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            VStack(){
                self.views[self.selectedIndex].view.background(self.selectedIndex == 4 ? Color.black : Color.white)
                Spacer(minLength: 50)
            }
                VStack {
                    Spacer()
                    ZStack(alignment: .top) {
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                            .frame(height: 50 + geometry.safeAreaInsets.bottom)

                        HStack {
                            ForEach(self.views.indices) { i in
                                Button(action: {
                                    self.selectedIndex = i
                                }) {
                                    VStack {
                                        if self.selectedIndex == i {
//                                            self.views[i].image
//                                                .foregroundColor(.white)
//                                                 .padding(.top,10)
//                                                .font(.title)
                                        } else {
//                                            self.views[i].image
//                                                .foregroundColor(Color.white.opacity(0.4))
//                                                .padding(.top,10)
//                                               .font(.title)
                                        }
                                        Text(self.views[i].title)
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 16, weight: .bold))
                                            .padding(.top,10)
                                            .opacity(0.5)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                //.animation(.easeInOut)
            }
        }
    }
}

struct AdsBar : View{
    var body: some View {
        ZStack(alignment: .leading){
            VStack(alignment:.leading){
                Text("稳定、安全、高效、高可扩展")
                    .foregroundColor(Color.white)
                    .padding(.top,10)
                HStack(){
                    Text("Ai+Home 云存储").font(.title2).fontWeight(.heavy).foregroundColor(.white)
                        .padding(.bottom,20)
                    Text("7")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                        .padding(.bottom,30)
                    Text("天试用")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .padding(.bottom,20)
                    Spacer()
                }
            }.padding(.leading,10)
        }
    }
}

struct TabBarItem {
    var view: AnyView
    //var image: Image
    var title: String

    init<V: View>(view: V, title: String) {
        self.view = AnyView(view)
        //self.image = image
        self.title = title
    }
}

struct RadioButton: View {
    let id: String
    let selectedID: String
    let callBack: (String) -> ()
    //初始化
    init(id: String, selectedID: String, callBack: @escaping (String) -> ()){
        self.id = id
        self.selectedID = selectedID
        self.callBack = callBack
    }
    
    var body: some View {
        Button(action: {
            self.callBack(self.id)
        }, label: {
            HStack(alignment: .center, spacing: 12, content: {
                Image(systemName: self.selectedID == self.id ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(self.selectedID == self.id ? Color.blue : Color.black)
                Text(self.id)
                    .font(Font.system(size: 20))
                    .foregroundColor(Color.black)
            })
        })
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    private var presentationMode

    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void

    final class Coordinator: NSObject,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void

        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}

struct AlertEditView: View{
    var title:String
    var hint:String = ""
    @Binding var text: String
    var btnLeft:Button<Text>? = nil
    var btnMidl:Button<Text>? = nil
    var btnRight:Button<Text>? = nil
    var body: some View{
        ZStack{
            VStack{
                Text(title).font(.headline).padding()
                TextField(hint, text: self.$text).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Divider()
                HStack{
                    if(btnLeft != nil){
                        Spacer()
                        btnLeft
                        Spacer()
                    }
                    if(btnMidl != nil){
                        Divider()
                        Spacer()
                        btnMidl
                        Spacer()
                    }
                    if(btnRight != nil){
                        Divider()
                        Spacer()
                        btnRight
                        Spacer()
                    }
                }
            }
        }
        .background(Color(white: 0.9))
        .frame(width: 300, height: 200)
        .cornerRadius(20)
        }
    
}

struct BlinkingView: View {
    @Binding var isAnimating: Bool
    let count: UInt = 10
    let size: CGFloat = 15

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(count)) { index in
                item(forIndex: index, in: geometry.size)
                    .frame(width: geometry.size.width, height: geometry.size.height)

            }
        }
        .aspectRatio(contentMode: .fit)
    }

    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
        let x = (geometrySize.width/2 - size/2) * cos(angle)
        let y = (geometrySize.height/2 - size/2) * sin(angle)
        return Circle()
            .frame(width: size, height: size)
            .scaleEffect(isAnimating ? 0.5 : 1)
            .opacity(isAnimating ? 0.25 : 1)
            .animation(
                Animation
                    .default
                    .repeatCount(isAnimating ? .max : 1, autoreverses: true)
                    .delay(Double(index) / Double(count) / 2)
            )
            .offset(x: x, y: y)
    }
}


public struct ActivityIndicator: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style

    public func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIView, context _: UIViewRepresentableContext<ActivityIndicator>) {
        let view = uiView as? UIActivityIndicatorView
        view?.startAnimating()
    }
}

struct SimpleRefreshingView: View {
    var body: some View {
        ActivityIndicator(style: .medium)
    }
}


struct PositionData: Identifiable {
    let id: Int
    let center: Anchor<CGPoint>
}

struct Positions: PreferenceKey {
    static var defaultValue: [PositionData] = []
    static func reduce(value: inout [PositionData], nextValue: () -> [PositionData]) {
        value.append(contentsOf: nextValue())
    }
}

//struct Data: Identifiable {
//    let id: Int
//}

class Model: ObservableObject {
    var _flag = false
    var flag: Bool {
        get {
            _flag
        }
        set(newValue) {
            if newValue == true {
                _flag = newValue

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self._flag = false
                    self.rows += 20
                    print("done")
                }
            }
        }
    }
    @Published var rows = 20
}

struct PullForMoreView: View {
    @ObservedObject var model = Model()
    var body: some View {
        List {
            ForEach(0 ..< model.rows, id:\.self) { i in
                Text("row \(i)").font(.largeTitle).tag(i)
            }
            Rectangle().tag(model.rows).frame(height: 0).anchorPreference(key: Positions.self, value: .center) { (anchor) in
                [PositionData(id: self.model.rows, center: anchor)]
            }.id(model.rows)
        }
        .backgroundPreferenceValue(Positions.self) { (preferences) in
            GeometryReader { proxy in
                Rectangle().frame(width: 0, height: 0).position(self.getPosition(proxy: proxy, tag: self.model.rows, preferences: preferences))
            }
        }
    }
    func getPosition(proxy: GeometryProxy, tag: Int, preferences: [PositionData])->CGPoint {
        let p = preferences.filter({ (p) -> Bool in
            p.id == tag
            })
        if p.isEmpty { return .zero }
        if proxy.size.height - proxy[p[0].center].y > 0 && model.flag == false {
            self.model.flag.toggle()
            print("fetch")
        }
        return .zero
    }
}
