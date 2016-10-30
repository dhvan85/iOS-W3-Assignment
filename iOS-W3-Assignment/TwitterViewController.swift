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
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadTweetData(_:)), for:UIControlEvents.valueChanged)

        
        
        initTweetTableView()
        loadTweetData(nil)
        
        // Do any additional setup after loading the view.
    }

    var refreshControl: UIRefreshControl!

    @IBAction func onNew_Touch(_ sender: AnyObject) {
    }
    private func initTweetTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.insertSubview(refreshControl, at: 0)
    }
    

    public func loadTweetData(_ refreshControl: UIRefreshControl?) {
        if refreshControl == nil {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        TwiterApi.shared.getHomeTimeLine() { dicts in
            self.tweetList = Tweet.tweetWithArray(dictionaries: dicts)
            self.tableView.reloadData()
         
            if refreshControl == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            else {
                self.refreshControl.endRefreshing()
            }
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToPostView") {
            let destination = segue.destination as! PostViewController
            destination.delegate = self
        }
        else if (segue.identifier == "GoToDetailView") {
            let destination = segue.destination as! UINavigationController
            let detailView = destination.viewControllers[0] as! DetailViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            if let indexPath = indexPath {
                detailView.viewTweet = self.tweetList?[indexPath.row]
            }
        }
    }

}
extension TwitterViewController: PostViewDelegate
{
    func timeLineChanged(_ sender: PostViewController) {
        loadTweetData(nil)
    }
}
