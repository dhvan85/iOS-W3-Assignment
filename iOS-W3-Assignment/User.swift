//
//  User.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/29/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.screenName = aDecoder.decodeObject(forKey: "screenName") as? String
        self.profileUrl = aDecoder.decodeObject(forKey: "profileUrl") as? URL
        self.tagLine = aDecoder.decodeObject(forKey: "tagLine") as? String
    }
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagLine = dictionary["Description"] as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(screenName, forKey: "screenName")
        aCoder.encode(profileUrl, forKey: "profileUrl")
        aCoder.encode(tagLine, forKey: "tagLine")
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "CurrentUser") as? Data
                
                if let userData = userData {
                    _currentUser = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = NSKeyedArchiver.archivedData(withRootObject: user)
                
                defaults.set(data, forKey: "CurrentUser")
            }
            else {
                defaults.set(nil, forKey: "CurrentUser")
            }
            
            defaults.synchronize()
        }
    }
}
