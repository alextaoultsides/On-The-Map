//
//  OTMClient.swift
//  On The Map
//
//  Created by atao1 on 2/26/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OTMClient: NSObject{
    
    
    let session = URLSession.shared
    
    var userID: String = ""
    var userFirstName: String = ""
    var userLastName: String = ""
    var httpBody: String = ""
    var sessionID: String = ""
    var objectID: String = ""
    var addedValues: [(String, String)] = []
    var mapStringName: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    
    override init() {
        super.init()
    }
    //General URL request task builder
    func taskBuilder(method: String, addValues: [(String,String)]? = nil, restMethod: String? = nil, httpBody: Data? = nil, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var request = URLRequest(url: URL(string: method)!)
        
        if let addValues = addValues{
           
            for (i,j) in addValues{
                request.addValue(i, forHTTPHeaderField: j)
            }
        }
        
        if let httpBody = httpBody{
            request.httpBody = httpBody
        }
        
        if let restMethod = restMethod{
            request.httpMethod = restMethod
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error{
                
                completionHandlerForPOST(nil, NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
                
            }else{
            
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 {
                   
                    if let data = data{
                        //print("No data was returned by the request!")
                        
                        if method.contains(OTMClient.Constants.UdacityMethods.udacityGetUserURL) || method.contains(OTMClient.Constants.UdacityMethods.udacitySessionURL){
                            
                            let range = Range(5..<data.count)
                            let newData = data.subdata(in: range) /* subset response data! */
                            
                            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
                        }
                        else{
                            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
                        }
                    }
                }else{
                    completionHandlerForPOST(nil, NSError(domain: "Login Request", code: 0, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: ((response as? HTTPURLResponse)?.statusCode)!)]))
                }
            }
        }
        task.resume()
    }
    
    //MARK: Perform Login
    func login(username: String, password: String, completion: @escaping(_ success: Bool, _ error: NSError?) -> Void){
        addedValues = []
        
        let method = OTMClient.Constants.UdacityMethods.udacitySessionURL
        let methodType = "POST"
        
        addedValues.append((OTMClient.Constants.UdacityKeys.jsonMethod, OTMClient.Constants.UdacityHTTPHeaderFieldKeys.jsonAccept))
        addedValues.append((OTMClient.Constants.UdacityKeys.jsonMethod, OTMClient.Constants.UdacityHTTPHeaderFieldKeys.jsonContentType))
        
        let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        OTMClient.sharedInstance().taskBuilder(method: method, addValues: addedValues, restMethod: methodType, httpBody: httpBody){ (result, error) in
            if let error = error{
                completion(false, error)
                
            } else{
                
                let currentUser = result!["account"] as? [String : AnyObject]
                let currentSession = result!["session"] as? [String : AnyObject]
                
                OTMClient.sharedInstance().userID = currentUser!["key"]! as! String
                OTMClient.sharedInstance().sessionID = currentSession!["id"]! as! String
                completion(true, nil )
            }
        }
    }
    //MARK: Get Clients name
    func taskForGetUserForPost(completion: @escaping(_ error: NSError?) -> Void){
        
        let method = OTMClient.Constants.UdacityMethods.udacityGetUserURL + OTMClient.sharedInstance().userID
        
        taskBuilder(method: method){ (results, error) in
            if let error = error{
                completion(error)
            }else{
            let userInfo = results!["user"] as? [String: AnyObject]
            
            OTMClient.sharedInstance().userLastName = userInfo!["last_name"] as! String
            
            OTMClient.sharedInstance().userFirstName = userInfo!["first_name"] as! String
            
            completion(nil)
            }
        }
    }
    //MARK: Post Student
    func taskForPostStudentLocation(restMethod: String, mediaURLString: String, completion: @escaping(_ error: NSError?) -> Void){
        addedValues = []
        
        var method = OTMClient.Constants.ParseMethods.parseGetMethod

        if restMethod == "PUT" {//Put student if already exists.
            method = method + "/" + OTMClient.sharedInstance().objectID
        }
        
        addedValues.append((OTMClient.Constants.ParseKeys.ApiKey,  OTMClient.Constants.ParseHTTPHeaderFieldKeys.ApiKey))
        addedValues.append((OTMClient.Constants.ParseKeys.AppID,  OTMClient.Constants.ParseHTTPHeaderFieldKeys.AppID))
        addedValues.append((OTMClient.Constants.ParseKeys.jsonMethod, OTMClient.Constants.ParseHTTPHeaderFieldKeys.jsonMethod))
        
        var mediaURL = mediaURLString
        
        if mediaURL.contains("http") == false{
            mediaURL = "https://\(mediaURL)"
        }
        
        let posthttpBody = "{\"uniqueKey\": \"\(OTMClient.sharedInstance().userID)\", \"firstName\": \"\(OTMClient.sharedInstance().userFirstName)\", \"lastName\": \"\(OTMClient.sharedInstance().userLastName)\",\"mapString\": \"\(mapStringName)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(OTMClient.sharedInstance().latitude), \"longitude\": \(OTMClient.sharedInstance().longitude)}".data(using: .utf8)
        
        OTMClient.sharedInstance().taskBuilder(method: method, addValues: addedValues, restMethod: restMethod, httpBody: posthttpBody){ (results, error) in
            if let error = error{
                completion(error)
            }
        }
    }
    
    //MARK: Get Method for Parse info to get objectid
    func taskForFindStudentLocationInfo(completion: @escaping(_ error: NSError?) -> Void){
        addedValues = []
        let method = "\(OTMClient.Constants.ParseMethods.parseGetMethod)?where=%7B%22uniqueKey%22%3A%22\(OTMClient.sharedInstance().userID)%22%7D"
        
        addedValues.append((OTMClient.Constants.ParseKeys.AppID, OTMClient.Constants.ParseHTTPHeaderFieldKeys.AppID))
        addedValues.append((OTMClient.Constants.ParseKeys.ApiKey, OTMClient.Constants.ParseHTTPHeaderFieldKeys.ApiKey))
        
        taskBuilder(method: method, addValues: addedValues){ (results, error) in
            if let error = error{
                completion(error)
            }else{
                let student = results!["results"] as? [[String : AnyObject]]!
                
                OTMClient.sharedInstance().objectID = (student![0]["objectId"] as? String)!
                completion(nil)
            }
        }
    }
    //MARK: Get 100 most recent Students 
    func taskForGetStudents(completion: @escaping(_ error: NSError?) -> Void){
        addedValues = []
        
        let method = OTMClient.Constants.ParseMethods.parseGetMethod + "?limit=100&order=-updatedAt"
        addedValues.append((OTMClient.Constants.ParseKeys.ApiKey, OTMClient.Constants.ParseHTTPHeaderFieldKeys.ApiKey))
        addedValues.append((OTMClient.Constants.ParseKeys.AppID, OTMClient.Constants.ParseHTTPHeaderFieldKeys.AppID))
        
        OTMClient.sharedInstance().taskBuilder(method: method,addValues: addedValues, restMethod: nil) { (results, error) in
            if let error = error{
                completion(error)
            }else{
                StudentData.sharedInstance().studentDict = StudentInformation.studentsFromResults((results!["results"] as? [[String : AnyObject]])!)
                completion(nil)
            }
        }
    }
    
    //MARK: conversion of JSON to usable data
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //MARK: delete network login session
    func logoutSession(completion: @escaping(_ error: NSError?) -> Void){
        
        var request = URLRequest(url: URL(string: OTMClient.Constants.UdacityMethods.udacitySessionURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(error as NSError)
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}
