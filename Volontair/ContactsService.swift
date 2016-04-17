import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class ContactsService {
    
    func message(conversationId: Int, messageId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.conversationUrl + "\(conversationId)/" + Config.messagesUrl + "\(messageId)")
    }
    
    func user(userId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.profileUrl + "\(userId)")
    }
    
    func conversations() -> Observable<ConversationModel> {
        
        let manager = Manager.sharedInstance
        let dummyPostURLString = Config.url + Config.conversationUrl
        
        return manager.rx_request(.GET, dummyPostURLString)
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["application/json"])
                    .rx_JSON()
            }
            .flatMap({ (data: AnyObject) -> Observable<AnyObject> in
                let data = data["data"] as! [AnyObject]
                print(data)
                return data.toObservable()
            })
            .flatMap({ (data: AnyObject) -> Observable<ConversationModel> in
                let conversationIdStr = data["conversationId"] as! Int
                let messageIdStr = data["lastMessage"] as! Int
                let listenerIdStr = data["listener"] as! Int
                
                let conversationId = conversationIdStr
                let messageId = messageIdStr
                let listenerId = listenerIdStr
                
                return Observable.zip(
                    self.message(conversationId, messageId: messageId),
                    self.user(listenerId),
                    resultSelector: { (message: AnyObject, user: AnyObject) -> ConversationModel in
                        let name = user["name"] as! String
                        let lastMessage = message["message"] as! String
                        let avatarUrl = user["avatar"] as! String
                        let item = ConversationModel(name: name, avatarUrl: avatarUrl, lastMessage: lastMessage, lastMessageDate: NSDate());
                        return item
                    }
                )
            })
    }
    
    init(){ }
    
}