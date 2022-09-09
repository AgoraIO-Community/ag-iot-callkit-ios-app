//
//  AgoraLab.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/3/14.
//

import Foundation
import CoreAudio
import Alamofire

extension Date{
    public func toString()->String{
        return String.init(format: "%d-%02d-%02d %02d:%02d:%02d", self.year,self.month,self.day,self.hour,self.minute,self.second)
    }
}

class AgoraLab {
    private var http:String
    private var awsurl:String
    init(http:String,awsurl:String){
        self.http = http
        self.awsurl = awsurl
    }
    
    func reqCall(_ token:String, _ reqPayload:Call.Payload,_ traceId:String, _ rsp:@escaping (Int,String,Call.Rsp?)->Void){
        let header = Header(traceId: traceId)
        let req = Call.Req(header: header, payload: reqPayload)
        let headers : HTTPHeaders = ["Authorization":token]
        let url = http + api.call
        log.i("al reqCall \(req)")
        AF.request(url,method: .post,parameters: req,encoder: JSONParameterEncoder.default,headers: headers)
            .validate()
            .responseDecodable(of:Call.Rsp.self){(dataRsp:AFDataResponse<Call.Rsp>) in
                switch dataRsp.result{
                case .success(let ret):
                    log.i("al reqCall rsp:'\(ret.msg)(\(ret.code))'")
                    if(ret.code == AgoraLab.tokenExpiredCode){
                        rsp(ErrCode.XERR_TOKEN_EXPIRED,ret.msg,nil)
                        return
                    }
                    var ec = ErrCode.XERR_CALLKIT_DIAL
                    if(ret.code == 100001){
                        ec = ErrCode.XERR_CALLKIT_PEER_BUSY
                    }
                    rsp(ret.code == 0 ? ErrCode.XOK : ec,"拨打电话收到响应:\(ret.msg)(\(ret.code))",ret)
                case .failure(let error):
                    log.e("al reqCall \(url) failed,detail:\(error) ")
                    rsp(ErrCode.XERR_NETWORK,"拨打电话操作失败",nil)
                }
            }
    }

    func reqAnswer(_ token:String,_ reqPayload:Answer.Payload,_ traceId:String, _ rsp:@escaping (Int,String,Answer.Data?)->Void){
        let header = Header()
        let req = Answer.Req(header: header, payload: reqPayload)
        let act = reqPayload.answer == 0 ? "accept" : "hangup"
        let url = http + api.answer
        log.i("al reqAnswer '\(act)' by local:\(reqPayload.localId) with: callee:\(reqPayload.calleeId) by caller:\(reqPayload.callerId) sess:\(reqPayload.sessionId)")
        let headers : HTTPHeaders = ["Authorization":token]
        AF.request(url,method: .post,parameters: req,encoder: JSONParameterEncoder.default,headers: headers)
            .validate()
            .responseDecodable(of:Answer.Rsp.self){(dataRsp:AFDataResponse<Answer.Rsp>) in
                switch dataRsp.result{
                case .success(let value):
                    log.i("al reqAnswer '\(act)' rsp: '\(value.success)(\(value.code))'")
                    if(value.code == AgoraLab.tokenExpiredCode){
                        rsp(ErrCode.XERR_TOKEN_EXPIRED,value.msg,nil)
                        return
                    }
                    let op = reqPayload.answer == 0 ? "接听电话操作:" : "挂断电话操作:"
                    let ret = value.success ? "成功" : "失败("+String(value.code)+")"
                    if(!value.success){
                        log.e("al reqAnswer fail \(value.msg)(\(value.code))")
                    }
                    rsp(value.success ? ErrCode.XOK : ErrCode.XERR_CALLKIT_ANSWER,  op + ret, value.data)
                case .failure(let error):
                    log.e("al reqAnswer \(url) failed,detail:\(error) ")
                    rsp(ErrCode.XERR_NETWORK,reqPayload.answer == 0 ? "接听电话操作失败" : "挂断电话失败",nil)
                }
            }
    }
    
