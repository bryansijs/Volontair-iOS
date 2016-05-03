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
    var identifiers: NSArray = ["FirstNavigationController", "SecondNavigationController"]
    var pageViewController : UIPageViewController!
    
    func reset() {
        
        
            /* Getting the page View controller */
            pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
            self.pageViewController.dataSource = self
            
            let pageContentViewController = self.viewControllerAtIndex(0)
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            /* We are substracting 30 because we have a start again button whose height is 30*/
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 30)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(self.index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(self.index)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            return self.storyboard!.instantiateViewControllerWithIdentifier("FirstViewController") as UIViewController
        }
        
        //second view controller = secondViewController's navigation controller
        if index == 1 {
            return self.storyboard!.instantiateViewControllerWithIdentifier("SecondViewController") as UIViewController
        }
        return nil
    }
    
   
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func startWalkthrough(sender: UIButton) {
        if(self.index != 0){
            let startingViewController = self.viewControllerAtIndex(0)
            let viewControllers = [startingViewController!]
            self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
    
    
}