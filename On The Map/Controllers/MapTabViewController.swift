//
//  MapTabViewController.swift
//  On The Map
//
//  Created by atao1 on 3/15/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapTabViewController: UIViewController, MKMapViewDelegate{

    
    @IBOutlet weak var studentMapView: MKMapView!
    
    var addedValues: [(String, String)] = []
    var optionalValues: [String:String] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskForGetStudentsMethod()
    }
    //MARK: MapKit search
    func taskForGetStudentsMethod() {
        OTMClient.sharedInstance().taskForGetStudents() {(error) in
            
            if let error = error {
                self.displayError(error.localizedDescription)
            } else {
                let students = StudentData.sharedInstance().studentDict
                
                var annotations = [MKPointAnnotation]()
            
                for dictionary in students {
                    
                    
                    if dictionary.latitude == nil{
                        
                    } else {
                    
                        let lat = CLLocationDegrees(dictionary.latitude! )
                        let long = CLLocationDegrees(dictionary.longitude!)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                         let first = dictionary.firstName!
                        
                        let last = dictionary.lastName!
                        let mediaURL = dictionary.mediaURL
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        annotations.append(annotation)
                        }
                }
                performUIUpdatesOnMain {
                    self.studentMapView.addAnnotations(annotations)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var finalURL: String = ""
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if !toOpen.contains("http"){
                    finalURL = "https://".appending(toOpen)
                }else{
                    finalURL = toOpen
                }
                app.open(URL(string: finalURL)!, completionHandler: nil)
            }
        }
    }
}
