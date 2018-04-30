//
//  TableViewController.swift
//  On The Map
//
//  Created by atao1 on 3/28/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController{
    
    var addedValues: [String:String] = [:]
    var optionalValues: [String:String] = [:]
    
    var students: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //taskForGetStudentsMethod()
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskForGetStudentsMethod()
        print()
        
    }*/
    
    func taskForGetStudentsMethod(){
        
        let method = OTMClient.Constants.ParseMethods.parseGetMethod + "?limit=100&order=-updatedAt"
        addedValues[OTMClient.Constants.ParseKeys.ApiKey] = OTMClient.Constants.ParseHTTPHeaderFieldKeys.ApiKey
        addedValues[OTMClient.Constants.ParseKeys.AppID] = OTMClient.Constants.ParseHTTPHeaderFieldKeys.AppID
        
        OTMClient.sharedInstance().parseBuilder(method: method,addValues: addedValues,currentViewController: self) { (results, error) in
            
            self.students = StudentInformation.studentsFromResults((results!["results"] as? [[String : AnyObject]])!)
            //print(self.students)
            performUIUpdatesOnMain {
                    
               self.studentTableView!.reloadData()
                    
            }
        }
    }
}
    extension TableViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cellReuseIdentifier = "StudentTableViewCell"
            let student = students[(indexPath as NSIndexPath).row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
            print(student.firstName!)
            
            //cell?.textLabel!.text = "\(student.firstName) \(student.lastName)"
            cell!.textLabel!.text = "hello"
            //cell?.detailTextLabel!.text = student.mediaURL
            
            //cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
           
            return cell!
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(students.count)
            return 50
        }
        /*
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            controller.movie = movies[(indexPath as NSIndexPath).row]
            navigationController!.pushViewController(controller, animated: true)
        }*/
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    }

