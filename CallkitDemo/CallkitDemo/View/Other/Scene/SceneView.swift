//
//  Scene.swift
//  demo
//
//  Created by ADMIN on 2022/2/11.
//

import SwiftUI
//import AgoraIotSdk

struct SceneView: View {
    @State private var isRemoteJoined:Bool = false
    var view = UIView()

    var body: some View {
        Text("remoteView")
#if IOT_SDK
        AgoraVideoView(v:view).onAppear {
            log.i("ui appeared,setPeerVideoView ...")
            let ret = iotsdk.callkitMgr.setPeerVideoView(peerView: view)
            if(ErrCode.XOK != ret){
                log.e("iotsdk setPeerVideoView failed.\(ret)")
            }
        }.onDisappear {
            log.i("disappeared")
        }.scaledToFit().frame(width: 400, height: 400, alignment: .center)
        .background(Color.red.opacity(0.5))
#endif
    }
}

struct SceneView_Previews: PreviewProvider {
    static var previews: some View {
        SceneView().scaledToFit().frame(width: 200, height: 200, alignment: .center)
    }
}
