//
//  TwitterViewController.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/28/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import UIKit
import MBProgressHUD

class TwitterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweetList: [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTweetTableView()
        loadTweetData()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onNew_Touch(_ sender: AnyObject) {
    }
    private func initTweetTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    

    public func loadTweetData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        TwiterApi.shared.getHomeTimeLine() { dicts in
            self.tweetList = Tweet.tweetWithArray(dictionaries: dicts)
            self.tableView.reloadData()
            
             MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellId") as! TweetTableViewCell
        
        if let tweetList = tweetList {
            cell.userNameLabel.text = tweetList[indexPath.row].userName
            cell.avatarImage.setImageWith(URL(string: tweetList[indexPath.row].profileUrl!)!)
            cell.contentLabel.text = tweetList[indexPath.row].text
            cell.createdTimeLabel.text = tweetList[indexPath.row].timeStampString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tweetList == nil {
            return 0
        }
        
        return (tweetList?.count)!
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
extension TwitterViewController: PostViewDelegate
{
    func timeLineChanged(_ sender: PostViewController) {
        loadTweetData()
    }
}
