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
class ViewController: NSViewController , WKUIDelegate,WKNavigationDelegate{
    
    @IBOutlet weak var webView:WKWebView!

    @IBOutlet weak var button:NSButton!
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        preferredContentSize = view.frame.size
        
        self.view.wantsLayer = true
             
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let webConfiguration = WKWebViewConfiguration()
        // Fix Fullscreen mode for video and autoplay
        webConfiguration.preferences.javaScriptEnabled = true
           
        webConfiguration.allowsAirPlayForMediaPlayback = true

        //webView.configuration = webConfiguration
        webView.navigationDelegate = self
        
     //   let userController: WKUserContentController = WKUserContentController()
          
      //  let userScript: WKUserScript = WKUserScript(source: "test01()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
      //  userController.addUserScript(userScript)
          
      //  userController.add(self, name: Constants.callBackHandlerKey)
        // let configuration = WKWebViewConfiguration()
      //   configuration.userContentController = userController
        

        let uuid = UUID().uuidString
        let userID = UserDefaults.standard.string(forKey: "USER_ID")
        if(userID == nil || userID?.count == 0)
        {
            UserDefaults.standard.set("uuid", forKey: "USER_ID")
            UserDefaults.standard.synchronize()

        }
      
       
        testMySQL()
        
        
        let query = OHMySQLQueryRequestFactory.select("userlist", condition: nil)
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        for dict in ( response as! NSArray)
       {
      //     print(dict)
       }
      
        
        let query2 = OHMySQLQueryRequestFactory.select("applist", condition: nil)
        
        let response2 = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query2)
        
        for dict in ( response2 as! NSArray)
        {
            print(dict)
        }
       
      
        

          
    }
    override func viewWillAppear() {
        self.view.window?.center()
     

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        if navigationAction.navigationType == WKNavigationType.linkActivated {
        
            if(navigationAction.request.url?.absoluteString.contains("login.html") == true)
            {
                let jsString0 = "document.getElementsByTagName('input')[0].value"
                let jsString1 = "document.getElementsByTagName('input')[1].value"

                        
                webView.evaluateJavaScript(jsString0) { (result, error) in
                
                    if let result = result {
                    
                        UserDefaults.standard.set(result, forKey: "USER_ID")
                       
                        webView.evaluateJavaScript(jsString1) { (result, error) in
                                      
                        
                            if let result = result {
                            
                                UserDefaults.standard.set(result, forKey: "USER_PASSWORD")
                                UserDefaults.standard.synchronize()
                                               
                                print(result)
                                
                            }
                                      
                        }
                    }
                }
            }
            if(navigationAction.request.url?.absoluteString.contains("ustart.html") == true)
            {
                
                decisionHandler(.allow)
                startUsageType()
                
            }
            if(navigationAction.request.url?.absoluteString.contains("back.html") == true)
            {
               
                   decisionHandler(.allow)
                   backIntro()
               
            }
            if(navigationAction.request.url?.absoluteString.contains("lefthand.html") == true)
            {
               
                   decisionHandler(.allow)
                   setHandTypeL()
               
            }
            if(navigationAction.request.url?.absoluteString.contains("righthand.html") == true)
            {
               
                   decisionHandler(.allow)
                   setHandTypeR()
               
            }
            if(navigationAction.request.url?.absoluteString.contains("env.html") == true)
            {
             
                 decisionHandler(.allow)
                 setUserEnvironment()
             
            }
            //setUserEnvironment
            //
            //http://NO4.html
            /*
            let list = navigationAction.request.url?.absoluteString.components(separatedBy:  "?")
                               
            if(list!.count > 1)
            {
                var strWork  = list![1]
                
            }

       
            decisionHandler(.allow)
            
            
            return
 */
 
        }
        else if navigationAction.navigationType == WKNavigationType.formSubmitted
        {
            print("")
        }
        else
        {
            print(navigationAction.navigationType)
        }
//if navigationAction.navigationType == WKNavigationType.linkActivated

          decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //ready to be processed
        let title = webView.title
        if( title == "c2")
        {
            print(title)
         
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            
        }
        
    }
    @objc func timerAction(){
             
        
        var fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.16", ofType: "html", inDirectory:"www/cup-v03-m")!)
        
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        
        
        timer.invalidate()
        
    }
 
    override func viewDidAppear() {
        super.viewDidAppear()
        view.superview?.addConstraints(viewConstraints())
    

    
        loadIntro()

        NSWorkspace.shared.launchApplication("Pero")
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
        let user = OHMySQLUser(userName: "dev01", password: "palmcatDEV0!", serverName: "106.10.42.103", dbName: "jcp_db", port: 3306, socket: nil)
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        
        
        let context = OHMySQLQueryContext()
        context.storeCoordinator = coordinator
        OHMySQLContainer.shared.mainQueryContext = context
    }
    func loadIntro()
    {
        

        let userID = UserDefaults.standard.string(forKey: "USER_ID")
        if(userID == nil || userID?.count == 0)
        {
            
            let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.1", ofType: "html", inDirectory:"www/ucp-v03-home")!)
              
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            
        }
        else
        {
            let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.3", ofType: "html", inDirectory:"www/ucp-v03-g")!)
              
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)

        }
          

    }
    func startUsageType()
    {
       
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.4", ofType: "html", inDirectory:"www/ucp-v03-g")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
    func backIntro()
    {
       
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.3", ofType: "html", inDirectory:"www/ucp-v03-g")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
    func setHandTypeL()
    {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.5", ofType: "html", inDirectory:"www/ucp-v03-g")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)

    }
    func setHandTypeR()
    {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.5", ofType: "html", inDirectory:"www/ucp-v03-g")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)

    }
    func setUserEnvironment()
    {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.8", ofType: "html", inDirectory:"www/ucp-v03-f")!)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)

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



extension URLRequest {
    var isHttpLink: Bool {
        return self.url?.scheme?.contains("#") ?? false
    }
}

