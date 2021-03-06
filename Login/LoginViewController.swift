//
//  LoginViewController.swift
//  Login
//
//  Created by Sahil Dhawan on 07/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
   
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    var heightContraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryView.layer.cornerRadius = 5
        self.entryView.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        activityindicator.isHidden = true
        fbLoginButton.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
        heightContraint = entryView.heightAnchor.constraint(equalToConstant: 80)
        heightContraint?.isActive  = true
        nameTextField.isHidden = true
        fbLoginButton.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid != nil
        {
            self.showAlert(msg: "/(FIRAuth.auth()?.currentUser?.uid")
            performSegue(withIdentifier: "Entry", sender: self)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        activityindicator.isHidden = false
        activityindicator.startAnimating()
        if segmentController.selectedSegmentIndex == 0
        {
            handleLogin()
        }
        else
        {
            handleRegister()
        }
    }
    
    func handleRegister()
    {
        guard let email = emailTextField.text,  let password = passwordTextField.text, let name = nameTextField.text else
        {
            print("Form Entries are not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil
            {
                self.showAlert(msg: "Invalid Regsteration Details!")
                return
            }
            guard let uid = user?.uid else
            {
                self.showAlert(msg: "Not a valid user id")
                return
            }
            let ref = FIRDatabase.database().reference(fromURL: "https://login-8d277.firebaseio.com/")
            let values = ["name": name, "email":email]
            let users = ref.child("users").child(uid)
            users.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil
                {
                    let errorString = err.debugDescription
                    print(errorString)
                    return
                }
                self.activityindicator.stopAnimating()
                self.performSegue(withIdentifier: "Entry", sender: self)
            })
        })
        

    }
    
    func handleLogin()
    {
        guard let email = emailTextField.text , let password = passwordTextField.text else
        {
            showAlert(msg: "Invalid Login Details!")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (FIRUser, error) in
            if error != nil
            {
                self.showAlert(msg: "Cant Login!")
            }
            self.activityindicator.stopAnimating()
            self.performSegue(withIdentifier: "Entry", sender: self)
        })
    }
    
    func showAlert(msg : String)
    {
        let alert = UIAlertController.init(title: "Login/Register", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Dismiss", style: .default, handler:nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentControllerPressed(_ sender: Any) {
        self.heightContraint?.isActive = false
        let value = segmentController.titleForSegment(at: segmentController.selectedSegmentIndex)
        registerButton.setTitle(value, for: .normal)
        entryView.translatesAutoresizingMaskIntoConstraints = false
        let height:CGFloat = segmentController.selectedSegmentIndex == 0 ? 80.00 : 120.00
        let hide = segmentController.selectedSegmentIndex == 0 ? true : false
        self.nameTextField.isHidden = hide
        self.fbLoginButton.isHidden = !hide
        self.heightContraint = entryView.heightAnchor.constraint(equalToConstant: height)
//        showAlert(msg: "\(height)")
        self.heightContraint?.isActive = true
        
        
        //MARK: clearing text field entries
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
         }
}
extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension LoginViewController : FBSDKLoginButtonDelegate
{
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        showAlert(msg: "Logged Out Successfully")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            showAlert(msg: "Canot Login")
        }
    }
}


