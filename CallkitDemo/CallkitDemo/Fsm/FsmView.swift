//FsmView created by guzhihe@agora.io on 2022/07/27 20:04
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
     //srcState:HomeView
    func do_MAIN(_ srcState:FsmView.State)
     //srcState:HomeView
    func do_EXIT(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_LOGINED(_ srcState:FsmView.State)
     //srcState:LoginView
    func do_LOGINBACK(_ srcState:FsmView.State)
     //srcState:DeviceMainView
    func do_BACK(_ srcState:FsmView.State)
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
        case DeviceMainView 
        case SCount         
    };

    enum Event : Int{
        case INIT           
        case CHECK          
        case NEWUSER        
        case OLDUSER        
        case LOGIN          
        case MAIN           
        case EXIT           
        case LOGINED        
        case LOGINBACK      
        case BACK           
        case ECount         
    };

    let s_State:[String] = [
        "FsmView",
        "SplashView",
        "CheckStatus",
        "WelcomeView",
        "HomeView",
        "LoginView",
        "DeviceMainView",
        "*"
    ];

    let s_Event:[String] = [
        "INIT",
        "CHECK",
        "NEWUSER",
        "OLDUSER",
        "LOGIN",
        "MAIN",
        "EXIT",
        "LOGINED",
        "LOGINBACK",
        "BACK",
        "*"
    ];

    var FsmView_P0_FsmView:[Node] = Fsm.None
    var FsmView_P1_SplashView:[Node] = Fsm.None
    var FsmView_P2_CheckStatus:[Node] = Fsm.None
    var FsmView_P3_WelcomeView:[Node] = Fsm.None
    var FsmView_P4_HomeView:[Node] = Fsm.None
    var FsmView_P5_LoginView:[Node] = Fsm.None
    var FsmView_P6_DeviceMainView:[Node] = Fsm.None


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
            Node(Fsm.FLAG_NONE,Event.LOGIN.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_LOGIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P4_HomeView = [
            Node(Fsm.FLAG_NONE,Event.MAIN.rawValue,State.DeviceMainView.rawValue,{(s:Int)->Void in self._listener?.do_MAIN(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.EXIT.rawValue,State.LoginView.rawValue,{(s:Int)->Void in self._listener?.do_EXIT(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P5_LoginView = [
            Node(Fsm.FLAG_NONE,Event.LOGINED.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_LOGINED(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.LOGINBACK.rawValue,State.WelcomeView.rawValue,{(s:Int)->Void in self._listener?.do_LOGINBACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmView_P6_DeviceMainView = [
            Node(Fsm.FLAG_NONE,Event.BACK.rawValue,State.HomeView.rawValue,{(s:Int)->Void in self._listener?.do_BACK(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]

        _diagram = [
            FsmView_P0_FsmView, FsmView_P1_SplashView, FsmView_P2_CheckStatus, FsmView_P3_WelcomeView,
            FsmView_P4_HomeView, FsmView_P5_LoginView, FsmView_P6_DeviceMainView]

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

