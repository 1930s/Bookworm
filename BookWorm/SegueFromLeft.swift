//
//  SegueFromLeft.swift
//  BookWorm
//
//  A segue from the other non-default directions
//
//  Created by Hegde, Vikram on 7/7/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },completion: { finished in
                src.present(dst, animated: false, completion: nil)
            }
        )
    }
}

class SegueFromRight: UIStoryboardSegue {
    
    override func perform()
    {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(),animations: {
                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },completion: { finished in
                src.present(dst, animated: false, completion: nil)
            }
        )
    }
}
