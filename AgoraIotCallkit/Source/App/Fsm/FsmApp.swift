//FsmApp created by guzhihe@agora.io on 2022/06/16 12:23
import Foundation
protocol IFsmAppListener{
     //srcEvent:CONFIG
    func on_CfgRunning(_ srcEvent:FsmApp.Event)
     //srcEvent:LOGOUT_DONE
    func on_logout_watcher(_ srcEvent:FsmApp.Event)
 };
class FsmApp : Fsm {
    typealias IListener = IFsmAppListener
    enum State : Int{
        case FsmApp         
        case Idle           
        case CfgInvalid     
        case exit           
        case CfgRunning     
        case CfgReady       
        case Logining       
        case initPush       
        case FsmPush        
        case PushFailed     
        case initCall       
        case finiPush       
        case FsmUi          
        case initMqtt       
        case FsmCall        
        case CallFailed     
        case finiCall       
        case logouted       
        case FsmMqtt        
        case allReady       
        case MqttFailed     
        case finiMqtt       
        case logout_watcher 
        case Running        
        case logouting      
        case SCount         
    };

    enum Event : Int{
        case EXITAPP        
        case INIT           
        case KICKOFF        
        case LOGOUT_SUCC    
        case CONFIG         
        case NEXT           
        case ALL_READY      
        case CFG_SUCC       
        case CFG_FAIL       
        case LOGIN          
        case AUTOLOGIN      
        case MQTTIDLE       
        case LOGIN_FAIL     
        case LOGIN_SUCC     
        case PUSH_ERROR     
        case PUSH_READY     
        case LOGOUT         
        case CALL_READY     
        case CALL_ERROR     
        case PUSHIDLE       
        case MQTT_READY     
        case MQTT_ERROR     
        case CALLIDLE       
        case INIT_FAIL      
        case LOGOUT_CONTINUE
        case LOGOUT_DONE    
        case FINIPUSH       
        case INITMQTT_FAIL  
        case INITCALL_FAIL  
        case INITCALL       
        case INITMQTT       
        case FINIMQTT       
        case INITPUSH_FAIL  
        case FINICALL       
        case INITPUSH       
        case ECount         
    };

    let s_State:[String] = [
        "FsmApp",
        "Idle",
        "CfgInvalid",
        "exit",
        "CfgRunning",
        "CfgReady",
        "Logining",
        "initPush",
        "FsmPush",
        "PushFailed",
        "initCall",
        "finiPush",
        "FsmUi",
        "initMqtt",
        "FsmCall",
        "CallFailed",
        "finiCall",
        "logouted",
        "FsmMqtt",
        "allReady",
        "MqttFailed",
        "finiMqtt",
        "logout_watcher",
        "Running",
        "logouting",
        "*"
    ];

    let s_Event:[String] = [
        "EXITAPP",
        "INIT",
        "KICKOFF",
        "LOGOUT_SUCC",
        "CONFIG",
        "NEXT",
        "ALL_READY",
        "CFG_SUCC",
        "CFG_FAIL",
        "LOGIN",
        "AUTOLOGIN",
        "MQTTIDLE",
        "LOGIN_FAIL",
        "LOGIN_SUCC",
        "PUSH_ERROR",
        "PUSH_READY",
        "LOGOUT",
        "CALL_READY",
        "CALL_ERROR",
        "PUSHIDLE",
        "MQTT_READY",
        "MQTT_ERROR",
        "CALLIDLE",
        "INIT_FAIL",
        "LOGOUT_CONTINUE",
        "LOGOUT_DONE",
        "FINIPUSH",
        "INITMQTT_FAIL",
        "INITCALL_FAIL",
        "INITCALL",
        "INITMQTT",
        "FINIMQTT",
        "INITPUSH_FAIL",
        "FINICALL",
        "INITPUSH",
        "*"
    ];

