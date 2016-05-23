//
//  CategoryService.swift
//  Volontair
//
//  Created by Bryan Sijs on 23-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CategoryService {
    var categories = [CategoryModel]()
    
    init(){
        print("init CategoryService")
    }
    
    func loadCategories(){
        Alamofire.request(.GET, ApiConfig.baseUrl + ApiConfig.categoryUrl)
            .validate()
            .responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    for cat in value["_embedded"]!!["categories"] as! [[String:AnyObject]]{
                        let category = CategoryModel(JSONData: cat)
                        self.categories.append(category)
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}