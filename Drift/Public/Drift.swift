//
//  File.swift
//  Driftt
//
//  Created by Eoin O'Connell on 21/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import Foundation

@objc
open class Drift: NSObject {

    
    /**
     Initialise Driftt SDK with an embed ID.
     
     - Parameter embedId: Embed ID found in Driftt Settings
     
    */
    @objc open class func setup(_ embedId: String) {
        DriftManager.retrieveDataFromEmbeds(embedId)
        DriftManager.createTemporaryDirectory()
    }
    
    /**
     Registers Users with drift. Should be completed after user login
    
     - Parameter userId: The User id from your database. Will be the same as on driftt.
     
    */
    open class func registerUser(_ userId: String, email: String, completion: ((Int?)->())? = nil) {
      DriftManager.registerUser(userId, email: email) { (userId) in
        completion?(userId)
      }
    }
    
    /**
     Logs users out of Drift
     */
    @objc open class func logout() {
        DriftManager.logout()
    }
    
    /**

     This mode enables you to see the output logs of drift for debug purposes
     This will also stop dismissing announcements from being sticky so you can see the same announcement over and over
     
     - parameter debug: A Bool indicating if debug mode should be enabled or not
     
    */
    @objc open class func debugMode(_ debug:Bool) {
        DriftManager.debugMode(debug)
    }
    
    /**

     This will show a list of Drift conversations for the current user
     
     */
    @objc open class func showConversations() {
        DriftManager.showConversations()
    }
    
}
