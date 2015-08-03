//
//  LoginController.swift
//  collieclient
//
//  Created by Neil Betham on 8/2/15.
//  Copyright (c) 2015 wmtu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(sender: UIButton) {
        performSegueWithIdentifier("LoggedIn", sender: nil)
    }
    
}

