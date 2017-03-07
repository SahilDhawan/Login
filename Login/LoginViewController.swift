//
//  LoginViewController.swift
//  Login
//
//  Created by Sahil Dhawan on 07/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var entryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryView.layer.cornerRadius = 5
        self.entryView.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

