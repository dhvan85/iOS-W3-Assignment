//
//  PostViewController.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/30/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import UIKit

@objc protocol PostViewDelegate {
    @objc optional func timeLineChanged (_ sender: PostViewController)
}

class PostViewController: UIViewController {
    weak var delegate: PostViewDelegate?
    
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var replyTo: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = User.currentUser?.name
        screenNameLabel.text = User.currentUser?.screenName
        avatarImage.setImageWith((User.currentUser?.profileUrl)!)
        if let replyTo = replyTo {
            replyLabel.text = replyTo
        }
        else {
            replyLabel.isHidden = true
        }
        
        textView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet_Touch(_ sender: AnyObject) {
        TwiterApi.shared.postNewTweet(text: textView.text, replyTo: replyTo) { tweet in
            print(tweet)
            self.delegate?.timeLineChanged!(self)
            
            //self.performSegue(withIdentifier: "GoToList", sender: self)
            _ = self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancel_Touch(_ sender: AnyObject) {
//        self.performSegue(withIdentifier: "GoToList", sender: self)
        _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
