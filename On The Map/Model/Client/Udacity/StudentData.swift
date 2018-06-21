//
//  StudentData.swift
//  On The Map
//
//  Created by atao1 on 5/5/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation

class StudentData: NSObject{
    
    var studentDict: [StudentInformation] = [StudentInformation]()
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
}
