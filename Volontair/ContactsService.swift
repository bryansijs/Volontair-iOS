import Foundation
import RxSwift
import Alamofire
import RxAlamofire


class ContactsService {
//    func conversations() -> Observable<ConversationModel> {
//        return nil
//    }
    let disposeBag = DisposeBag()

    
    init(){
        
        let manager = Manager.sharedInstance
        let dummyPostURLString = "http://volontairtest-mikero.rhcloud.com/conversations"
        let dummyCommentsURLString = "http://jsonplaceholder.typicode.com/posts/1/comments"
        
        let postObservable = JSON(Method.GET, dummyPostURLString)
        let commentsObservable = JSON(Method.GET, dummyCommentsURLString)

        
        _ = manager.rx_request(.GET, dummyPostURLString)
            .flatMap {
               return $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["application/json"])
                    .rx_JSON()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (json) -> Void in
                print(json)
            }).addDisposableTo(disposeBag)

            
        
        
        
        
        Observable.zip(postObservable, commentsObservable) { postJSON, commentsJSON in
            return (postJSON, commentsJSON)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { postJSON, commentsJSON in
                
                
                let postInfo = NSMutableString()
                if let postDict = postJSON as? [String: AnyObject], let commentsArray = commentsJSON as? Array<[String: AnyObject]> {
                    postInfo.appendString("Title: ")
                    postInfo.appendString(postDict["title"] as! String)
                    postInfo.appendString("\n\n")
                    postInfo.appendString(postDict["body"] as! String)
                    postInfo.appendString("\n\n\nComments:\n")
                    for comment in commentsArray {
                        postInfo.appendString(comment["email"] as! String)
                        postInfo.appendString(": ")
                        postInfo.appendString(comment["body"] as! String)
                        postInfo.appendString("\n\n")
                    }
                }
                
                print(postInfo)
                }, onError:{ e in
                    print("An Error Occurred")
            }).addDisposableTo(disposeBag)
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