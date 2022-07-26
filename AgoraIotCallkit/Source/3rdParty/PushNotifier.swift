//
//  Notifier.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/2/16.
//

import Foundation
import EMPush

//let IS_IOS7_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//let IS_IOS8_OR_LATER = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//let IS_IOS10_OR_LATER = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


class PushNotifier : NSObject, UIApplicationDelegate{
    var cfg:Config
    var registered:Bool = false
    
    private var state:Int = PushNotifier.NULLED

    
    static private let NULLED = 0
    static private let CREATED = 1
    static private let ENTERED = 2
    
    init(cfg:Config){
        self.cfg = cfg
        self.state = PushNotifier.NULLED
    }
    func create(completion:@escaping(Bool,String)->Void){
        if(state != PushNotifier.NULLED){
            log.e("ntf state : \(state) error for create()")
            completion(false,"推送模块状态不正确")
            return
        }
        log.i("ntf try to create EMClient Ver\(EMPushVersionNumber)...")

//        let options:EMOptions = EMOptions(appkey: cfg.ntfAppKey)
//        options.enableConsoleLog = true
//        options.apnsCertName = cfg.ntfApnsCertName
//        options.logLevel = EMLogLevelWarning
        let options:EMPushClientOptions = EMPushClientOptions(appkey: cfg.ntfAppKey)
        options.enableConsoleLog = cfg.ntfEnableConsoleLog
        if(cfg.ntfLogLevel == 0){
            options.logLevel = EMPushClientLogLevelDebug
        }
        else if(cfg.ntfLogLevel == 1){
            options.logLevel = EMPushClientLogLevelWarning
        }
        else {
            options.logLevel = EMPushClientLogLevelError
        }
        options.apnsCertName = cfg.ntfApnsCertName
        
        log.i("ntf option \(options)")
        EMPushClient.initializeSDK(with: options, delegate: self, completion: { eid, err in
            if(err != nil){
                log.e("ntf initialize failed:\(String(describing: err!.errorDescription))")
                completion(false,"")
            }
            else{
                self.state = PushNotifier.CREATED
                if let eid = eid {
                    let ret = self.registerNotification()
                    log.i("ntf inititalize succ: eid:'\(eid)'")
                    completion(ret,eid)
                }
                else{
                    log.e("EMPushClient eid is nil")
                    completion(false,"")
                }
            }
        })
//        let ret = EMClient.shared().initializeSDK(with: options)
//        if(ret != nil){
//            log.e("ntf initialize failed:\(String(describing: ret!.errorDescription))")
//            return false
//        }
//
//        EMClient.shared().add(self, delegateQueue: nil)
//        EMClient.shared().chatManager.add(self, delegateQueue: nil)
//        EMClient.shared().pushManager.update(EMPushDisplayStyleSimpleBanner)
        
        //log.i("ntf create done")
        return
    }
    
//    func getLoginUid()->UInt?{
//        if(!EMClient.shared().isLoggedIn){
//            log.w("ntf IM did not login,please login first")
//            return nil
//        }
//        let userName = EMClient.shared().currentUsername
//        guard let userName = userName else {
//            log.e("ntf user logged in,but name is nil")
//            return nil
//        }
//        let uid = UInt(userName)
//        return uid
//    }
    
    func destroy(){
        log.i("ntf is destroying")
        if(state != PushNotifier.CREATED){
            log.e("ntf state:\(state) error for destroy()")
        }
        //var dele:EMClientDelegate! = self
        //EMClient.shared().removeDelegate(dele)
        //EMClient.shared().chatManager.remove(self)
        //EMPushClient.remov
        //EMPushClient.finalize()
        state = PushNotifier.NULLED
    }
    
