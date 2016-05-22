//
//  RequestService.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestService{
    
    var requests = [RequestModel]()
    
    //POST
    func submitRequest(request: RequestModel){
        //params.
        let parameters = request.toJson()
        
        Alamofire.request(.POST, ApiConfig.baseUrl + ApiConfig.requestsEndPoint, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { response in
                if(!response.result.isSuccess){
                    print("submit request wrong")
                    return
                }

                let data = JSON(response.result.value!)
                request.requestLink = data["_links"]["self"]["href"].stringValue
        }
    }
    
    func loadRequestCategory(request: RequestModel,requestURL: String){
        let requestUrl = NSURL(string: requestURL)
        
        Alamofire.request(.GET, requestUrl!, headers: ApiConfig.headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    var categorys : [CategoryModel] = []
                    categorys.append(CategoryModel(JSONData: value))
                    request.categorys = categorys
                }
            case .Failure(let error):
                print("Error getRequestBasic", error)
            }
        }
    }
    
    internal func getRequestBasic(completionHandler: (RequestModel) ->Void) {
        let requestUrl = NSURL(string: ApiConfig.baseUrl + ApiConfig.requestsEndPoint)
        
        Alamofire.request(.GET, requestUrl!, headers: ApiConfig.headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    for request in value["_embedded"]!!["requests"] as! [[String:AnyObject]] {
                        // get User as owner
                        self.getRequestUser(request, completionHandler: completionHandler)
                    }
                    print("Error getRequestBasic")
                }
            case .Failure(let error):
                print("Error getRequestBasic", error)
            }
        }

    }
    
    internal func getRequestUser(requestData : AnyObject, completionHandler: (RequestModel) ->Void) {
        let requestJson = JSON(requestData)
        Alamofire.request(.GET, requestJson["_links"]["creator"]["href"].stringValue , headers: ApiConfig.headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                // get user Category's
                if let value = response.result.value {
                    let user = UserModel(jsonData: value)
                    ServiceFactory.sharedInstance.userService.loadUserRequests(user)
                    
                    self.getRequestCategory(requestData, user: user, completionHandler: completionHandler)
                }
            case .Failure(let error):
                print("Error getRequestUser", error)
            }
        }
    }

    internal func getRequestCategory(requestJson: AnyObject, user: UserModel, completionHandler: (RequestModel) ->Void) {
        
        let jsonRequest = JSON(requestJson)
        Alamofire.request(.GET, jsonRequest["_links"]["category"]["href"].stringValue , headers: ApiConfig.headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    var categorys : [CategoryModel] = []
                    
                    categorys.append(CategoryModel(JSONData: value))
                    
                    self.createFullestFromJsonData(requestJson, owner: user, jsonCategory: categorys, completionHandler: completionHandler)
                }
            case .Failure(let error):
                print("Error getRequestUser", error)
            }
        }
    }

    private func createFullestFromJsonData(jsonRequest: AnyObject, owner: UserModel, jsonCategory: [CategoryModel], completionHandler: (RequestModel) ->Void) {
        
        let requestModel = RequestModel(requestData: jsonRequest, requestOwner: owner, requestCategorys: jsonCategory)
        completionHandler(requestModel)
        
        //NSNotificationCenter.defaultCenter().postNotificationName(ApiConfig.requestDataUpdateNotificationKey, object: requestModel)
        print(requestModel)
    }
    
    func editUserRequest(request: RequestModel){
        
        //params.
        let parameters = request.toJson()
        print(parameters)
        
        Alamofire.request(.PATCH, request.requestLink!, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(error)
        }
    }
    
    func deleteUserRequest(request: RequestModel){
        
        Alamofire.request(.DELETE, request.requestLink!, headers: ApiConfig.headers).validate().responseJSON { response in switch
        response.result {
        case .Success:
            if let value = response.result.value {
                print(value)
            }
        case .Failure(let error):
            print(error)
            }
        }
        
        let currentUser = ServiceFactory.sharedInstance.userService.userMe
        let index = currentUser!.requests?.indexOf(request)
        currentUser!.requests?.removeAtIndex((index?.littleEndian)!)
    }
    
    
    //GET
    func loadRequestDataFromServer(completionHandler: (RequestModel)->Void) {
        self.getRequestBasic(completionHandler)
    }
}