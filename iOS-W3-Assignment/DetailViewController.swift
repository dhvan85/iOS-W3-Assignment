//
//  DetailViewController.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/30/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var viewTweet: Tweet?
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewTweet = viewTweet {
            avatarImage.setImageWith(URL(string: viewTweet.profileUrl!)!)
            screenNameLabel.text = viewTweet.userName
            userNameLabel.text = viewTweet.screenName
            statusLabel.text = viewTweet.text
            createTimeLabel.text = viewTweet.timeStampString
            retweetedLabel.text = String(viewTweet.retweetCount)
            favoriteLabel.text = String(viewTweet.favoritesCount)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PostViewController
        destination.replyTo = "@" + (viewTweet?.screenName)!
    }
    @IBAction func onBack_Touch(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
