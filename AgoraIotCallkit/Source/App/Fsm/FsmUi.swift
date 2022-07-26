//FsmUi created by guzhihe@agora.io on 2022/06/16 12:23
import Foundation
protocol IFsmUiListener{
    //srcState:idle
    func do_INITPUSH_FAIL(_ srcState:FsmUi.State)
     //srcState:idle
    func do_INITCALL_FAIL(_ srcState:FsmUi.State)
     //srcState:idle
    func do_INITMQTT_FAIL(_ srcState:FsmUi.State)
 };
class FsmUi : Fsm {
    typealias IListener = IFsmUiListener
    enum State : Int{
        case FsmUi          
        case idle           
        case SCount         
    };

    enum Event : Int{
        case INIT           
        case INITPUSH_FAIL  
        case INITCALL_FAIL  
        case INITMQTT_FAIL  
        case ECount         
    };

    let s_State:[String] = [
        "FsmUi",
        "idle",
        "*"
    ];

    let s_Event:[String] = [
        "INIT",
        "INITPUSH_FAIL",
        "INITCALL_FAIL",
        "INITMQTT_FAIL",
        "*"
    ];

    var FsmUi_P0_FsmUi:[Node] = Fsm.None
    var FsmUi_P1_idle:[Node] = Fsm.None


    var _listener : IFsmUiListener? = nil
    var _diagram : [[Node]] = Fsm.Nones

    var listener:IListener?{set{_listener = newValue}get{return _listener}}


    init(_ onPost:@escaping Fsm.PostFun,_ _FsmApp:FsmApp){
        super.init(onPost)
        FsmUi_P0_FsmUi = [
            Node(Fsm.FLAG_RUN,Event.INIT.rawValue,State.idle.rawValue,nil,nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]
        FsmUi_P1_idle = [
            Node(Fsm.FLAG_NONE,Event.INITPUSH_FAIL.rawValue,State.idle.rawValue,{(s:Int)->Void in self._listener?.do_INITPUSH_FAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.INITCALL_FAIL.rawValue,State.idle.rawValue,{(s:Int)->Void in self._listener?.do_INITCALL_FAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE,Event.INITMQTT_FAIL.rawValue,State.idle.rawValue,{(s:Int)->Void in self._listener?.do_INITMQTT_FAIL(State(rawValue:s)!)},nil),            Node(Fsm.FLAG_NONE, Event.ECount.rawValue,State.SCount.rawValue,nil,nil)]

        _diagram = [
            FsmUi_P0_FsmUi, FsmUi_P1_idle]

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

