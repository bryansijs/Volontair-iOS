import Foundation
import UIKit
import RxSwift

class ContactsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var conversations = [ConversationModel]()
    let contactSercvice = ContactServiceFactory.sharedInstance.getContactsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleConversations()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        let conversation = conversations[indexPath.row]
        
        cell.nameLabel.text = conversation.name
        cell.lastMessageLabel.text = conversation.lastMessage
        cell.timeLabel.text = "zojuist"
        
        return cell
    }
    
    func loadSampleConversations() {
        let conversation1 = ConversationModel(name: "Lars Ulrich", avatarUrl: "", lastMessage: "Hoi, nee. Laat maar.", lastMessageDate: NSDate())
        let conversation2 = ConversationModel(name: "Nathan Statham", avatarUrl: "", lastMessage: "Lorum ipsum dolor sit amet.", lastMessageDate: NSDate())
        let conversation3 = ConversationModel(name: "Lara Staar", avatarUrl: "", lastMessage: "Hoi, ok.", lastMessageDate: NSDate())
        
        let disposeBag = DisposeBag()
        contactSercvice.conversations()
            .observeOn(MainScheduler.instance)
            .map({ (item: ConversationItem) -> ConversationModel in
                let conv = ConversationModel(name: item.name, avatarUrl: item.avatarUrl, lastMessage: item.lastMessage, lastMessageDate: NSDate())
                return conv
            })
            .toArray()
            .subscribe(onNext: { (models) -> Void in
                self.conversations += models
                self.tableView.reloadData()
                }, onError: { (e) -> Void in
                    print(e)    
            }).addDisposableTo(disposeBag)
        conversations += [conversation1, conversation2, conversation3]
    }
    
    func loadConversations() {
        
    }
}