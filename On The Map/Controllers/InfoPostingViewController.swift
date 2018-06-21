//
//  StudentDetailViewController.swift
//  On The Map
//
//  Created by atao1 on 3/29/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class InfoPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    let otmTextDelegate = OTMTextFieldDelegate()
    @IBOutlet weak var worldIcon: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var URLTextField: UITextField!
    
    @IBOutlet weak var confirmLocation: UIButton!
    
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var addLocationMap: MKMapView!
    
    var addedValues: [(String,String)] = []
    var mapStringName: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    var actIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmLocation.isHidden = true
        addLocationMap.isHidden = true
        
        locationTextField.delegate = otmTextDelegate
        URLTextField.delegate = otmTextDelegate
        
        actIndicator = showActivityIndicatory(uiView: self.view)
        addLocationMap.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Add NavigationBar and cancel button
    func addNavBar(){
        let screenSize: CGRect = UIScreen.main.bounds
        
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,action: #selector(self.cancelAction))
        cancelButton.title = "Cancel"
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelButton
        navItem.title = "Add Location"
        navbar.setItems([navItem], animated: true)
        self.view.addSubview(navbar)
    }
    
    //MARK: Posts student to Parse server
    func postStudentLocation(restMethod: String){
        OTMClient.sharedInstance().taskForPostStudentLocation(restMethod: restMethod, mediaURLString: URLTextField.text!) {(error) in
            if let error = error{
                self.displayError(error.localizedDescription)
            }
        }
    }
    //MARK: search location query using MKLocalSearch
    
    func searchLocationRequest(completion: @escaping(_ finished: Bool) -> Void){
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        
        request.region = addLocationMap.region
        
        let search = MKLocalSearch(request: request)
      
        self.actIndicator.startAnimating()
        
        search.start {(response, error) in
            guard let response = response else{
                self.displayError("Could not find named location")
                self.actIndicator.stopAnimating()
                return
            }
            
        let item = response.mapItems.first
        
        OTMClient.sharedInstance().mapStringName = item!.name!
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (item?.placemark.coordinate)!
                
                let span = MKCoordinateSpanMake(0.075, 0.075) //zooms in on location
                let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            OTMClient.sharedInstance().longitude = String(describing: item!.placemark.coordinate.longitude)
            OTMClient.sharedInstance().latitude = String(describing: item!.placemark.coordinate.latitude)
            
                performUIUpdatesOnMain {// Displays annotated map location
                    
                    self.addLocationMap.addAnnotation(annotation)
                    self.addLocationMap.setRegion(region, animated: true)
                    self.setUI()
                    if !search.isSearching{
                        completion(true)
                    }
                
            }
        }
    }
    
    func showActivityIndicatory(uiView: UIView) -> UIActivityIndicatorView{
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.backgroundColor = UIColor.gray
        actInd.alpha = 0.5
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        self.view.addSubview(actInd)
        return actInd
    }
    
    //MARK: Hide find location button and textfields and show map with confirm button
    func setUI(){
        findLocation.isHidden = !findLocation.isHidden
        confirmLocation.isHidden = !confirmLocation.isHidden
        addLocationMap.isHidden = !addLocationMap.isHidden
        locationTextField.isHidden = !locationTextField.isHidden
        URLTextField.isHidden = !URLTextField.isHidden
        worldIcon.isHidden = !worldIcon.isHidden
    }
    
    //MARK: find location button
    @IBAction func findLocationAction(_ sender: Any) {
        if locationTextField.text == ""{
        }
        else{
            OTMClient.sharedInstance().taskForFindStudentLocationInfo() {(error) in
                if let error = error{
                    self.displayError(error.localizedDescription)
                }
            }
            setUIEnabled(false)
            searchLocationRequest(){(finished) in
                if finished{
                   self.view.endEditing(true)
                }
            }
            
            OTMClient.sharedInstance().taskForGetUserForPost() { (error) in
                
                if let error = error{
                    self.displayError(error.localizedDescription)
                }
            }
        }
        setUIEnabled(true)
    }
    
    //MARK: Post student info and return to previous view
    @IBAction func confirmLocationAction(_ sender: Any) {
       print(OTMClient.sharedInstance().objectID)
        if OTMClient.sharedInstance().objectID != ""{
            postStudentLocation(restMethod: "PUT")
        }else{

            postStudentLocation(restMethod: "POST")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Cancel Info post and pop back to previous student view
    
    @objc func cancelAction() {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard Notifications
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
        
        if view.frame.origin.y == 0{
            if URLTextField.convert(URLTextField.frame.origin, to: self.view).y < self.view.frame.size.height - getKeyboardHeight(notification){
                print(URLTextField)
            } else {

                view.frame.origin.y -= (getKeyboardHeight(notification) / 2.5)
                
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //Stop animating indicator after map finished rendering
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        actIndicator.stopAnimating()
    }
    
}

//MARK: Change alpha for Acticity Indicator
private extension InfoPostingViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        findLocation.isEnabled = enabled
        confirmLocation.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            findLocation.alpha = 1.0
            confirmLocation.alpha = 1.0
        } else {
            findLocation.alpha = 0.5
            confirmLocation.alpha = 0.5
        }
    }
    
}
