//
//  ProfileCollectionViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 27-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController {
    
    
    var categories: [CategoryModel]? {
        didSet {
            // Update the view.
            self.update()
        }
    }
    
    override func viewDidLoad() {
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categoryAmount = self.categories?.count {
            return categoryAmount
        } else {
            return 0
        }
    }
    
    func update(){
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundView = UIImageView(image: self.categories![indexPath.row].icon)
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 25, 25);
        return cell
    }
}
