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
    var allConversations = [ConversationModel]()
    
    var skillCategories = [String: CategoryModel]()
    
    let contactService = ContactServiceFactory.sharedInstance.getContactsService()
    
    
    
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
        
        loadCategories()
        loadConversations()
        
        if (skillCategories.count > 0){
            categoryTextField.text = skillCategories.first?.1.name
        } else {
            categoryTextField.text = NSLocalizedString("NO_CATEGORY",comment: "")
        }
    }
    
    //MARK: TableView
    
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
        cell.timeLabel.text = contactService.timeAgoSinceDate(conversation.lastMessageDate, numericDates: true)
        
        // round images
        cell.contactImageView.layer.cornerRadius = cell.contactImageView.frame.size.width / 2
        cell.contactImageView.layer.masksToBounds = true

        //Download profile picutre Async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let imageURL = Config.url + conversation.avatarUrl
            let url = NSURL(string: imageURL)
//            let imageData = NSData(contentsOfURL: url!)!

//            dispatch_async(dispatch_get_main_queue()) {
//                cell.contactImageView.image = UIImage(data: imageData)
//            }
        }
        
        return cell
    }
    
    //MARK: Data
    
    func loadConversations() {
        self.conversations.removeAll()
        self.contactService.conversations()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .observeOn(MainScheduler.instance)
            .toArray()
            .subscribe(onNext: { (json) -> Void in
                self.conversations += json
                self.allConversations = self.conversations
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    func loadConversationsFilteredBy(filter: String){
        self.conversations.removeAll()
        self.contactService.conversationsFilteredByCategory(filter)
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
    
    func loadCategories() {
        self.skillCategories.removeAll()
        skillCategories[""] = CategoryModel(name: "", iconName: "", iconColorHex: "")
        
        contactService.categories()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .observeOn(MainScheduler.instance)
            .toArray()
            .subscribe(onNext: { (json) -> Void in
                if json.count > 0{
                    for i in 0...json.count-1{
                        if let category = json[i] as? CategoryModel{
                            self.skillCategories[category.name] = category
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.skillCategoryPicker.reloadAllComponents()
                    self.categoryTextField.text = self.skillCategories.first?.1.name
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
        return skillCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        return skillCategories.keys[index]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        if(skillCategories[index].0 != ""){
            self.loadConversationsFilteredByCategory(skillCategories[index].0)
            //loadConversationsFilteredBy(skillCategories[index].0)
        } else {
            loadConversations()
        }
        categoryTextField.text = skillCategories[index].0
        skillCategoryPicker.hidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        skillCategoryPicker.hidden = false
        return false
    }
    
    func loadConversationsFilteredByCategory(categoryName : String) {
        self.conversations = [ConversationModel]()
        for conversation : ConversationModel in self.allConversations {
            for categorie : CategoryModel in (conversation.listener?.categorys)! {
                print(categorie.name + " - " + categoryName)
                if(categorie.name == categoryName) {
                    self.conversations.append(conversation)
                }
            }
        }
    }
    
}