    func registerNotification()->Bool{
        NotificationCenter.default.addObserver(self,selector: #selector(enterForeGround),name:UIApplication.willEnterForegroundNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(enterBackGround),name:UIApplication.didEnterBackgroundNotification,object: nil)
        
        let app = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            //UNUserNotificationCenter.current().delegate = self
            center.getNotificationSettings { (setting) in
                if setting.authorizationStatus == .notDetermined {
                    center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                        if(result){
                            if !(error != nil){
                                log.i("ntf requestAuthorization succ")
                                DispatchQueue.main.async {
                                    app.registerForRemoteNotifications()
                                    self.registered = true
                                }
                            }
                        } else{
                            log.w("ntf requestAuthorization fail: user not allowed")
                        }
                    }
                } else if (setting.authorizationStatus == .denied){
                    log.w("ntf requestAuthorization fail: user denied")
                } else if (setting.authorizationStatus == .authorized){
                    log.i("ntf requestAuthorization done authorized")
                    DispatchQueue.main.async {
                        app.registerForRemoteNotifications()
                        self.registered = true

                    }
                } else {
                    log.w("ntf requestAuthorization: \(setting.authorizationStatus)")
                }
            }
        }
        else{
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            app.registerUserNotificationSettings(settings)
            registered = true
        }
        return true
    }
    
    func unregisterNotification(){
        NotificationCenter.default.removeObserver(#selector(enterForeGround))
        NotificationCenter.default.removeObserver(#selector(enterBackGround))
        UNUserNotificationCenter.current().delegate = nil
        let app = UIApplication.shared
        if(registered){
            if #available(iOS 10.0, *) {
                app.unregisterForRemoteNotifications()
                
            }
            else{
                let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [], categories: nil)
                app.registerUserNotificationSettings(settings)
            }
            registered = false
        }
    }
    
    @objc func handlePushChat(aNotif:NSNotification)->Void{
        log.i("ntf handlePushChatController")
    }
    
    @objc func enterForeGround(aNotif:NSNotification)->Void{
        log.d("ntf enterForeGround")
        let app = UIApplication.shared
        //EMClient.shared().applicationWillEnterForeground(app)
        EMPushClient.applicationDidEnterBackground(app)
    }
    
    @objc func enterBackGround(aNotif:NSNotification)->Void{
        log.d("ntf enterBackGround")
        let app = UIApplication.shared
        EMPushClient.applicationDidEnterBackground(app)
    }
    
    func updateToken(_ deviceToken:Data){
        log.d("ntf updateToken")
        
        let err:EMError? = EMPushClient.bindDeviceToken(deviceToken)
        guard let e = err else{return}
        log.e("ntf bindDeviceToken Fail : \(String(describing: e.errorDescription))")
    }
    
//    func login(userName:String,password:String,cb:@escaping (Bool)->Void){
//        if(state != PushNotifier.CREATED){
//            log.e("ntf state : \(state) error for login()")
//            cb(false)
//            return
//        }
//        if(EMClient.shared().isAutoLogin){
//            EMClient.shared().pushManager.update(EMPushDisplayStyleSimpleBanner)
//            let ret = registerNotification()
//            state = PushNotifier.ENTERED
//            cb(ret)
//            return
//        }
//        EMClient.shared().login(withUsername: userName, password: password) { desc, er in
//            log.i("ntf login result for user : '\(userName)' desc :'\(String(describing: desc == nil ? desc : desc!.description))' reason:\(String(describing: er?.errorDescription))(\(String(describing: er?.code))")
//
//            if(er?.code == EMErrorUserAlreadyLoginSame){
//
//                let ret = self.registerNotification()
//                self.state = PushNotifier.ENTERED
//                cb(ret)
//            }
//            else{
//                if(er != nil){
//                    log.e("ntf notifier user \(userName) login failed,ec:\(er!.code.rawValue)")
//                    cb(er?.code.rawValue == 0 ? true : false)
//                }
//                else{
//                    let ret = self.registerNotification()
//                    self.state = PushNotifier.ENTERED
//                    cb(ret)
//                }
//            }
//        }
//    }
    
    func createAndLogin(appKey:String,cb:@escaping (Bool,String)->Void){
//        if(!create(appKey: appKey)){
//            log.w("ntf create client error when createAndLogin")
//            cb(false)
//            return
//        }
        //login(userName: userName, password: password, cb: cb)
        create(completion: cb)
    }
    
    func logoutAndDestroy(cb:@escaping (Bool)->Void){
        if(state == PushNotifier.ENTERED){
            let cbLeave = {(b:Bool) in
                if(!b){
                    log.w("rtc leave channel error when leaveAndDestroy")
                }
                self.destroy()
                cb(b)
            }
            logout(cb:cbLeave)
        }
        else if(state == PushNotifier.CREATED){
            destroy()
            cb(true)
        }
        else{
            cb(true)
        }
    }
    
    func logout(cb:@escaping (Bool)->Void){
        if(state != PushNotifier.ENTERED){
            log.e("ntf state : \(state) error for logout()")
            cb(false)
            return
        }
        log.i("ntf logout")
        unregisterNotification()
        
        let err:EMError? = EMClient.shared().unBindPushKitToken()
        if(err != nil){
            log.e("ntf unBindPushKitToken Fail : \(String(describing: err))")
        }
        
        EMClient.shared().logout(true, completion: {
            er in
            if(er != nil){
                log.e("ntf logout failed,ec:\(er!.code.rawValue)")
            }
            self.state = PushNotifier.CREATED
            cb(er != nil ? false : true)
        })
    }
}

//extension PushNotifier : UNUserNotificationCenterDelegate{
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        log.i("ntf willPresent")
//        let userInfo = notification.request.content.userInfo
//        if let trigger = notification.request.trigger{
//            if(trigger.isKind(of: UNPushNotificationTrigger.self)){
//                log.i("apns userinfo:\(userInfo)")
//            }
//            else{
//                let ext = userInfo["ext"]
//                log.i("local usernifo:\(userInfo) ext:\(ext)")
//            }
//        }
//        completionHandler([.alert,.sound,.badge])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        log.i("ntf didReceive")
//        let userInfo = response.notification.request.content.userInfo
//        if let trigger = response.notification.request.trigger{
//            if(trigger.isKind(of: UNPushNotificationTrigger.self)){
//                log.i("apns userinfo:\(userInfo)")
//            }
//            else{
//                let ext = userInfo["ext"]
//                log.i("local usernifo:\(userInfo) ext:\(String(describing: ext))")
//            }
//        }
//        completionHandler()
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
//        log.i("ntf openSettingFor")
//    }
//}
                                   
