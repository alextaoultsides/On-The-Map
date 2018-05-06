//
//  LoginViewController.swift
//  On The Map
//
//  Created by atao on 2/22/18.
//  Copyright © 2018 atao. All rights reserved.
//

import UIKit
import SafariServices


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginStatusText: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var loginStatus: Bool = false
    var addedValues: [(String,String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginStatusText.text = ""
        loginStatus = false
        setUIEnabled(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.text = ""
        passwordTextField.text = ""
        loginStatusText.text = ""
        loginStatus = false
        setUIEnabled(true)
    }
    
    //MARK: Udacity Login
    func udacityLogin(completion: @escaping(_ success: Bool) -> Void){
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        let method = OTMClient.Constants.UdacityMethods.udacitySessionURL
        let methodType = "POST"
        
        addedValues.append((OTMClient.Constants.UdacityKeys.jsonMethod, OTMClient.Constants.UdacityHTTPHeaderFieldKeys.jsonAccept))
        addedValues.append((OTMClient.Constants.UdacityKeys.jsonMethod, OTMClient.Constants.UdacityHTTPHeaderFieldKeys.jsonContentType))
        
        let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        OTMClient.sharedInstance().taskBuilder(method: method, addValues: addedValues, restMethod: methodType, httpBody: httpBody, currentViewController: self){ (result, error) in
    
            let currentUser = result!["account"] as? [String : AnyObject]
            let currentSession = result!["session"] as? [String : AnyObject]
                
                OTMClient.sharedInstance().userID = currentUser!["key"]! as! String
                OTMClient.sharedInstance().sessionID = currentSession!["id"]! as! String
               
            completion(true)
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        setUIEnabled(false)
        udacityLogin() {(success) in/*{ (loginStatus) in*/
            performUIUpdatesOnMain {
                if success {
                    print()
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "navView")
                    
                    self.present(controller!, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signUpUdacityButton(_ sender: Any) {
        
        let svc = SFSafariViewController(url: OTMClient.Constants.UdacityMethods.udacitySignUpURL)
        present(svc, animated: true, completion: nil)
    }
}

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        loginStatusText.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}
