import Foundation

class ConversationModel {
    var name: String = ""
    var avatarUrl: String = ""
    var lastMessage: String = ""
    var conversationListenerLink: String
    var lastMessageDate: NSDate
    var listener: UserModel?
    
    init(name: String, avatarUrl: String, lastMessage: String, lastMessageDate: NSDate, conversationListenerLink: String) {
        self.name = name
        self.avatarUrl = avatarUrl
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.conversationListenerLink = conversationListenerLink
    }
}