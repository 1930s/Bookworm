//
//  EmailAndPasswordSingleton.swift
//  BookWorm
//
//  A Singleton to hold the new user infomation for the account creation pages.
//
//  Created by Hegde, Vikram on 6/23/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class EmailAndPasswordSingleton: NSObject {
    var email : String = "WRONG"
    var password: String = "WRONG"
    var school : String = ""
    var yCoor: CGFloat = 0.0
    var logoHeight: CGFloat = 0.0
    static let sharedInstance = EmailAndPasswordSingleton()
    
    fileprivate override init(){
        
    }
    
    func newEmail(_ newEmail : String){
        email = newEmail
    }
    
    func newPassword(_ newPassword : String){
        password = newPassword
    }
    
    func newSchool(_ newSchool : String){
        school = newSchool
    }
    
    func getEmail() -> String! {
        return email
    }
    
    func getPassword() -> String! {
        return password
    }
    
    func getSchool() -> String! {
        return school
    }
}
