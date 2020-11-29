//
//  UdacityConstants.swift
//  On The Map
//
//  Created by atao1 on 2/26/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation


extension OTMClient {
    
    struct Constants {
        
        struct UdacityMethods {
            static let udacitySignUpURL = URL(string: "https://www.udacity.com/account/auth#!/signup")!
            static let udacitySessionURL = "https://www.udacity.com/api/session"
            static var udacityGetUserURL = "https://www.udacity.com/api/users/"
        }
        struct ParseMethods{
            static let parseGetMethod = "https://parse.udacity.com/parse/classes/StudentLocation"
            static let parsePostMethod = "https://parse.udacity.com/parse/classes/StudentLocation"
        }
        struct ParseKeys{
            static let AppID = "your ID"
            static let ApiKey = "your API"
            static let jsonMethod = "application/json"
        }
        struct ParseHTTPHeaderFieldKeys{
            static let AppID = "X-Parse-Application-Id"
            static let ApiKey = "X-Parse-REST-API-Key"
            static let jsonMethod = "Content-Type"
        }
        
        struct UdacityKeys{
            static let jsonMethod = "application/json"
        }
        
        struct UdacityHTTPHeaderFieldKeys{
            static let jsonAccept = "Accept"
            static let jsonContentType = "Content-Type"
        }
        
        struct JSONResponseKeys{
            static let createdAt = "createdAt"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let objectId = "objectId"
            static let uniqueKey = "uniqueKey"
            static let updatedAt = "updatedAt"
        }
        
        
    }

}
