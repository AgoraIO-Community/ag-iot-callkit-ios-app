//
//  AgoraLab.Type.swift
//  AgoraIotSdk
//
//  Created by ADMIN on 2022/4/23.
//

import Foundation

extension AgoraLab{
    class api{
        static let call = "/call-service/v1/call"
        static let answer = "/call-service/v1/answer"
        
        static let add = "/alert-center/alert-message/v1/add"
        static let delete = "/alert-center/alert-message/v1/delete"
        static let batchDelete = "/alert-center/alert-message/v1/deleteBatch"
        static let update = "/alert-center/alert-message/v1/update"
        static let singleRead = "/alert-center/alert-message/v1/readMessage"
        static let batchRead = "/alert-center/alert-message/v1/readMessageBatch"
        static let getById = "/alert-center/alert-message/v1/getById"
        static let getPage = "/alert-center/alert-message/v1/getPage"
        
        static let oauthRegister = "/oauth/register"
        static let oauthResetToken = "/oauth/rest-token"
        static let getAlertCount = "/alert-center/alert-message/v1/count"
        static let anonymousLogin = "/oauth/anonymous-login"
        static let sysReadMsg = "/alert-center/system-message/v1/readMessage"
        static let sysReadMsgBatch = "/alert-center/system-message/v1/readMessageBatch"
        static let sysGetById = "/alert-center/system-message/v1/getById"
        static let sysGetPage = "/alert-center/system-message/v1/getPage"
        static let sysGetAlertCount = "/alert-center/system-message/v1/count"
        
        static let uploadHeadIcon = "/file-system/image/v1/uploadFile"
        static let CerGet = "/device/invent/certificate/get"
    }

    static let tokenExpiredCode = 401

    class RspCode{
        public static let OK = 0
        public static let IN_TALKING = 100001      ///<	对端通话中，无法接听
        public static let ANSWER = 100002          ///<	未通话，无法接听
        public static let HANGUP = 100003          ///<	未通话，无法挂断
        public static let ANSWER_TIMEOUT = 100004  ///< 接听等待超时
        public static let CALL = 100005            ///< 呼叫中，无法再次呼叫
        public static let INVALID_ANSWER = 100006  ///< 无效的Answer应答
        public static let SAME_ID = 100007         ///< 主叫和被叫不能是同一个id
        public static let APPID_NOT_REPORT = 100008 ///< 未上报app id
        public static let SYS_ERROR = 999999      ///< 系统异常，具体原因查看错误提示信息
        
    }
    
    struct Rsp:Decodable{
        let code:Int
        let msg:String
        let timestamp:UInt64
        let success:Bool
    }
    
    class CertGet{
            struct Info : Decodable{
                let privateKey:String
                let certificatePem:String
                let certificateArn:String
                let regionId:String
                let domain:String
                let thingName:String
                let region:String
                let deviceId:UInt64
            }
            struct Rsp : Decodable{
                let code:Int
                let info:Info?
                let tip:String
            }
        }
    
    class Login{
            struct Data: Decodable {
                struct Pool : Decodable{
                    let identifier:String
                    let identityId:String
                    let identityPoolId:String
                    let token:String
                }
                struct Proof:Decodable{
                    let accessKeyId:String
                    let secretKey:String
                    let sessionToken:String
                    let sessionExpiration:UInt64
                }
                struct Info: Decodable{
                    let account:String
                    let endpoint:String
                    let region:String
                    //let refresh:String
                    let expiration:Int
                    let granwin_token:String
                    let pool:Pool
                    let proof:Proof
                }
                let code: Int
                let info:Info?
                let tip:String
            }
            struct Rsp: Decodable{
                let code:Int
                let msg:String
                let timestamp:UInt64
                let success:Bool
                let data:Data?
            }
        }
        
