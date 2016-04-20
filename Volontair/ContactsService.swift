import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

class ContactsService {
    
    func message(conversationId: Int, messageId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.conversationUrl + "\(conversationId)/" + Config.messagesUrl + "\(messageId)")
    }
    
    func user(userId: Int) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.profileUrl + "\(userId)")
    }
    
    func category(categoryName: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.categoryUrl + "\(categoryName)")
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
                        let item = ConversationModel(name: name, avatarUrl: avatarUrl, lastMessage: lastMessage, lastMessageDate: NSDate(), listenerId: listenerId);
                        return item
                    }
                )
            })
    }
    
    func categorys() -> Observable<CategoryModel> {
        return self.conversations()
            .flatMap({ (data: ConversationModel) -> Observable<AnyObject> in
                return self.user(data.listenerId)
            })
            .flatMap({ (userData: AnyObject) -> Observable<AnyObject> in
                let userCategories = userData["offersCategories"]!!["main"] as! NSArray
                return userCategories.toObservable()
            })
            .map({ (categorieData: AnyObject) -> CategoryModel in
                let categoryName = categorieData as! String
                let categoryItem = CategoryModel(name: categoryName, iconName: "")
                
                return categoryItem
            })
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year)" + NSLocalizedString("YEARS_AGO",comment: "")
        } else if (components.year >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_YEAR_AGO",comment: "")
            } else {
                return NSLocalizedString("LAST_YEAR",comment: "")
            }
        } else if (components.month >= 2) {
            return "\(components.month)" + NSLocalizedString("MONTHS_AGO",comment: "")
        } else if (components.month >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_MONTH_AGO",comment: "")
            } else {
                return NSLocalizedString("LAST_MONTH",comment: "")

            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear)" + NSLocalizedString("WEEKS_AGO",comment: "")
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_WEEK_AGO",comment: "")
            } else {
                return NSLocalizedString("LAST_WEEK",comment: "")

            }
        } else if (components.day >= 2) {
            return "\(components.day)" + NSLocalizedString("DAYS_AGO",comment: "")
        } else if (components.day >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_DAY_AGO",comment: "")
            } else {
                return NSLocalizedString("YESTERDAY",comment: "")

            }
        } else if (components.hour >= 2) {
            return "\(components.hour)" + NSLocalizedString("HOURS_AGO",comment: "")
        } else if (components.hour >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_HOUR_AGO",comment: "")
            } else {
                return NSLocalizedString("AN_HOUR_AGO",comment: "")
            }
        } else if (components.minute >= 2) {
            return "\(components.minute)" + NSLocalizedString("MINUTES_AGO",comment: "")
        } else if (components.minute >= 1){
            if (numericDates){
                return NSLocalizedString("ONE_MINUTE_AGO",comment: "")
            } else {
                return NSLocalizedString("A_MINUTE_AGO",comment: "")
            }
        } else if (components.second >= 3) {
            return "\(components.second)" + NSLocalizedString("SECONDS_AGO",comment: "seconds ago")
        } else {
            return NSLocalizedString("JUST_NOW", comment: "hello")
            
        }
        
    }
    
    init(){ }
    
}