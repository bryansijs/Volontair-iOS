import Foundation

class ConversationModel {
    var name: String = ""
    var avatarUrl: String = ""
    var lastMessage: String = ""
    var listenerId: Int
    var lastMessageDate: NSDate
    
    init(name: String, avatarUrl: String, lastMessage: String, lastMessageDate: NSDate, listenerId: Int) {
        self.name = name
        self.avatarUrl = avatarUrl
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.listenerId = listenerId
    }
}