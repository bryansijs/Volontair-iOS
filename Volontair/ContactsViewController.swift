import Foundation
import UIKit
import RxSwift

class ContactsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var skillCategoryPicker: UIPickerView!
    
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    var conversations = [ConversationModel]()
    let contactSercvice = ContactServiceFactory.sharedInstance.getContactsService()
    
    var skillCategorys = ["Cat One", "Cat Two", "Cat Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ContactsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        
        //Category filter
        let imageView = UIImageView();
        imageView.image = UIImage(named: "Filter");
        imageView.frame = CGRectMake(0, 0, 20, 20);
        categoryTextField.leftView = imageView;
        categoryTextField.leftViewMode = UITextFieldViewMode.UnlessEditing
        
        //Category picker
        skillCategoryPicker.delegate = self
        skillCategoryPicker.hidden = true
        skillCategoryPicker.showsSelectionIndicator = true
        categoryTextField.text = skillCategorys[0]
        
        loadConversations()
    }
    
    func refresh(sender:AnyObject)
    {
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
        cell.timeLabel.text = contactSercvice.timeAgoSinceDate(conversation.lastMessageDate, numericDates: true)
        
        // round images
        cell.contactImageView.layer.cornerRadius = cell.contactImageView.frame.size.width / 2
        cell.contactImageView.layer.masksToBounds = true

        //Download profile picutre Async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let imageURL = Config.url + conversation.avatarUrl
            let url = NSURL(string: imageURL)
            let imageData = NSData(contentsOfURL: url!)!

            dispatch_async(dispatch_get_main_queue()) {
                cell.contactImageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
    func loadConversations() {
        self.conversations.removeAll()
        self.contactSercvice.conversations()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .observeOn(MainScheduler.instance)
            .toArray()
            .subscribe(onNext: { (json) -> Void in
                self.conversations += json
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    //MARK: UIPicker
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return skillCategorys.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return skillCategorys[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryTextField.text = skillCategorys[row]
        skillCategoryPicker.hidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("editor mode")
        skillCategoryPicker.hidden = false
        return false
    }
    
}