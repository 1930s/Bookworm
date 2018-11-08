//
//  EmailAndPasswordSingleton.swift
//  BookWorm
//
//  A singleton to store information about
// the constraints of an object.
//
//  Created by Hegde, Vikram on 6/23/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class ConstraintsSingleton: NSObject {
    var email : String = "WRONG"
    var password: String = "WRONG"
    var yCoor: CGFloat = 0.0
    var logoHeight: CGFloat = 0.0
    static let sharedInstance = ConstraintsSingleton()
    
    fileprivate override init(){
    }
    
    func newYCoor(_ newYCoor: CGFloat){
        yCoor = newYCoor
    }
    
    func getYCoor() -> CGFloat{
        return yCoor
    }
    
    func newLogoHeight(_ newLogoHeight: CGFloat){
        logoHeight = newLogoHeight
    }
    
    func getLogoHeight() -> CGFloat{
        return logoHeight
    }
}
