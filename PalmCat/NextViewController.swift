//
//  NextViewController.swift
//  PalmCat
//
//  Created by Junsung Park on 2020/10/29.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import JSNavigationController

private extension Selector {
    static let pushThirdVC = #selector(NextViewController.pushThirdViewController)
    static let pushFourthVC = #selector(NextViewController.pushFourthViewController)
    static let popViewController = #selector(NextViewController.popViewController)
}
class NextViewController: JSViewController   {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.wantsLayer = true
                    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layer?.backgroundColor = NSColor(red: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, green: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, blue: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, alpha: 1).cgColor
        
    }
        override func viewDidAppear() {
            super.viewDidAppear()
            view.superview?.addConstraints(viewConstraints())
            
            // NavigationBar
            (navigationBarVC as? BasicNavigationBarViewController)?.backButton?.target = self
            (navigationBarVC as? BasicNavigationBarViewController)?.backButton?.action = .popViewController
         
    }
        
    
    
    override func viewWillDisappear() {
        view.superview?.removeConstraints(viewConstraints())
    }
    fileprivate func viewConstraints() -> [NSLayoutConstraint] {
        let left = NSLayoutConstraint(
            item: view, attribute: .left, relatedBy: .equal,
            toItem: view.superview, attribute: .left,
            multiplier: 1.0, constant: 0.0
        )
        let right = NSLayoutConstraint(
            item: view, attribute: .right, relatedBy: .equal,
            toItem: view.superview, attribute: .right,
            multiplier: 1.0, constant: 0.0
        )
        let top = NSLayoutConstraint(
            item: view, attribute: .top, relatedBy: .equal,
            toItem: view.superview, attribute: .top,
            multiplier: 1.0, constant: 0.0
        )
        let bottom = NSLayoutConstraint(
            item: view, attribute: .bottom, relatedBy: .equal,
            toItem: view.superview, attribute: .bottom,
            multiplier: 1.0, constant: 0.0
        )
        return [left, right, top, bottom]
    }
    @objc func pushThirdViewController() {
         if let destinationViewController = destinationViewControllers["ThirdVC"] {
             navigationController?.push(viewController: destinationViewController, animated: true)
         }
     }

     @objc func pushFourthViewController() {
         if let destinationViewController = destinationViewControllers["FourthVC"] {
             navigationController?.push(viewController: destinationViewController, animated: true)
         }
     }

     @objc func popViewController() {
         navigationController?.popViewController(animated: true)
     }
}
