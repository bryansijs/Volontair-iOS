//
//  ProfileModel.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class ProfileModel {
    
    //TODO: right user number
    var url = "http://volontairtest-mikero.rhcloud.com/"
    let profileUrl = "users/1"
    let notificationKey = "profileDataChanged"
    var data: [String:AnyObject]? = nil
    var profilePicture: NSData? = nil
    
    init(){
        getJson()
    }
    
    func getData()->[String:AnyObject]{
        return data!
    }
    
    func refresh(){
        getJson()
    }
    
    private func getJson(){
        
        //check if URL is valid
        let profileURL = url + profileUrl
        guard let url = NSURL(string: profileURL) else {
            print("Error: cannot create URL")
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            if let httpRes = response as? NSHTTPURLResponse {
                print("status code=",httpRes.statusCode)
                if httpRes.statusCode == 200 {
                    // parse data
                    return self.parseDate(data)
                }
            } else {
                print("error \(error)") // print the error!
            }
        }
        task.resume()
    }
    
    private func getProfilePicture(pictureURL: String){
        let imageURL = self.url + pictureURL
        let url = NSURL(string: imageURL)
        self.profilePicture = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
    }
    
    private func parseDate(JSONdata: NSData?)
    {
        do {
            let parsed = try NSJSONSerialization.JSONObjectWithData(JSONdata!, options:[]) as! [String:AnyObject]
            data = parsed
            getProfilePicture((data!["avatar"] as? String)!)
            print(parsed)
        } catch {
            print("error \(error)") // print the error!
        }
        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: self)
    }

}