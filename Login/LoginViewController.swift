//
//  LoginViewController.swift
//  Login
//
//  Created by Sahil Dhawan on 07/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBOutlet weak var entryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryView.layer.cornerRadius = 5
        self.entryView.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        guard let email = emailTextField.text,  let password = passwordTextField.text, let name = nameTextField.text else
        {
            print("Form Entries are not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil
            {
                self.showError(msg: "Password must be 6 digits or greater")
                
                return
            }
            let ref = FIRDatabase.database().reference(fromURL: "https://login-8d277.firebaseio.com/")
            let values = ["name": name, "email":email]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil
                {
                    print(err)
                    return
                }
                self.showError(msg: "Login Successfull")
                
            })
        })
        
    }
    func showError(msg : String)
    {
        let alert = UIAlertController.init(title: "Login/Register", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Dismiss", style: .default, handler:nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }

}
extension LoginViewController : UITextFieldDelegate
{
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

