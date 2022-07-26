    //
    //  SecureCodeVerifier.swift
    //  CodeVerifier
    //
    //  Created by MUSOLINO Antonino on 03/03/2020.
    //

import SwiftUI

public struct SecureCodeVerifier: View {
    
        /// The style applied to SecureCodeVerifier
    @Environment(\.secureCodeStyle) var style: SecureCodeStyle
    
    @State private var insertedCode: String = ""
    @State private var isTextFieldFocused: Bool = false
    
    @StateObject private var viewModel: SecureCodeVerifierViewModel
    
        /// The size of the SecureCodeVerifier
    private var textfieldSize: CGSize = .zero
    
    private var action: ((String) -> Void)?
    
    public init(codeCount: Int) {
        self._viewModel = StateObject(wrappedValue: SecureCodeVerifierViewModel(codeCount: codeCount))
        let height = style.labelHeight + style.lineHeight + style.carrierSpacing
        let width = (style.labelWidth * CGFloat(codeCount)) + (style.labelSpacing * CGFloat(codeCount - 1))
        self.textfieldSize = CGSize(width: width, height: height)
    }
    
    public var body: some View {
        CodeView(fields: viewModel.fields)
            .background(
                Rectangle()
                    .foregroundColor(.white)
            )
            .background(
                SecureTextfield(text: $insertedCode, isFocusable: $isTextFieldFocused, labels: viewModel.fieldNumber)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .frame(width: textfieldSize.width, height: textfieldSize.height)
            .padding()
            .onChange(of: insertedCode) { newValue in
                viewModel.buildFields(for: newValue)
            }
            .onReceive(viewModel.$codeValue.dropFirst()) { value in
                action?(value)
            }
    }
}

extension SecureCodeVerifier {
    public func onCodeFilled(perform action: ((String) -> Void)?) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
    
    @available(*, deprecated, message: "Use the environment injection instead. This modifier does nothing.")
    public func withStyle(_ style: SecureCodeStyle) -> Self {
        return self
    }
}

struct SecureCodeVerifier_Previews: PreviewProvider {
    static var previews: some View {
        SecureCodeVerifier(codeCount: "123456".count)
    }
}
