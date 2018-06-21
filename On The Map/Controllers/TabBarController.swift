//
//  TabBarController.swift
//  On The Map
//
//  Created by atao1 on 4/3/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "On The Map"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: Logout Button
    @IBAction func Logout(_ sender: Any) {
        OTMClient.sharedInstance().logoutSession() { (error) in
            if error != nil {
                self.displayError(error?.localizedDescription)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    //MARK: Refresh Button
    @IBAction func refresh(_ sender: Any) {
        let currentView = self.viewControllers?.first!
        currentView?.viewWillAppear(true)
    }
    
    //MARK: Pin new location
    @IBAction func addLocation(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "infoPostView") as! InfoPostingViewController
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        self.navigationItem.hidesBackButton = true
        present(controller, animated: true)
    }
    
}
