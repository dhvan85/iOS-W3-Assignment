//
//  TwitterApi.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/28/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwiterApi {
    let baseUrl = URL(string: "https://api.twitter.com")
    let apiKey = "MYNMRB7dPXJrtcHobtbtE9G8Q"
    let apiSecret = "K7GkLjeNDF2wcrhu775dZuOsd6dbvoRybD8NDvZB1v309eHUpk"
    
    var requestToken: String?
    var accessToken: String?
    var twitterClient: BDBOAuth1SessionManager?
    var loginSuccess: (() -> Void)?
    var loginFailure: ((Error) -> Void)?
    
    static let shared = TwiterApi()
    
    private init() {
//        let defaults = UserDefaults.standard
//        let currentSession = defaults.object(forKey: "CurrentSession") as? Data
//        
//        if let currentSession = currentSession {
//            twitterClient = NSKeyedUnarchiver.unarchiveObject(with: currentSession) as? BDBOAuth1SessionManager
//        }
//        else {
            twitterClient = BDBOAuth1SessionManager(baseURL: baseUrl, consumerKey: apiKey, consumerSecret: apiSecret)
//        }
    }
    
    func getSession() -> BDBOAuth1SessionManager? {
        return twitterClient
    }
    
    func getRequestToken(success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)) {
        loginSuccess = success
        loginFailure = failure
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "dhvan85://oauth")!,
            scope: nil,
            success: { (credential: BDBOAuth1Credential?) in
                self.requestToken = credential?.token
                self.goToAuthorizePage()
            },
            failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
        })
    }
    
    func goToAuthorizePage() {
        let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken!)
        
        UIApplication.shared.open(authorizeUrl!)
    }
    
    func getAccessToken(queryString: String) {
        twitterClient?.fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: queryString),
            success: { (credential: BDBOAuth1Credential?) in
                self.accessToken = credential?.token
                self.loginSuccess?()
                
                self.getCurrentUser() {
                    User.currentUser = $0
                }
            },
            failure: { (error:Error?) in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }
    
    func getHomeTimeLine(success: @escaping ([NSDictionary]) -> Void) {
        _ = twitterClient?.get(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) in
                let tweetDictionary = response as? [NSDictionary]
                print(tweetDictionary)
                success(tweetDictionary!)
            },
            failure: { (task: URLSessionDataTask?, error: Error) in
                print("error: \(error.localizedDescription)")
        })
    }
    
    func getCurrentUser(callBack: @escaping (User?) -> Void) {
        var user: User?
        
        _ = twitterClient?.get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task:URLSessionDataTask, response: Any?) in
                let userDictionary = response as? NSDictionary
                user = User(dictionary: userDictionary!)
                
                callBack(user)
            },
            failure: { (task: URLSessionDataTask?, error: Error) in
                
                callBack(nil)
        })
    }
    
    func postNewTweet(text: String, success: @escaping (Tweet) -> Void) {
        let paras = ["status": text]
        
        _ = twitterClient?.post("1.1/statuses/update.json", parameters: paras, progress: nil, success: { (session: URLSessionDataTask, response: Any?) in
            let dic = response as? NSDictionary
            let tweet = Tweet(dictionary: dic!)
            
            success(tweet)
            }, failure: { (session: URLSessionDataTask?, error: Error) in
                print("error: \(error)")
        })
    }
}
