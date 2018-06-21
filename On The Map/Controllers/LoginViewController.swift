//
//  LoginViewController.swift
//  On The Map
//
//  Created by atao on 2/22/18.
//  Copyright © 2018 atao. All rights reserved.
//

import UIKit
import SafariServices


class LoginViewController: UIViewController, UITextFieldDelegate {

    let otmTextDelegate = OTMTextFieldDelegate()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var loginStatus: Bool = false
    var addedValues: [(String,String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = otmTextDelegate
        passwordTextField.delegate = otmTextDelegate
        loginStatus = false
        setUIEnabled(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        loginStatus = false
        setUIEnabled(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Udacity Login
    func udacityLogin(completion: @escaping(_ success: Bool, _ error: NSError?) -> Void){
        OTMClient.sharedInstance().login(username: usernameTextField.text!, password: passwordTextField.text!){(success, error) in
            completion(success, error)
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        setUIEnabled(false)
        udacityLogin() {(success, error) in/*{ (loginStatus) in*/
            performUIUpdatesOnMain {
                if success {
                    
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "navView")
                    self.view.endEditing(true)
                    self.present(controller!, animated: true, completion: nil)
                }else{
                    
                    self.displayError(error?.localizedDescription)
                    self.setUIEnabled(true)
                }
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func signUpUdacityButton(_ sender: Any) {
        
        let svc = SFSafariViewController(url: OTMClient.Constants.UdacityMethods.udacitySignUpURL)
        present(svc, animated: true, completion: nil)
    }

    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if view.frame.origin.y == 0 {

            view.frame.origin.y -= (getKeyboardHeight(notification) / 2.5)
            
        }
    }
}
private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
   
}
