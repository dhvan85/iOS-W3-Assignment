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
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet_Touch(_ sender: AnyObject) {
        TwiterApi.shared.postNewTweet(text: textView.text) { tweet in
            print(tweet)
            self.delegate?.timeLineChanged!(self)
            
            _ = self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancel_Touch(_ sender: AnyObject) {
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
