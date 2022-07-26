import SwiftUI

struct CodeVerifyView: View {
    // Path to the dropped file
    @State var fileUrl: String = ""
      var myStyle: SecureCodeStyle {
        SecureCodeStyle(lineWidth: 20, lineHeight: 2, normalLineColor: .black, errorLineColor: .red, labelWidth: 20, labelHeight: 30, labelSpacing: 15, normalTextColor: .black, errorTextColor: .black, carrierHeight: 30, carrierSpacing: 5, carrierColor: .black)
    }
    var body: some View {
        SecureCodeVerifier(codeCount:"ddd".count)
            .onCodeFilled { s in
            
        }
    }
}


struct CodeVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        CodeVerifyView()
    }
}
