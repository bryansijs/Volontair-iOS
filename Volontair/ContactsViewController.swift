import Foundation
import UIKit
import RxSwift

class ContactsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var conversations = [ConversationModel]()
    let contactSercvice = ContactServiceFactory.sharedInstance.getContactsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConversations()
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
    
    func loadConversations() {
        self.contactSercvice.conversations()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .observeOn(MainScheduler.instance)
            .toArray()
            .subscribe(onNext: { (json) -> Void in
                self.conversations += json
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }).addDisposableTo(self.disposeBag)
    }
}