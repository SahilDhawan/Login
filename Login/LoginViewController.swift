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
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
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
    
    @IBAction func registerPressed(_ sender: Any) {
        
        
        guard let email = emailTextField.text,  let password = passwordTextField.text, let name = nameTextField.text else
        {
            print("Form Entries are not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil
            {
                self.showAlert(msg: "Password must be of 6 digits or greater")
                
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
                    print(err)
                    return
                }
                self.showAlert(msg: name + " registered successfully!")
            })
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
        
        let value = segmentController.titleForSegment(at: segmentController.selectedSegmentIndex)
        registerButton.setTitle(value, for: .normal)
        entryView.translatesAutoresizingMaskIntoConstraints = false
        let height:CGFloat = segmentController.selectedSegmentIndex == 0 ? 100.00 : 150.00
        let bool = segmentController.selectedSegmentIndex == 0 ? true : false
        self.nameTextField.isHidden = bool
        
        let heightContraint = entryView.heightAnchor.constraint(equalToConstant: height)
        heightContraint.isActive = true
        heightContraint.isActive = false



//        self.showAlert(msg: "height changed \(height)")
    }
}
extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

