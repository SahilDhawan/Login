//
//  MainViewController.swift
//  Login
//
//  Created by Sahil Dhawan on 07/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            handleSignOut()
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    @IBAction func signOutPressed(_ sender: Any) {
        handleSignOut()
    }
    func handleSignOut()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
        } catch let error
        {
            print(error.localizedDescription)
            return
        }
        self.performSegue(withIdentifier: "SignOut", sender: self)
    }
}
