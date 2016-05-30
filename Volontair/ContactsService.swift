import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

class ContactsService {
    
    let userService = ServiceFactory.sharedInstance.userService
    
    func lastMessage(messagesLink: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, messagesLink).takeLast(1)
    }
    
    func getListener(userLink: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, userLink)
    }
    
    func getCategorys(CategoryLink: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, CategoryLink)
    }
    
    func getListenerCategories(categoriesLink: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, categoriesLink);
    }
    
    func userCategories(userLink: String)  -> Observable<CategoryModel> {
        return self.getListener(userLink)
            .flatMap({ (userData: AnyObject) -> Observable<AnyObject> in
                let userCategories = userData["offersCategories"]!!["main"] as! NSArray
                return userCategories.toObservable()
            })
            .map({ (categoryData: AnyObject) -> CategoryModel in
                let categoryName = categoryData as! String
                let categoryItem = CategoryModel(name: categoryName, iconName: "", iconColorHex: "")
                
                return categoryItem
            })
    }
    
    func category(categoryName: String) -> Observable<AnyObject> {
        let manager = Manager.sharedInstance
        return manager.rx_JSON(.GET, Config.url + Config.categoryUrl + "\(categoryName)")
    }
    
    func conversations() -> Observable<ConversationModel> {
        
        let manager = Manager.sharedInstance
        let conversationURL = ApiConfig.baseUrl + ApiConfig.usersUrl + String(userService.getCurrentUser()!.userId) + ApiConfig.starterConversationsUrl
        
        return manager.rx_request(.GET, conversationURL)
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .rx_JSON()
            }
            .flatMap({ (data: AnyObject) -> Observable<AnyObject> in
                let data = data["_embedded"]!!["conversations"] as! [AnyObject]
                return data.toObservable()
            })
            .flatMap({ (data: AnyObject) -> Observable<ConversationModel> in
                var conversationListenerLink : String!
                if let dataListenerLink = data["_links"]!!["listener"] as? [String:AnyObject] {
                    conversationListenerLink = dataListenerLink["href"] as! String
                }
                var conversationMessagesLink : String!
                if let dataMessagesLink = data["_links"]!!["messages"] as? [String:AnyObject] {
                    conversationMessagesLink = dataMessagesLink["href"] as! String
                }
                
                return Observable.zip(
                    self.lastMessage(conversationMessagesLink),
                    self.getListener(conversationListenerLink),
                    resultSelector: { (message: AnyObject, listener: AnyObject) -> ConversationModel in
                        
                        let name = listener["name"] as! String
                        let lastMessage = "Test"
                        let avatarUrl = ""
                        let item = ConversationModel(name: name, avatarUrl: avatarUrl, lastMessage: lastMessage, lastMessageDate: NSDate(), conversationListenerLink: conversationListenerLink);
                        item.listener = UserModel(jsonData: listener)
                        
                        return item
                    }
                )
            }).flatMap({ (conversationModel: ConversationModel) -> Observable<ConversationModel> in
                
                let link = conversationModel.listener?.categoriesLink
                
                return Observable.zip(
                    self.getCategorys(link!),
                    self.getCategorys(link!),
                    resultSelector: { (categorie: AnyObject, temp: AnyObject) -> ConversationModel in
                        
                        var categories = [CategoryModel]()

                        for cat in categorie["_embedded"]!!["categories"] as! [[String:AnyObject]]{
                            let category = CategoryModel(JSONData: cat)
                            categories.append(category)
                        }
                        conversationModel.listener?.categorys = categories

                        return conversationModel
                })
                
//                let conver = ConversationModel(name: conversationModel.name, avatarUrl: conversationModel.avatarUrl , lastMessage: conversationModel.lastMessage, lastMessageDate: conversationModel.lastMessageDate, conversationListenerLink: conversationModel.conversationListenerLink)
//                
//                return conver
            })
    }
    
//    func conversationsFilteredByCategory(categoryName: String) -> Observable<ConversationModel>{
//    
//        return self.conversations()
//            .filter({ (data: ConversationModel) -> Bool in
//                //self.getListenerCategories(data.listener!.categoriesLink)
//                ServiceFactory.sharedInstance.userService.getCurrentUser()?.categoriesLink
//                self.getListener("http://volontair.herokuapp.com/api/v1/users/7/categories")
//                    .flatMap({ (categoryData: AnyObject) -> Observable<AnyObject> in
//                        let categories = categoryData["_embedded"]!!["categories"] as! [AnyObject]
//                        return categories.toObservable()
//                    })
//                    
//                    .map({ (singleCategory: AnyObject) -> CategoryModel in
//                        print(singleCategory)
//                        
//                        return CategoryModel(JSONData: singleCategory);
//                    })
//                    .filter({ (data: CategoryModel) -> Bool in
//                        return (data.name == categoryName)
//                    })
//                
//                return false
//            })
//    }


    func myJust<AnyObject>(element: AnyObject) -> Observable<AnyObject> {
        return Observable.create { observer in
            observer.on(.Next(element))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    
    func categories() -> Observable<CategoryModel> {
        return self.conversations()
            .flatMap({ (data: ConversationModel) -> Observable<AnyObject> in
                return self.getListener(data.conversationListenerLink)
            })
            .flatMap({ (userData: AnyObject) -> Observable<AnyObject> in
                var userCategoriesLink : String!
                if let dataUserCategoriesLink = userData["_links"]!!["categories"] as? [String:AnyObject] {
                    userCategoriesLink = dataUserCategoriesLink["href"] as! String
                }
                return self.getListener(userCategoriesLink)
            })
            .flatMap({ (categoryData: AnyObject) -> Observable<AnyObject> in
                
                let categories = categoryData["_embedded"]!!["categories"] as! [AnyObject]
                return categories.toObservable()
            })
            .map({ (singleCategory: AnyObject) -> CategoryModel in
                return CategoryModel(JSONData: singleCategory);
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