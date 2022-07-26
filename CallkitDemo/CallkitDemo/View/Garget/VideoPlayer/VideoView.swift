//
//  VideoView.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/2/15.
//

import Foundation
import UIKit
import SwiftUI

public class VideoView: UIView {
    
    fileprivate(set) var videoView: UIView!
    
    fileprivate var infoView: UIView!
    fileprivate var infoLabel: UILabel!
    
    var isVideoMuted = false {
        didSet {
            videoView?.isHidden = false
        }
    }
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black
        addVideoView()
        addInfoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoView {
    func update(with info: String) {
        infoLabel?.text = info
    }
}

private extension VideoView {
    func addVideoView() {
        videoView = UIView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = UIColor.black
        addSubview(videoView)
        
        let videoViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[video]|", options: [], metrics: nil, views: ["video": videoView])
        let videoViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[video]|", options: [], metrics: nil, views: ["video": videoView])
        NSLayoutConstraint.activate(videoViewH + videoViewV)
    }
    
    func addInfoView() {
        infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = UIColor.clear
        
        addSubview(infoView)
        let infoViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[info]|", options: [], metrics: nil, views: ["info": infoView])
        let infoViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:[info(==140)]|", options: [], metrics: nil, views: ["info": infoView])
        NSLayoutConstraint.activate(infoViewH + infoViewV)
        
        func createInfoLabel() -> UILabel {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.text = " "
            label.shadowOffset = CGSize(width: 0, height: 1)
            label.shadowColor = UIColor.black
            label.numberOfLines = 0
            
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.white
            
            return label
        }
        
        infoLabel = createInfoLabel()
        infoView.addSubview(infoLabel)
        
        let top: CGFloat = 20
        let left: CGFloat = 10
        
        let labelV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(top))-[info]", options: [], metrics: nil, views: ["info": infoLabel])
        let labelH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(left))-[info]", options: [], metrics: nil, views: ["info": infoLabel])
        NSLayoutConstraint.activate(labelV)
        NSLayoutConstraint.activate(labelH)
    }
}

public struct AgoraVideoView: UIViewRepresentable {
    var _view : UIView
    public func makeUIView(context: UIViewRepresentableContext<AgoraVideoView>) -> UIView {
        return _view
    }
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AgoraVideoView>) {
    }
    public init(v:UIView){
        _view = v
    }
}
