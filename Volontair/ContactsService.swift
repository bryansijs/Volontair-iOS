import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class ConversationItem {
    var name: String
    var lastMessage: String
//    var lastMessageDate: NSDate
    var avatarUrl: String
    
    init(name: String, lastMessage: String, avatarUrl: String) {
        self.name = name
        self.lastMessage = lastMessage
//        self.lastMessageDate = lastMessageDate
        self.avatarUrl = avatarUrl
    }
}

class ContactsService {
//    func conversations() -> Observable<ConversationModel> {
//        return nil
//    }
    let disposeBag = DisposeBag()

    func message(conversationId: Int, messageId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, "http://volontairtest-mikero.rhcloud.com/conversations/\(conversationId)/messages/\(messageId)")
    }
    
    func user(userId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, "http://volontairtest-mikero.rhcloud.com/users/\(userId)")
    }
    
    func conversations() -> Observable<ConversationItem> {
        let manager = Manager.sharedInstance
        return manager.rx_request(.GET, "http://volontairtest-mikero.rhcloud.com/conversations")
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
            .flatMap({ (data: AnyObject) -> Observable<ConversationItem> in
                let conversationIdStr = data["conversationId"] as! Int
                let messageIdStr = data["lastMessage"] as! Int
                let listenerIdStr = data["listener"] as! Int
                
                let conversationId = conversationIdStr
                let messageId = messageIdStr
                let listenerId = listenerIdStr
                
                return Observable.zip(
                    self.message(conversationId, messageId: messageId),
                    self.user(listenerId),
                    resultSelector: { (message: AnyObject, user: AnyObject) -> ConversationItem in
                        let name = user["name"] as! String
                        let lastMessage = message["message"] as! String
                        let avatarUrl = user["avatar"] as! String
                        let item = ConversationItem(name: name, lastMessage: lastMessage, avatarUrl: avatarUrl);
                        return item
                    }
                )
            })
    }
    
    init(){
        
        let manager = Manager.sharedInstance
        let dummyPostURLString = "http://volontairtest-mikero.rhcloud.com/conversations"
        let dummyCommentsURLString = "http://jsonplaceholder.typicode.com/posts/1/comments"
        
        let postObservable = JSON(Method.GET, dummyPostURLString)
        let commentsObservable = JSON(Method.GET, dummyCommentsURLString)
        
        
    }
    
}

//request('/conversations', function(data) {
//    var conversations = []
//    for(var conversation in data) {
//        var user = request('/user/' + conversation.listenerId, function(userData) {
//            var message = request('/conversations/' + data.id + '/messages/' + data.lastMessageId, function() {
//                var conversationItem = new ConversationItem(
//                    user.avatar,
//                    user.name,
//                    messsage.message,
//                    data.created
//                );
//                conversations.push(conversationItem);
//                
//                if(conversation == data.last()) {
//                    sendNotification();
//                }
//                });
//            });
//        
//    }
//    });