    var FsmApp_P0_FsmApp:[Node] = Fsm.None
    var FsmApp_P1_Idle:[Node] = Fsm.None
    var FsmApp_P2_CfgInvalid:[Node] = Fsm.None
    var FsmApp_P3_exit:[Node] = Fsm.None
    var FsmApp_P4_CfgRunning:[Node] = Fsm.None
    var FsmApp_P5_CfgReady:[Node] = Fsm.None
    var FsmApp_P6_Logining:[Node] = Fsm.None
    var FsmApp_P7_initPush:[Node] = Fsm.None
    var FsmApp_P8_FsmPush:[Node] = Fsm.None
    var FsmApp_P9_PushFailed:[Node] = Fsm.None
    var FsmApp_P10_initCall:[Node] = Fsm.None
    var FsmApp_P11_finiPush:[Node] = Fsm.None
    var FsmApp_P12_FsmUi:[Node] = Fsm.None
    var FsmApp_P13_initMqtt:[Node] = Fsm.None
    var FsmApp_P14_FsmCall:[Node] = Fsm.None
    var FsmApp_P15_CallFailed:[Node] = Fsm.None
    var FsmApp_P16_finiCall:[Node] = Fsm.None
    var FsmApp_P17_logouted:[Node] = Fsm.None
    var FsmApp_P18_FsmMqtt:[Node] = Fsm.None
    var FsmApp_P19_allReady:[Node] = Fsm.None
    var FsmApp_P20_MqttFailed:[Node] = Fsm.None
    var FsmApp_P21_finiMqtt:[Node] = Fsm.None
    var FsmApp_P22_logout_watcher:[Node] = Fsm.None
    var FsmApp_P23_Running:[Node] = Fsm.None
    var FsmApp_P24_logouting:[Node] = Fsm.None


    var _listener : IFsmAppListener? = nil
    var _diagram : [[Node]] = Fsm.Nones

    var listener:IListener?{set{_listener = newValue}get{return _listener}}


