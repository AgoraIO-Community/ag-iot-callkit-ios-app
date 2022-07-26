//FsmView created by guzhihe@agora.io on 2022/06/04 16:09
import Foundation
protocol IFsmViewListener{
    //srcState:FsmView
    func do_INIT(_ srcState:FsmView.State)
     //srcState:CheckStatus
    func do_NEWUSER(_ srcState:FsmView.State)
     //srcState:CheckStatus
    func do_OLDUSER(_ srcState:FsmView.State)
     //srcState:WelcomeView
    func do_LOGIN(_ srcState:FsmView.State)
     //srcState:WelcomeView
    func do_BINDPHONE(_ srcState:FsmView.State)
     //srcState:WelcomeView
    func do_BINDEMAIL(_ srcState:FsmView.State)
     //srcState:WelcomeView,HomeView
    func do_MAIN(_ srcState:FsmView.State)
     //srcState:HomeView
    func do_RESETDEV(_ srcState:FsmView.State)
     //srcState:HomeView
    func do_WARNING(_ srcState:FsmView.State)
     //srcState:HomeView
    func do_EXIT(_ srcState:FsmView.State)
     //srcState:HomeView
    func do_SYSWARNING(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_LOGINED(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_LOGINBACK(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_FORGETPWD(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_FORGETPWDBYPHONE(_ srcState:FsmView.State)
     //srcState:BindPhoneView,BindEmailView,VerifyPhoneView,VerifyEmailView
    func do_BINDBACK(_ srcState:FsmView.State)
     //srcState:BindPhoneView
    func do_VERIFYPHONE(_ srcState:FsmView.State)
     //srcState:BindEmailView
    func do_VERIFYEMAIL(_ srcState:FsmView.State)
     //srcState:DeviceMainView,WarningView,SysWarningView
    func do_BACK(_ srcState:FsmView.State)
     //srcState:SDStep1View,SDStep2View,SDStep3View,SDStep4View
    func do_SD_CANCEL(_ srcState:FsmView.State)
     //srcState:SDStep1View
    func do_STEP2(_ srcState:FsmView.State)
     //srcState:ResetWithEmailView,ResetWithPhoneView
    func do_BACKTOLOGIN(_ srcState:FsmView.State)
     //srcState:ResetWithEmailView
    func do_RESETBYCODE(_ srcState:FsmView.State)
     //srcState:ResetWithPhoneView
    func do_RESETBYSMS(_ srcState:FsmView.State)
     //srcState:VerifyPhoneView
    func do_REBINDPHONE(_ srcState:FsmView.State)
     //srcState:VerifyPhoneView,VerifyEmailView
    func do_SETPWD(_ srcState:FsmView.State)
     //srcState:VerifyEmailView
    func do_REBINDEMAIL(_ srcState:FsmView.State)
     //srcState:SDStep2View
    func do_STEP3(_ srcState:FsmView.State)
     //srcState:ResetByCodeView
    func do_BACKTORESET(_ srcState:FsmView.State)
     //srcState:ResetByCodeView
    func do_RESETPWDBYCODE(_ srcState:FsmView.State)
     //srcState:ResetBySmsView
    func do_RESETPWDBYSMS(_ srcState:FsmView.State)
     //srcState:SetPasswordView,ResetPwdByCodeView,ResetPwdBySmsView
    func do_SETPWDDONE(_ srcState:FsmView.State)
     //srcState:SetPasswordView
    func do_BACKTOVERIFYEMAIL(_ srcState:FsmView.State)
     //srcState:SetPasswordView
    func do_BACKTOVERIFYPHONE(_ srcState:FsmView.State)
     //srcState:SDStep3View
    func do_STEP4(_ srcState:FsmView.State)
     //srcState:ResetPwdByCodeView
    func do_BACKTORESETCODE(_ srcState:FsmView.State)
     //srcState:ResetPwdBySmsView
    func do_BACKTORESETSMS(_ srcState:FsmView.State)
     //srcState:SDStep4View
    func do_SD_TIMEOUT(_ srcState:FsmView.State)
     //srcState:SDStep4View
    func do_SD_FAILED(_ srcState:FsmView.State)
     //srcState:SDStep4View
    func do_SD_SUCCED(_ srcState:FsmView.State)
     //srcState:SDTimeoutView,SDFailureView
    func do_SD_CLOSE(_ srcState:FsmView.State)
     //srcState:SDTimeoutView
    func do_STEP1(_ srcState:FsmView.State)
     //srcState:SDSuccessView
    func do_SD_RETURN(_ srcState:FsmView.State)
     //srcEvent:CHECK
    func on_CheckStatus(_ srcEvent:FsmView.Event)
 };
class FsmView : Fsm {
    typealias IListener = IFsmViewListener
    enum State : Int{
        case FsmView        
        case SplashView     
        case CheckStatus    
        case WelcomeView    
        case HomeView       
        case LoginView      
        case BindPhoneView  
        case BindEmailView  
        case DeviceMainView 
        case SDStep1View    
        case WarningView    
        case SysWarningView 
        case ResetWithEmailView
        case ResetWithPhoneView
        case VerifyPhoneView
        case VerifyEmailView
        case SDStep2View    
        case ResetByCodeView
        case ResetBySmsView 
        case SetPasswordView
        case SDStep3View    
        case ResetPwdByCodeView
        case ResetPwdBySmsView
        case SDStep4View    
        case SDTimeoutView  
        case SDFailureView  
        case SDSuccessView  
        case SCount         
    };

    enum Event : Int{
        case INIT           
        case CHECK          
        case NEWUSER        
        case OLDUSER        
        case LOGIN          
        case BINDPHONE      
        case BINDEMAIL      
        case MAIN           
        case RESETDEV       
        case WARNING        
        case EXIT           
        case SYSWARNING     
        case LOGINED        
        case LOGINBACK      
        case FORGETPWD      
        case FORGETPWDBYPHONE
        case BINDBACK       
        case VERIFYPHONE    
        case VERIFYEMAIL    
        case BACK           
        case SD_CANCEL      
        case STEP2          
        case BACKTOLOGIN    
        case RESETBYCODE    
        case RESETBYSMS     
        case REBINDPHONE    
        case SETPWD         
        case REBINDEMAIL    
        case STEP3          
        case BACKTORESET    
        case RESETPWDBYCODE 
        case RESETPWDBYSMS  
        case BACKTOPHONE    
        case SETPWDDONE     
        case BACKTOVERIFYEMAIL
        case BACKTOVERIFYPHONE
        case STEP4          
        case BACKTORESETCODE
        case BACKTORESETSMS 
        case SD_TIMEOUT     
        case SD_FAILED      
        case SD_SUCCED      
        case SD_CLOSE       
        case STEP1          
        case SD_RETURN      
        case ECount         
    };

    let s_State:[String] = [
        "FsmView",
        "SplashView",
        "CheckStatus",
        "WelcomeView",
        "HomeView",
        "LoginView",
        "BindPhoneView",
        "BindEmailView",
        "DeviceMainView",
        "SDStep1View",
        "WarningView",
        "SysWarningView",
        "ResetWithEmailView",
        "ResetWithPhoneView",
        "VerifyPhoneView",
        "VerifyEmailView",
        "SDStep2View",
        "ResetByCodeView",
        "ResetBySmsView",
        "SetPasswordView",
        "SDStep3View",
        "ResetPwdByCodeView",
        "ResetPwdBySmsView",
        "SDStep4View",
        "SDTimeoutView",
        "SDFailureView",
        "SDSuccessView",
        "*"
    ];

    let s_Event:[String] = [
        "INIT",
        "CHECK",
        "NEWUSER",
        "OLDUSER",
        "LOGIN",
        "BINDPHONE",
        "BINDEMAIL",
        "MAIN",
        "RESETDEV",
        "WARNING",
        "EXIT",
        "SYSWARNING",
        "LOGINED",
        "LOGINBACK",
        "FORGETPWD",
        "FORGETPWDBYPHONE",
        "BINDBACK",
        "VERIFYPHONE",
        "VERIFYEMAIL",
        "BACK",
        "SD_CANCEL",
        "STEP2",
        "BACKTOLOGIN",
        "RESETBYCODE",
        "RESETBYSMS",
        "REBINDPHONE",
        "SETPWD",
        "REBINDEMAIL",
        "STEP3",
        "BACKTORESET",
        "RESETPWDBYCODE",
        "RESETPWDBYSMS",
        "BACKTOPHONE",
        "SETPWDDONE",
        "BACKTOVERIFYEMAIL",
        "BACKTOVERIFYPHONE",
        "STEP4",
        "BACKTORESETCODE",
        "BACKTORESETSMS",
        "SD_TIMEOUT",
        "SD_FAILED",
        "SD_SUCCED",
        "SD_CLOSE",
        "STEP1",
        "SD_RETURN",
        "*"
    ];

    var FsmView_P0_FsmView:[Node] = Fsm.None
    var FsmView_P1_SplashView:[Node] = Fsm.None
    var FsmView_P2_CheckStatus:[Node] = Fsm.None
    var FsmView_P3_WelcomeView:[Node] = Fsm.None
    var FsmView_P4_HomeView:[Node] = Fsm.None
    var FsmView_P5_LoginView:[Node] = Fsm.None
    var FsmView_P6_BindPhoneView:[Node] = Fsm.None
    var FsmView_P7_BindEmailView:[Node] = Fsm.None
    var FsmView_P8_DeviceMainView:[Node] = Fsm.None
    var FsmView_P9_SDStep1View:[Node] = Fsm.None
    var FsmView_P10_WarningView:[Node] = Fsm.None
    var FsmView_P11_SysWarningView:[Node] = Fsm.None
    var FsmView_P12_ResetWithEmailView:[Node] = Fsm.None
    var FsmView_P13_ResetWithPhoneView:[Node] = Fsm.None
    var FsmView_P14_VerifyPhoneView:[Node] = Fsm.None
    var FsmView_P15_VerifyEmailView:[Node] = Fsm.None
    var FsmView_P16_SDStep2View:[Node] = Fsm.None
    var FsmView_P17_ResetByCodeView:[Node] = Fsm.None
    var FsmView_P18_ResetBySmsView:[Node] = Fsm.None
    var FsmView_P19_SetPasswordView:[Node] = Fsm.None
    var FsmView_P20_SDStep3View:[Node] = Fsm.None
    var FsmView_P21_ResetPwdByCodeView:[Node] = Fsm.None
    var FsmView_P22_ResetPwdBySmsView:[Node] = Fsm.None
    var FsmView_P23_SDStep4View:[Node] = Fsm.None
    var FsmView_P24_SDTimeoutView:[Node] = Fsm.None
    var FsmView_P25_SDFailureView:[Node] = Fsm.None
    var FsmView_P26_SDSuccessView:[Node] = Fsm.None


    var _listener : IFsmViewListener? = nil
    var _diagram : [[Node]] = Fsm.Nones

    var listener:IListener?{set{_listener = newValue}get{return _listener}}


    override init(_ onPost:@escaping Fsm.PostFun){
        super.init(onPost)
        FsmView_P0_FsmView = [
            Node(Fsm.FLAG_RUN,Event.INIT.rawValue,State.SplashView.rawValue,{(s:Int)->Void in self._listener?.do_INIT(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P1_SplashView = [
            Node(Fsm.FLAG_NONE,Event.CHECK.rawValue,State.CheckStatus.rawValue,nil,{(e:Int)->Void in self._listener?.on_CheckStatus(Event(rawValue:e)!)}),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P2_CheckStatus = [
            Node(Fsm.FLAG_NONE,Event.NEWUSER.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_NEWUSER(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.OLDUSER.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_OLDUSER(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P3_WelcomeView = [
            Node(Fsm.FLAG_NONE,Event.LOGIN.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_LOGIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BINDPHONE.rawValue,State.BindPhoneView.rawValue,{(s:Int)->Void in self._listener?.do_BINDPHONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BINDEMAIL.rawValue,State.BindEmailView.rawValue,{(s:Int)->Void in self._listener?.do_BINDEMAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.MAIN.rawValue,State.DeviceMainView.rawValue,{(s:Int)->Void in self._listener?.do_MAIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P4_HomeView = [
            Node(Fsm.FLAG_NONE,Event.RESETDEV.rawValue,State.SDStep1View.rawValue,{(s:Int)->Void in self._listener?.do_RESETDEV(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.MAIN.rawValue,State.DeviceMainView.rawValue,{(s:Int)->Void in self._listener?.do_MAIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.WARNING.rawValue,State.WarningView.rawValue,{(s:Int)->Void in self._listener?.do_WARNING(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.EXIT.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_EXIT(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SYSWARNING.rawValue,State.SysWarningView.rawValue,{(s:Int)->Void in self._listener?.do_SYSWARNING(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P5_LoginView = [
            Node(Fsm.FLAG_NONE,Event.LOGINED.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_LOGINED(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.LOGINBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_LOGINBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.FORGETPWD.rawValue,State.ResetWithEmailView.rawValue,{(s:Int)->Void in self._listener?.do_FORGETPWD(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.FORGETPWDBYPHONE.rawValue,State.ResetWithPhoneView.rawValue,{(s:Int)->Void in self._listener?.do_FORGETPWDBYPHONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P6_BindPhoneView = [
            Node(Fsm.FLAG_NONE,Event.BINDBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_BINDBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.VERIFYPHONE.rawValue,State.VerifyPhoneView.rawValue,{(s:Int)->Void in self._listener?.do_VERIFYPHONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P7_BindEmailView = [
            Node(Fsm.FLAG_NONE,Event.BINDBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_BINDBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.VERIFYEMAIL.rawValue,State.VerifyEmailView.rawValue,{(s:Int)->Void in self._listener?.do_VERIFYEMAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P8_DeviceMainView = [
            Node(Fsm.FLAG_NONE,Event.BACK.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_BACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P9_SDStep1View = [
            Node(Fsm.FLAG_NONE,Event.SD_CANCEL.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CANCEL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.STEP2.rawValue,State.SDStep2View.rawValue,{(s:Int)->Void in self._listener?.do_STEP2(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P10_WarningView = [
            Node(Fsm.FLAG_NONE,Event.BACK.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_BACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P11_SysWarningView = [
            Node(Fsm.FLAG_NONE,Event.BACK.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_BACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P12_ResetWithEmailView = [
            Node(Fsm.FLAG_NONE,Event.BACKTOLOGIN.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTOLOGIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.RESETBYCODE.rawValue,State.ResetByCodeView.rawValue,{(s:Int)->Void in self._listener?.do_RESETBYCODE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P13_ResetWithPhoneView = [
            Node(Fsm.FLAG_NONE,Event.RESETBYSMS.rawValue,State.ResetBySmsView.rawValue,{(s:Int)->Void in self._listener?.do_RESETBYSMS(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BACKTOLOGIN.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTOLOGIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P14_VerifyPhoneView = [
            Node(Fsm.FLAG_NONE,Event.REBINDPHONE.rawValue,State.BindPhoneView.rawValue,{(s:Int)->Void in self._listener?.do_REBINDPHONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BINDBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_BINDBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SETPWD.rawValue,State.SetPasswordView.rawValue,{(s:Int)->Void in self._listener?.do_SETPWD(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P15_VerifyEmailView = [
            Node(Fsm.FLAG_NONE,Event.BINDBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_BINDBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SETPWD.rawValue,State.SetPasswordView.rawValue,{(s:Int)->Void in self._listener?.do_SETPWD(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.REBINDEMAIL.rawValue,State.BindEmailView.rawValue,{(s:Int)->Void in self._listener?.do_REBINDEMAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P16_SDStep2View = [
            Node(Fsm.FLAG_NONE,Event.SD_CANCEL.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CANCEL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.STEP3.rawValue,State.SDStep3View.rawValue,{(s:Int)->Void in self._listener?.do_STEP3(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P17_ResetByCodeView = [
            Node(Fsm.FLAG_NONE,Event.BACKTORESET.rawValue,State.ResetWithEmailView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTORESET(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.RESETPWDBYCODE.rawValue,State.ResetPwdByCodeView.rawValue,{(s:Int)->Void in self._listener?.do_RESETPWDBYCODE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P18_ResetBySmsView = [
            Node(Fsm.FLAG_NONE,Event.RESETPWDBYSMS.rawValue,State.ResetPwdBySmsView.rawValue,{(s:Int)->Void in self._listener?.do_RESETPWDBYSMS(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BACKTOPHONE.rawValue,State.ResetWithPhoneView.rawValue,nil,nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P19_SetPasswordView = [
            Node(Fsm.FLAG_NONE,Event.SETPWDDONE.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_SETPWDDONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BACKTOVERIFYEMAIL.rawValue,State.VerifyEmailView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTOVERIFYEMAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.BACKTOVERIFYPHONE.rawValue,State.VerifyPhoneView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTOVERIFYPHONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P20_SDStep3View = [
            Node(Fsm.FLAG_NONE,Event.STEP4.rawValue,State.SDStep4View.rawValue,{(s:Int)->Void in self._listener?.do_STEP4(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SD_CANCEL.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CANCEL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P21_ResetPwdByCodeView = [
            Node(Fsm.FLAG_NONE,Event.BACKTORESETCODE.rawValue,State.ResetByCodeView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTORESETCODE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SETPWDDONE.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_SETPWDDONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P22_ResetPwdBySmsView = [
            Node(Fsm.FLAG_NONE,Event.BACKTORESETSMS.rawValue,State.ResetBySmsView.rawValue,{(s:Int)->Void in self._listener?.do_BACKTORESETSMS(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SETPWDDONE.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_SETPWDDONE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P23_SDStep4View = [
            Node(Fsm.FLAG_NONE,Event.SD_CANCEL.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CANCEL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SD_TIMEOUT.rawValue,State.SDTimeoutView.rawValue,{(s:Int)->Void in self._listener?.do_SD_TIMEOUT(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SD_FAILED.rawValue,State.SDFailureView.rawValue,{(s:Int)->Void in self._listener?.do_SD_FAILED(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.SD_SUCCED.rawValue,State.SDSuccessView.rawValue,{(s:Int)->Void in self._listener?.do_SD_SUCCED(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P24_SDTimeoutView = [
            Node(Fsm.FLAG_NONE,Event.SD_CLOSE.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CLOSE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.STEP1.rawValue,State.SDStep1View.rawValue,{(s:Int)->Void in self._listener?.do_STEP1(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P25_SDFailureView = [
            Node(Fsm.FLAG_NONE,Event.SD_CLOSE.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_CLOSE(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P26_SDSuccessView = [
            Node(Fsm.FLAG_NONE,Event.SD_RETURN.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_SD_RETURN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]

        _diagram = [
            FsmView_P0_FsmView, FsmView_P1_SplashView, FsmView_P2_CheckStatus, FsmView_P3_WelcomeView,
            FsmView_P4_HomeView, FsmView_P5_LoginView, FsmView_P6_BindPhoneView, FsmView_P7_BindEmailView,
            FsmView_P8_DeviceMainView, FsmView_P9_SDStep1View, FsmView_P10_WarningView, FsmView_P11_SysWarningView,
            FsmView_P12_ResetWithEmailView, FsmView_P13_ResetWithPhoneView, FsmView_P14_VerifyPhoneView, FsmView_P15_VerifyEmailView,
            FsmView_P16_SDStep2View, FsmView_P17_ResetByCodeView, FsmView_P18_ResetBySmsView, FsmView_P19_SetPasswordView,
            FsmView_P20_SDStep3View, FsmView_P21_ResetPwdByCodeView, FsmView_P22_ResetPwdBySmsView, FsmView_P23_SDStep4View,
            FsmView_P24_SDTimeoutView, FsmView_P25_SDFailureView, FsmView_P26_SDSuccessView]

    }
    //override
    override var events:[String]{get{return s_Event}}
    override var states:[String]{get{return s_State}}
    override var graph:[[Node]]{get{return _diagram}}
    override var count:Int{get{return Event.ECount.rawValue}}
    @discardableResult
    func trans(_ event:Event,_ act:@escaping()->Void={})->Bool{
        return super.trans(event.rawValue,act)
    }
    //trans
    //fsm
};