        func handleRspCert(_ certRsp:CertGet.Rsp,_ rsp:@escaping(Int,String,GranWinSession.Cert?)->Void){
            if(certRsp.code != 0){
                log.e("gw handleRspCert rsp error:\(certRsp.code),tip:\(certRsp.tip)")
                rsp(ErrCode.XERR_ACCOUNT_LOGIN,certRsp.tip,nil)
                return;
            }
            guard let info = certRsp.info else{
                log.e("gw handleRspCert rsp info is null")
                rsp(ErrCode.XERR_ACCOUNT_LOGIN,certRsp.tip,nil)
                return
            }
            var cert = GranWinSession.Cert()
            /*
             let privateKey:String
             let certificatePem:String
             let certificateArn:String
             let regionId:String
             let domain:String
             let thingName:String
             let region:String
             let deviceId:UInt64
             */
            cert.privateKey = info.privateKey
            cert.certificatePem = info.certificatePem
            cert.certificateArn = info.certificateArn
            cert.regionId = info.regionId
            cert.domain = info.domain
            cert.thingName = info.thingName
            cert.region = info.region
            cert.deviceId = info.deviceId
            
            log.i("gw thingName: \(cert.thingName)")
            rsp(ErrCode.XOK,certRsp.tip,cert)
        }
        
        func handleRspLogin(_ loginRsp:Login.Data,_ rsp: @escaping (Int,String,GranWinSession?)->Void){
            if(loginRsp.code != 0){
                log.e("gw handleRspLogin rsp error:\(loginRsp.code),tip:\(loginRsp.tip)")
                var ec = ErrCode.XERR_ACCOUNT_LOGIN
                if(loginRsp.code == 10002){
                    ec = ErrCode.XERR_ACCOUNT_NOT_EXIST
                }
                else if(loginRsp.code == 10003){
                    ec = ErrCode.XERR_ACCOUNT_PASSWORD_ERR
                }
                rsp(ec,loginRsp.tip,nil)
                return;
            }
            guard let info = loginRsp.info else{
                log.e("gw handleRspLogin rsp info is null")
                rsp(ErrCode.XERR_ACCOUNT_LOGIN,loginRsp.tip,nil)
                return
            }
            let sess = GranWinSession()
            
            sess.account = info.account
            sess.proof_sessionToken = info.proof.sessionToken
            sess.proof_secretKey = info.proof.secretKey
            sess.granwin_token = info.granwin_token
            sess.endPoint = info.endpoint
            sess.pool_token = info.pool.token
            sess.pool_identifier = info.pool.identifier
            sess.pool_identityId = info.pool.identityId
            sess.pool_identityPoolId = info.pool.identityPoolId
            sess.region = info.region
            //sess.granwinToken = info.granwin_token
            
            log.i("gw token: \(sess.granwin_token)")
            log.i("gw poolIdentifier: \(info.pool.identifier)")
            log.i("gw login ret:\(info)")
            rsp(ErrCode.XOK,loginRsp.tip,sess)
        }
    class RestToken{
        struct Req:Encodable{
            let grant_type:String  //授权类型。password：密码模式，client_credentials：客户端模式，refresh_token：刷新accessToken
            let username:String //用户名
            let password:String //密码
            let scope:String //当前固定值：read
            let client_id:String //"9598156a7d15428f83f828a70f40aad5", //AK
            let client_secret:String //"MRbRz1kGau9BZE0gWRh9YMZSYc1Ue06v" //SK
        }

        struct Data:Decodable{
            let access_token:String
            let token_type:String
            let refresh_token:String
            let expires_in:UInt
            let scope:String
        }
        