    func reqRegister(_ userName:String,_ rsp:@escaping(Int,String)->Void){
        let header:HTTPHeaders = ["Content-Type":"application/json;charset=utf-8"]
        let params = ["username":userName]
        let url = http + api.oauthRegister
        
        AF.request(url,method: .post,parameters: params,encoder: JSONParameterEncoder.default,headers: header)
            .validate()
            .responseDecodable(of:Rsp.self){(dataRsp:AFDataResponse<Rsp>) in
            switch dataRsp.result{
            case .success(let ret):
                if(ret.code != 0){
                    log.e("al reqRegister fail \(ret.msg)(\(ret.code))")
                }
                rsp(ret.code == 0 ? ErrCode.XOK : ErrCode.XERR_UNKNOWN,ret.msg)
            case .failure(let error):
                log.e("al reqRegister \(url) fail for \(userName), detail: \(error) ")
                rsp(ErrCode.XERR_NETWORK,error.errorDescription ?? "网络请求失败")
            }
           }
    }
    
//    public func reqSessInventCert(grawinToken:String,_ rsp:@escaping(Int,String,GranWinSession.Cert?)->Void){
//            let headers : HTTPHeaders = ["token":grawinToken]
//            let url = awsurl + api.CerGet
//            AF.request(url,method: .post,headers: headers)
//                .validate()
//                .responseDecodable(of: CertGet.Rsp.self) { (dataRsp : AFDataResponse<CertGet.Rsp>) in
//                    switch dataRsp.result{
//                    case .success(let value):
//                        self.handleRspCert(value, {ec,msg,cert in
//                            DispatchQueue.main.async {
//                                rsp(ec,msg,cert)
//                            }
//                        })
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            log.e("gw reqSessInventCert \(url) fail detail: \(error) ")
//                            rsp(ErrCode.XERR_NETWORK,error.errorDescription ?? "网络请求失败",nil)
//                        }
//                    }
//            }
//        }
        
//        func reqLogin(_ token:String,_ userName:String,_ rsp:@escaping(Int,String,GranWinSession?)->Void){
//            let header:HTTPHeaders = ["Content-Type":"application/json;charset=utf-8"]
//            let params:[String:String] = [:]
//            let url = http + api.anonymousLogin + "?username="+userName
//
//            AF.request(url,method: .post,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: header)
//                .validate()
//                .responseDecodable(of:Login.Rsp.self){(dataRsp:AFDataResponse<Login.Rsp>) in
//                switch dataRsp.result{
//                case .success(let ret):
//                    if(ret.code != 0){
//                        log.e("al reqLogin fail \(ret.msg)(\(ret.code))")
//                        rsp(ErrCode.XERR_ACCOUNT_LOGIN,ret.msg,nil)
//                        return
//                    }
//
//                    if let data = ret.data {
//                        self.handleRspLogin(data,rsp)
//                    }else{
//                        rsp(ErrCode.XERR_UNKNOWN,"无法解析参数信息",nil)
//                    }
//
//                case .failure(let error):
//                    log.e("al reqLogin \(url) fail for \(userName), detail: \(error) ")
//                    rsp(ErrCode.XERR_NETWORK,error.errorDescription ?? "网络请求失败",nil)
//                }
//               }
//        }
    
//    func reqGetToken(_ userName:String,_ password:String,_ scope:String,_ clientId:String,_ secretKey:String,_ rsp:@escaping(Int,String,AgoraLabToken?)->Void){
//        var params:Dictionary<String,String> = ["grant_type":"password", "username":userName,"password":password,"scope":scope,"client_id":clientId,"client_secret":secretKey]
//
//        let url = http + api.oauthResetToken
//        
//        AF.request(url,method: .post,parameters: params,encoder: JSONParameterEncoder.default)
//            .validate()
//            .responseDecodable(of:RestToken.Rsp.self){(dataRsp:AFDataResponse<RestToken.Rsp>) in
//            switch dataRsp.result{
//            case .success(let ret):
//                var token:AgoraLabToken? = nil
//                if(ret.code != 0){
//                    log.e("al reqGetToken fail \(ret.msg)(\(ret.code))")
//                }
//                else if(ret.data == nil){
//                    log.e("al reqGetToken data is nil \(ret.msg)(\(ret.code))")
//                }
//                else{
//                    let data = ret.data!
//                    token = AgoraLabToken()
//                    token?.acessToken = data.access_token
//                    token?.expireIn = data.expires_in
//                    token?.refreshToken = data.refresh_token
//                    token?.tokenType = data.token_type
//                    token?.scope = data.scope
//                }
//                
//                rsp(ret.code == 0 ? ErrCode.XOK : ErrCode.XERR_UNKNOWN,ret.msg,token)
//            case .failure(let error):
//                log.e("al reqGetToken \(url) fail for \(userName), detail: \(error) ")
//                rsp(ErrCode.XERR_NETWORK,error.errorDescription ?? "网络请求失败",nil)
//            }
//           }
//    }
    
    func reqLogout(_ account: String,_ rsp: @escaping (Int,String)->Void){
        //log.w("agoralab no api for logout")
        rsp(ErrCode.XOK,"")
    }
}
/* test code
 
 .responseString(completionHandler: {(response) in
 switch response.result{
 case .success(let value):
     log.e(value)
     _ = JSON(value)
     //cb(ErrCode.XERR_ALARM_NOT_FOUND,value,nil)
 case .failure(let error):
     log.e("http request detail: \(error) ")
     //cb(ErrCode.XERR_ACCOUNT_REGISTER,"")
 }
})
 
 */
