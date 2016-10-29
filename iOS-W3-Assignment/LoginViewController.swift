//
//  LoginViewController.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/28/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        		// Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton_OnTouchUp(_ sender: AnyObject) {
        TwiterApi.shared.getRequestToken(
            success: {
                self.performSegue(withIdentifier: "ReturnFromLogin", sender: self)
            },
            failure: {
                error in
                print("error \(error)")
        })
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