        struct Rsp:Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Data?
        }
    }

    class Register{
        struct Rsp : Decodable{
            let code:Int
            let message:String
            struct Data : Decodable{
                let agoraUid:UInt
                let customerAccountId:String
            }
            let data:Data?
        }
    }

    struct Header : Encodable {
        let traceId:String
        let timestamp:UInt64
        init(traceId:String = ""){
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            timestamp = UInt64(round(timeInterval*1000))
            self.traceId = traceId
        }
    }

    class AlertMessageDelete{
        struct Req : Encodable{
            let header : Header
            let payload : Int
            init(_ header:Header,_ index:Int){
                self.header = header
                self.payload = index
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Bool
        }
    }
    class AlertMessageBatchDelete{
        struct Req : Encodable{
            let header : Header
            let payload : [Int]
            init(_ header:Header,_ indexes:[Int]){
                self.header = header
                self.payload = indexes
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Bool
        }
    }
    class AlertMessageUpdate{
        struct Payload : Encodable{
            let alertMessageId:Int
            let tenantId:String
            let productId:String
            let deviceId : String
            let description:String
            let fileUrl:String
            let status:Int
            let messageType:Int
        }
        struct Req : Encodable{
            let header : Header
            let payload : Payload
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Bool
        }
    }
    class AlertMessageAdd{
        struct Payload : Encodable{
            let tenantId:String
            let productId:String
            let deviceId:String
            let deviceName:String
            let description:String
            let fileUrl:String
            let status:Int
            let messageType:Int //0,1,99
        }
        struct Req : Encodable{
            let header : Header
            let payload : Payload
            init(_ header:Header,_ payload: Payload){
                self.header = header
                self.payload = payload
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:UInt
        }
    }
    class AlertMessageRead{
        struct Req : Encodable{
            let header : Header
            let payload : Int
            init(_ header:Header,_ index:Int){
                self.header = header
                self.payload = index
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Bool
        }
    }
    class AlertMessageBatchRead{
        struct Req : Encodable{
            let header : Header
            let payload : [UInt64]
            init(_ header:Header,_ indexes:[UInt64]){
                self.header = header
                self.payload = indexes
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Bool
        }
    }
    class AlertMessageGetById{
        struct Req : Encodable{
            let header:Header
            let payload:UInt64
            init(_ header:Header,_ alertMessageId:UInt64){
                self.header = header
                self.payload = alertMessageId
            }
        }
        struct Data : Decodable{
            let alertMessageId:UInt64
            let messageType:UInt
            let description:String?
            let fileUrl:String?
            let status:UInt
            let tenantId:String
            let productId:String
            let deviceId:String
            let deviceName:String
            let deleted:Bool
            let createdBy:UInt
            let createdDate:UInt64
            let changedBy:UInt?
            let changedDate:UInt64?
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data : Data?
        }
    }

    class AlertCount{
        struct Payload : Encodable{
            let tenantId:String?
            var productId:String? = nil
            var deviceId:String? = nil
            var messageType:Int? = nil //0:sound dectect,1:motion dectect, 99:other
            var status:Int? = nil      //0:not read,1:have read
            var createdDateBegin:String? = nil
            var createdDateEnd:String? = nil
        }
        struct Req : Encodable{
            let header : Header
            let payload : Payload
            init(_ header:Header,_ payload:Payload){
                self.header = header
                self.payload = payload
            }
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:UInt
        }
    }

    class Call{
        struct Payload : Encodable{
            let callerId:String
            let calleeIds:[String]
            let attachMsg:String
            let appId:String
        }
        struct Req : Encodable{
            let header:Header
            let payload:Payload
        }
        struct Data : Decodable{
            let appId:String
            let channelName:String
            let rtcToken:String
            let uid:String
            let sessionId:String
            let callStatus:Int
            let cloudRecordStatus:Int
            //let deviceAlias:String
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let data:Data?
        }
    }

    class Answer{
        struct Payload : Encodable{
            let sessionId:String
            let calleeId:String
            let callerId:String
            let localId:String
            let answer:Int //0:接听，1:挂断
        }
        struct Req : Encodable{
            let header:Header
            let payload:Payload
        }
        struct Data : Decodable{
            let sessionId:String
        }
        struct Rsp : Decodable{
            let code:Int
            let msg:String
            let timestamp:UInt64
            let success:Bool
            let data:Data?
        }
    }
}