extension PushNotifier : EMLocalNotificationDelegate{
    func emuserNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        log.i("ntf openSettingFor")
    }
    func emuserNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log.i("ntf willPresent")
        let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger{
            if(trigger.isKind(of: UNPushNotificationTrigger.self)){
                log.i("ntf apns userinfo:\(userInfo)")
            }
            else{
                let ext = userInfo["ext"]
                log.i("ntf local usernifo:\(userInfo) ext:\(ext)")
            }
        }
        completionHandler([.alert,.sound,.badge])
    }
    func emuserNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        log.i("ntf didReceive")
        let userInfo = response.notification.request.content.userInfo
        if let trigger = response.notification.request.trigger{
            if(trigger.isKind(of: UNPushNotificationTrigger.self)){
                log.i("ntf apns userinfo:\(userInfo)")
            }
            else{
                let ext = userInfo["ext"]
                log.i("ntf local usernifo:\(userInfo) ext:\(String(describing: ext))")
            }
        }
        completionHandler()
    }
    func emGetNotificationMessage(_ notification: UNNotification, state: EMNotificationState) {
        log.i("ntf recv notify message:state:\(state)")
        let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger{
            if(trigger.isKind(of: UNPushNotificationTrigger.self)){
                log.i("ntf apns userinfo:\(userInfo)")
                let ext = userInfo["ext"]
                log.i("ntf local usernifo:\(userInfo) ext:\(String(describing: ext))")
            }
            else{
                let ext = userInfo["ext"]
                log.i("local usernifo:\(userInfo) ext:\(String(describing: ext))")
            }
        }
        
        if(state == EMDidReceiveNotificationResponse){
            
        }
        else{
            
        }
    }
    func emDidRecivePushSilentMessage(_ messageDic: [AnyHashable : Any]) {
        log.i("ntf recv silent message")
    }
}

extension PushNotifier :EMClientDelegate{
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        log.i("ntf connectionStateDidChange(\(aConnectionState))")
    }
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        log.i("ntf autoLoginDidCompleteWithError(\(String(describing: aError)))")
    }
    func userAccountDidLoginFromOtherDevice() {
        log.i("ntf userAccountDidLoginFromOtherDevice()")
    }
    func userAccountDidRemoveFromServer(){
        log.i("ntf userAccountDidRemoveFromServer()")
    }
    func userDidForbidByServer() {
        log.i("ntf userDidForbidByServer()")
    }
    func userAccountDidForced(toLogout aError: EMError!) {
        log.i("ntf userAccountDidForcedToLogout(\(String(describing: aError))")
    }
}

//extension PushNotifier : EMChatManagerDelegate{
//    func messagesDidReceive(_ aMessages: [Any]!) {
//        log.i("ntf  messagesDidReceive(count:\(aMessages.count))")
//        let msgs:[EMMessage] = aMessages as! [EMMessage]
//        for msg in msgs{
//            if(msg.body.type == EMMessageBodyTypeText){
//                let textBody = msg.body as! EMTextMessageBody
//                let text = textBody.text
//                log.i("ntf msg body:\(String(describing: text))")
//            }
//        }
//    }
//    func cmdMessagesDidReceive(_ aCmdMessages: [Any]!) {
//        log.i("ntf cmdMessagesDidReceive()")
//    }
//    func messagesDidRead(_ aMessages: [Any]!) {
//        log.i("ntf messagesDidRead()")
//    }
//    func groupMessageDidRead(_ aMessage: EMMessage!, groupAcks aGroupAcks: [Any]!) {
//        log.i("ntf groupMessageDidRead()")
//    }
//    func groupMessageAckHasChanged() {
//        log.i("ntf groupMessageAckHasChanged()")
//    }
//    func onConversationRead(_ from: String!, to: String!) {
//        log.i("ntf onConversationRead()")
//    }
//    func didReceiveHasReadAcks(_ aMessages: [Any]!) {
//        log.i("ntf didReceiveHasReadAcks()")
//    }
//    func messagesDidRecall(_ aMessages: [Any]!) {
//        log.i("ntf messagesDidRecall()")
//    }
//    func messagesDidDeliver(_ aMessages: [Any]!) {
//        log.i("ntf messagesDidDeliver()")
//    }
//    func messageStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
//        log.i("ntf messageStatusDidChange()")
//    }
//    func messageAttachmentStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
//        log.i("ntf messageAttachmentStatusDidChange()")
//    }
//    func conversationListDidUpdate(_ aConversationList: [Any]!) {
//        log.i("ntf conversationListDidUpdate()")
//    }
//}
