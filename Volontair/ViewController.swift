//
//  ViewController.swift
//  Volontair
//
//  Created by C. Atlantic on 2/18/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    var identifiers: NSArray = ["UserTypeViewController","UserCategoryViewController","UserPrefrencesViewController"]
    
    var userTypeViewController : UIViewController?
    var userCategoryViewController : UIViewController?
    var userPrefrencesViewController : UIViewController?
    var disclaimerViewController : UIViewController?
    
    var pageViewController : UIPageViewController!
    
    func reset() {
        // create contentPageViewControllers
        disclaimerViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("DisclaimerViewController"))! as UIViewController
        userTypeViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("UserTypeViewController"))! as UIViewController
        userCategoryViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("UserCategoryViewController"))! as UIViewController
        userPrefrencesViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("UserPrefrencesViewController"))! as UIViewController

        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = nil
        
        for reconizer in pageViewController.gestureRecognizers{
            reconizer.enabled = false;
        }
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 50)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: PageViewController
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = index
        return self.viewControllerAtIndex(self.index+1)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = index
        return self.viewControllerAtIndex(self.index-1)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController {
        switch index {
        case 0: return disclaimerViewController!
        case 1: return userTypeViewController!
        case 2: return userCategoryViewController!
        case 3: return userPrefrencesViewController!
        default: return userTypeViewController!
        }
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func createValidationAlert(){
        let alert = UIAlertController(title: NSLocalizedString("ALERT",comment: "")
            , message: NSLocalizedString("FIELDS_NOT_FILLED_IN",comment: "")
            , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CLICK",comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Buttons
    @IBAction func nextButtonPressd(sender: AnyObject) {
        if(self.index != self.identifiers.count-1){
            let currentContentViewController = self.viewControllerAtIndex(self.index) as! ValidationProtocol
            if(currentContentViewController.validate()){
                let pageContentViewController = self.viewControllerAtIndex(self.index+1)
                self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                self.index += 1
            } else {
                createValidationAlert()
            }
        } else {
            let currentContentViewController = self.viewControllerAtIndex(self.index) as! ValidationProtocol
            if(currentContentViewController.validate()){
                WizardServiceFactory.sharedInstance.wizardService.submitUser()
                performSegueWithIdentifier("showDashboardFromWizard", sender: nil)
            }else {
                createValidationAlert()
            }
        }
    }
    
    @IBAction func previousButtonPressed(sender: UIButton) {
        if(self.index != 0){
            let pageContentViewController = self.viewControllerAtIndex(self.index-1)
            self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
            self.index -= 1
        }
    }
}