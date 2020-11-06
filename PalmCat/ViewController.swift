//
//  ViewController.swift
//  PalmCat
//
//  Created by Junsung Park on 2020/10/28.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import JSNavigationController
import WebKit
import OHMySQL
/*
private extension Selector {
    static let pushToNextViewController = #selector(ViewController.pushToNextViewController)
    static let popViewController = #selector(ViewController.popViewController)
}
 */
class ViewController: NSViewController , WKUIDelegate{
    
    @IBOutlet weak var webView:WKWebView!

    @IBOutlet weak var button:NSButton!
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.title = "PalmCat"

        preferredContentSize = view.frame.size
        
        self.view.wantsLayer = true
             
        view.translatesAutoresizingMaskIntoConstraints = false
             
        self.view.layer?.backgroundColor = NSColor(red: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, green: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, blue: CGFloat(arc4random_uniform(63)) / 63.0 + 0.5, alpha: 1).cgColor
        
      
     //   testMySQL()

          
    }
   @objc func timerAction(){
      
      var fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "g1", ofType: "html", inDirectory:"www")!)
    
    
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        timer.invalidate()
    
   }
    override func viewDidAppear() {
        super.viewDidAppear()
        view.superview?.addConstraints(viewConstraints())
    

        // NavigationBar
        /*
        (navigationBarVC as? BasicNavigationBarViewController)?.backButton?.target = self
        (navigationBarVC as? BasicNavigationBarViewController)?.backButton?.action = .popViewController
        (navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.target = self
        (navigationBarVC as? BasicNavigationBarViewController)?.nextButton?.action = .pushToNextViewController
       // newDoc()
          */
       // testKey()
    
        loadIndex()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        
        //keyboardKeyDown(key: 0x7A)
        //keyboardKeyUp(key: 0x7A)
    }
    override func touchesBegan(with event: NSEvent) {
        
    }
    func testMySQL()
    {
        /*
         host: palmcat.co.kr
         port: 3306
         url: palmcat.co.kr:3306
         id: dev01
         passward: palmcatDEV0!`
         */
        let user = OHMySQLUser(userName: "dev01", password: "palmcatDEV0!", serverName: "palmcat.co.kr", dbName: "jcp_db", port: 3306, socket: "")
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        
        
        let context = OHMySQLQueryContext()
        context.storeCoordinator = coordinator
        OHMySQLContainer.shared.mainQueryContext = context
    }
    func loadIndex()
    {
        
        
     //   Bundle.main.path.path(forResource, "index", ofType:"ext", inDirectory: "www")
        var fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "index", ofType: "html", inDirectory:"www")!)
        /*
        
          do {
                        fileURL = try fileURLForBuggyWKWebView8(fileURL: fileURL)
                        webView.load(URLRequest(url: fileURL))
                    } catch let error as NSError {
                        print("Error: " + error.debugDescription)
                  
        }
 */
              webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        
        
/*
          if #available(iOS 9.0, *) {
              // iOS9 and above. One year later things are OK.
              webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
          } else {
              // iOS8. Things can (sometimes) be workaround-ed
              //   Brave people can do just this
              //   fileURL = try! pathForBuggyWKWebView8(fileURL: fileURL)
              //   webView.load(URLRequest(url: fileURL))
              do {
                  fileURL = try fileURLForBuggyWKWebView8(fileURL: fileURL)
                  webView.load(URLRequest(url: fileURL))
              } catch let error as NSError {
                  print("Error: " + error.debugDescription)
              }
          }
 */
    }
    func fileURLForBuggyWKWebView8(fileURL: URL) throws -> URL {
        // Some safety checks
        if !fileURL.isFileURL {
            throw NSError(
                domain: "BuggyWKWebViewDomain",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL.", comment:"")])
        }
        try! fileURL.checkResourceIsReachable()

        // Create "/temp/www" directory
        let fm = FileManager.default
        let tmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        try! fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)

        // Now copy given file to the temp directory
        let dstURL = tmpDirURL.appendingPathComponent(fileURL.lastPathComponent)
        let _ = try? fm.removeItem(at: dstURL)
        try! fm.copyItem(at: fileURL, to: dstURL)

        // Files in "/temp/www" load flawlesly :)
        return dstURL
    }
    func testKey()
       {
           let eventSource = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
           let key: CGKeyCode = 0x7a     // virtual key for 'a'
           let eventDown = CGEvent(keyboardEventSource: eventSource, virtualKey: key, keyDown: true)
           let eventUp = CGEvent(keyboardEventSource: eventSource, virtualKey: key, keyDown: false)
           let location = CGEventTapLocation.cghidEventTap
           eventDown!.post(tap: location)
           eventUp!.post(tap: location)
        print("key \(key) is down")

       }
    func keyboardKeyDown(key: CGKeyCode) {

            let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
            event?.post(tap: CGEventTapLocation.cghidEventTap)
            print("key \(key) is down")
        }

    // release the button
    func keyboardKeyUp(key: CGKeyCode) {
            let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
            event?.post(tap: CGEventTapLocation.cghidEventTap)
            print("key \(key) is released")
        }
    func newDoc()
       {
           let cmd_c_D = CGEvent(keyboardEventSource: nil, virtualKey: 0x2D, keyDown: true); // 0x08 is C cmd-c down key code
           cmd_c_D!.flags = CGEventFlags.maskCommand;
        //   CGEventPost(CGEventTapLocation.CGHIDEventTap, cmd-c-D);

           cmd_c_D!.post(tap: CGEventTapLocation.cghidEventTap)
           
           
           
           let cmd_c_U = CGEvent(keyboardEventSource: nil, virtualKey: 0x2D, keyDown: false); // cmd-c up
           cmd_c_U!.flags = CGEventFlags.maskCommand;
           cmd_c_U!.post(tap: CGEventTapLocation.cghidEventTap);
       }
    override func viewDidDisappear() {
        view.superview?.removeConstraints(viewConstraints())
    }
    
    @IBAction func Next(param:Int)
    {
   //     performSegue(withIdentifier: "exec_next", sender: nil)
       // self.navigationController?.pushViewController(NextViewController(), animated: true)
    }
    @IBAction func pushAction(_ sender: AnyObject) {
  //         self.navigationController?.pushViewController(ViewController(), animated: true)
//
      //      performSegue(withIdentifier: "exec_next", sender: nil)
        /*
        if let destinationViewController = destinationViewController {
                navigationController?.push(viewController: destinationViewController, animated: true)
            }
 */
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
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
    /*
    @objc func pushToNextViewController() {
        if let destinationViewController = destinationViewController {
            navigationController?.push(viewController: destinationViewController, animated: true)
        }
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
 */
}

