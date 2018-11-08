//
//  SignUpPageViewController.swift
//  BookWorm
//
//  A View Controller for the sign up process.
//  Held the page view controller code for all 4-5 pages of sign up information
//
//  Created by Hegde, Vikram on 6/21/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class SignUpPageViewController: UIPageViewController {

    // A list of all the view controllers for the Sign Up Process
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("WelcomePageViewOne"),
                self.newViewController("EmailPageViewTwo"),
                self.newViewController("PasswordPageViewThree"),
                /*self.newViewController("PhonePageViewFour"),*/
                self.newViewController("DonePageViewFive")]
    }()
    
    fileprivate func newViewController(_ name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(name)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        self.view.backgroundColor = UIColor.init(red:0.44, green:0.78, blue:0.95, alpha: 1.0)
        
        // Present the view controllers as view controllers that are crolled through
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true,completion: nil)
        }
        
        stylePageControl()
    }

}

// MARK: UIPageViewControllerDataSource

extension SignUpPageViewController: UIPageViewControllerDataSource {
    
    // MARK: Delagate Functions
    
    // For View Controller that comes before
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    // Similar to Linked List for next VC
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // How many slides for the dots to show on bottom
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    // What dot to highlight
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    // Present the stiled pages for manipulation during sign up process.
    fileprivate func stylePageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [type(of: self)])
        
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.backgroundColor = UIColor.init(red:0.44, green:0.78, blue:0.95, alpha: 1.0)
    }
}
