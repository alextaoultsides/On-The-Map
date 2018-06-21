//
//  OTMStudents.swift
//  On The Map
//
//  Created by atao1 on 3/9/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
//Student object
struct StudentInformation{
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let objectID: String?
    let mapString: String?
    let latitude: Double?
    let longitude: Double?
    let mediaURL: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    init(dictionary: [String:AnyObject]){
        
        createdAt = dictionary[OTMClient.Constants.JSONResponseKeys.createdAt] as? String
        firstName = dictionary[OTMClient.Constants.JSONResponseKeys.firstName] as? String
        lastName = dictionary[OTMClient.Constants.JSONResponseKeys.lastName] as? String
        objectID = dictionary[OTMClient.Constants.JSONResponseKeys.objectId] as? String
        mapString = dictionary[OTMClient.Constants.JSONResponseKeys.mapString] as? String
        latitude = dictionary[OTMClient.Constants.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[OTMClient.Constants.JSONResponseKeys.longitude] as? Double
        mediaURL = dictionary[OTMClient.Constants.JSONResponseKeys.mediaURL] as? String
        uniqueKey = dictionary[OTMClient.Constants.JSONResponseKeys.uniqueKey] as? String
        updatedAt = dictionary[OTMClient.Constants.JSONResponseKeys.updatedAt] as? String
    }
 
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}