    override init(_ onPost:@escaping Fsm.PostFun){
        super.init(onPost)
        _FsmPush = FsmPush(onPost,self)
        _FsmUi = FsmUi(onPost,self)
        _FsmCall = FsmCall(onPost,self)
        _FsmMqtt = FsmMqtt(onPost,self)
        FsmApp_P0_FsmApp = [
            Node(Fsm.FLAG_RUN,Event.INIT.rawValue,State.Idle.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P1_Idle = [
            Node(Fsm.FLAG_GOON,Event.EXITAPP.rawValue,State.exit.rawValue,nil,nil),
            Node(Fsm.FLAG_RUN,Event.KICKOFF.rawValue,State.CfgInvalid.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.INIT_FAIL.rawValue,State.Idle.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P2_CfgInvalid = [
            Node(Fsm.FLAG_GOON,Event.EXITAPP.rawValue,State.Idle.rawValue,nil,nil),
            Node(Fsm.FLAG_RUN,Event.CONFIG.rawValue,State.CfgRunning.rawValue,nil,{(e:Int)->Void in self._listener?.on_CfgRunning(Event(rawValue:e)!)}),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P3_exit = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P4_CfgRunning = [
            Node(Fsm.FLAG_GOON,Event.EXITAPP.rawValue,State.CfgInvalid.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.CFG_SUCC.rawValue,State.CfgReady.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.CFG_FAIL.rawValue,State.CfgInvalid.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P5_CfgReady = [
            Node(Fsm.FLAG_GOON,Event.EXITAPP.rawValue,State.CfgInvalid.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGIN.rawValue,State.Logining.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.AUTOLOGIN.rawValue,State.Logining.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.MQTTIDLE.rawValue,State.CfgReady.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P6_Logining = [
            Node(Fsm.FLAG_NONE,Event.LOGIN_FAIL.rawValue,State.CfgReady.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGIN_SUCC.rawValue,State.initPush.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P7_initPush = [
            Node(Fsm.FLAG_NONE,Event.PUSH_ERROR.rawValue,State.PushFailed.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.PUSH_READY.rawValue,State.initCall.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiPush.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITPUSH.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmPush_INITPUSH(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P8_FsmPush = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P9_PushFailed = [
            Node(Fsm.FLAG_RUN,Event.NEXT.rawValue,State.initCall.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITPUSH_FAIL.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmUi_INITPUSH_FAIL(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P10_initCall = [
            Node(Fsm.FLAG_NONE,Event.CALL_READY.rawValue,State.initMqtt.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.CALL_ERROR.rawValue,State.CallFailed.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiCall.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITCALL.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmCall_INITCALL(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P11_finiPush = [
            Node(Fsm.FLAG_NONE,Event.PUSHIDLE.rawValue,State.logouted.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.logouted.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.FINIPUSH.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmPush_FINIPUSH(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P12_FsmUi = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P13_initMqtt = [
            Node(Fsm.FLAG_NONE,Event.MQTT_READY.rawValue,State.allReady.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.MQTT_ERROR.rawValue,State.MqttFailed.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiMqtt.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITMQTT.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmMqtt_INITMQTT(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P14_FsmCall = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P15_CallFailed = [
            Node(Fsm.FLAG_RUN,Event.NEXT.rawValue,State.initMqtt.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITCALL_FAIL.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmUi_INITCALL_FAIL(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P16_finiCall = [
            Node(Fsm.FLAG_NONE,Event.CALLIDLE.rawValue,State.finiPush.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiPush.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.FINICALL.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmCall_FINICALL(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P17_logouted = [
            Node(Fsm.FLAG_RUN,Event.LOGOUT_SUCC.rawValue,State.CfgReady.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.LOGOUT_DONE.rawValue,State.logout_watcher.rawValue,nil,{(e:Int)->Void in self._listener?.on_logout_watcher(Event(rawValue:e)!)}),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P18_FsmMqtt = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P19_allReady = [
            Node(Fsm.FLAG_RUN,Event.ALL_READY.rawValue,State.Running.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P20_MqttFailed = [
            Node(Fsm.FLAG_RUN,Event.NEXT.rawValue,State.allReady.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.INITMQTT_FAIL.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmUi_INITMQTT_FAIL(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P21_finiMqtt = [
            Node(Fsm.FLAG_NONE,Event.MQTTIDLE.rawValue,State.finiCall.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiCall.rawValue,nil,nil),
            Node(Fsm.FLAG_POST,Event.FINIMQTT.rawValue,State.SCount.rawValue,{(e:Int)->Void in self.do_FsmMqtt_FINIMQTT(Event(rawValue:e)!)},nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P22_logout_watcher = [
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P23_Running = [
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.logouting.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmApp_P24_logouting = [
            Node(Fsm.FLAG_NONE,Event.LOGOUT_CONTINUE.rawValue,State.finiMqtt.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE,Event.LOGOUT.rawValue,State.finiMqtt.rawValue,nil,nil),
            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]

        _diagram = [
            FsmApp_P0_FsmApp, FsmApp_P1_Idle, FsmApp_P2_CfgInvalid, FsmApp_P3_exit,
            FsmApp_P4_CfgRunning, FsmApp_P5_CfgReady, FsmApp_P6_Logining, FsmApp_P7_initPush,
            FsmApp_P8_FsmPush, FsmApp_P9_PushFailed, FsmApp_P10_initCall, FsmApp_P11_finiPush,
            FsmApp_P12_FsmUi, FsmApp_P13_initMqtt, FsmApp_P14_FsmCall, FsmApp_P15_CallFailed,
            FsmApp_P16_finiCall, FsmApp_P17_logouted, FsmApp_P18_FsmMqtt, FsmApp_P19_allReady,
            FsmApp_P20_MqttFailed, FsmApp_P21_finiMqtt, FsmApp_P22_logout_watcher, FsmApp_P23_Running,
            FsmApp_P24_logouting]

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
    private func do_FsmPush_FINIPUSH(_ e:Event)->Void{_FsmPush?.trans(FsmPush.Event.FINIPUSH.rawValue)}
    private func do_FsmUi_INITMQTT_FAIL(_ e:Event)->Void{_FsmUi?.trans(FsmUi.Event.INITMQTT_FAIL.rawValue)}
    private func do_FsmUi_INITCALL_FAIL(_ e:Event)->Void{_FsmUi?.trans(FsmUi.Event.INITCALL_FAIL.rawValue)}
    private func do_FsmCall_INITCALL(_ e:Event)->Void{_FsmCall?.trans(FsmCall.Event.INITCALL.rawValue)}
    private func do_FsmMqtt_INITMQTT(_ e:Event)->Void{_FsmMqtt?.trans(FsmMqtt.Event.INITMQTT.rawValue)}
    private func do_FsmMqtt_FINIMQTT(_ e:Event)->Void{_FsmMqtt?.trans(FsmMqtt.Event.FINIMQTT.rawValue)}
    private func do_FsmUi_INITPUSH_FAIL(_ e:Event)->Void{_FsmUi?.trans(FsmUi.Event.INITPUSH_FAIL.rawValue)}
    private func do_FsmCall_FINICALL(_ e:Event)->Void{_FsmCall?.trans(FsmCall.Event.FINICALL.rawValue)}
    private func do_FsmPush_INITPUSH(_ e:Event)->Void{_FsmPush?.trans(FsmPush.Event.INITPUSH.rawValue)}
    //fsm
    //sub state get set
    func getFsmPush()->FsmPush{return _FsmPush!}
    func getFsmUi()->FsmUi{return _FsmUi!}
    func getFsmCall()->FsmCall{return _FsmCall!}
    func getFsmMqtt()->FsmMqtt{return _FsmMqtt!}
    //sub state
    private var _FsmPush:FsmPush? = nil
    private var _FsmUi:FsmUi? = nil
    private var _FsmCall:FsmCall? = nil
    private var _FsmMqtt:FsmMqtt? = nil
};

