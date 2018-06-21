//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by atao1 on 3/28/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class StudentTableViewController: UIViewController{
    
    var addedValues: [(String,String)] = []
    
    var students: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskForGetStudentsMethod()
    }
    
    //MARK: Load students to table
    func taskForGetStudentsMethod(){
        OTMClient.sharedInstance().taskForGetStudents() {(error) in
            if let error = error{
                self.displayError(error.localizedDescription)
            }
            self.students = StudentData.sharedInstance().studentDict
            performUIUpdatesOnMain {
                self.studentTableView.reloadData()
            }
        }
    }
}

//MARK: student table view delegate
extension StudentTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StudentCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell?.textLabel!.text = "\(String(describing: student.firstName!)) \(String(describing: student.lastName!))"
        if let mediaURL = student.mediaURL{
        cell?.detailTextLabel!.text = mediaURL
        }
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var studentURL = students[(indexPath as NSIndexPath).row].mediaURL!
        if studentURL.lowercased().hasPrefix("http") == false{
            studentURL = "https://".appending(studentURL)
        }
        let svc = SFSafariViewController(url: URL(string: studentURL)!)
        present(svc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //MARK: Display error alert
    
}

