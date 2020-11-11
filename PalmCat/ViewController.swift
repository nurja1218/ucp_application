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
    
    var handType:String = ""
    var usageType2:String = ""
    var usageType3:String = ""
    var usageType4:String = ""
    
    var usageType:String = ""
    
    var user:Users!

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
        

    //    let uuid = UUID().uuidString
      
       
        getServerUserList()
        getServerAppList()
        getServerCommand()
        
      /*
        
        let query2 = OHMySQLQueryRequestFactory.select("user_b", condition: nil)
        
        let response2 = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query2)
        
        for dict in ( response2 as! NSArray)
        {
            print(dict)
        }
 */
 
          
    }
   
    func getServerUserList()
    {
    
        connectDB()
        

        let query = OHMySQLQueryRequestFactory.select("userlist", condition: nil)
        
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        for _dict in ( response! as! NSArray)
        {
            let dict:[String:Any] = _dict as! [String:Any]
            let answer  = dict["answer"] as? String
            
            let id  = dict["id"] as? Int
            
            let type  = dict["user_TypeName"] as? String
            
            CoreDataManager.shared.saveUserList(type: type!, id: id!,  answer:answer!,  onSuccess: { (success) in
                
                print("success")
            })
            
            
        }
              
    }
    func getUserType(condition:String)
    {
    
        connectDB()
        
        let c = "app_Name =" + "'" + condition + "'"
        
        let query = OHMySQLQueryRequestFactory.select(self.user.type!, condition: c )
        
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        if ( response == nil || (response! as! NSArray).count == 0)
        {
            return
        }
        var option = String()
        option.append("<option>")
        option.append("Select one...")
        option.append("</option>")
            
        for _dict in ( response! as! NSArray)
        {
            
            let dict:[String:Any] = _dict as! [String:Any]
            
            let app_Name  = dict["app_Name"] as? String
            let command  = dict["command"] as? String
            let gesture  = dict["gesture"] as? String
            
               
            let shortcut  = dict["shortcut"] as? String
              
            let touch  = dict["touch"] as? String

               
            option.append("<option>")
            option.append(command!)
            option.append("</option>")
                                           
                              
              
        
        }
        
        let script = "document.getElementsByTagName('select')[1].innerHTML = " + "'" + option + "'"
        
         
        webView.evaluateJavaScript(script) { (result, error) in
                      
                          
                      
        }
    }
    func getServerAppList()
    {
    
        connectDB()
        

        let query = OHMySQLQueryRequestFactory.select("applist", condition: nil)
        
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        for _dict in ( response! as! NSArray)
        {
            let dict:[String:Any] = _dict as! [String:Any]
            let group  = dict["app_GroupName"] as? String
            
            
            let name  = dict["app_Name"] as? String
            
            let type  = dict["app_TypeName"] as? String
            let process  = dict["process_Name"] as? String
            
            var etc  = dict["etc"] as? String
            if(etc == nil)
            {
                etc = ""
            }
                     
            CoreDataManager.shared.saveAppList(name: name!, type: type!, group: group!, process: process!, etc: etc!, onSuccess: { (success) in
                
                print("success")
            })
            
            
        }
              
    }
    func getServerCommand()
     {
     
         connectDB()
         

         let query = OHMySQLQueryRequestFactory.select("command", condition: nil)
         
         let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
         
         for _dict in ( response! as! NSArray)
         {
             let dict:[String:Any] = _dict as! [String:Any]
            let group  = dict["app_GroupName"] as? String
            let shortcut = dict["shortcut"] as? String
            var gesture = dict["gesture"] as? String
            let type = dict["app_TypeName"] as? String
            
            if(gesture == nil)
            {
                gesture = ""
            }
                  
            print(dict)
            
            CoreDataManager.shared.saveCommand(name: group!, type: type!, group: group!, gesture: gesture!, shortcut: shortcut!, onSuccess: { (success) in
                           
                print("success")
                       
            })
             
         }
               
     }
    
    override func viewWillAppear() {
        self.view.window?.center()
     

    }
    func Alert(question: String, text: String)  {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
      //  alert.addButton(withTitle: "Cancel")
        //return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    func processSignUp()
    {
     
        let countryS = "var index = document.getElementsByTagName('select')[0].selectedIndex; document.getElementsByTagName('option')[index].value"
          
        let nameS = "document.getElementsByTagName('input')[0].value"
        
        let idS = "document.getElementsByTagName('input')[1].value"
     
        let passS0 = "document.getElementsByTagName('input')[2].value"
         
        let passS1 = "document.getElementsByTagName('input')[3].value"
              
        let checkS1 = "document.getElementsByTagName('input')[4].value"
              
        webView.evaluateJavaScript(nameS) { (result, error) in
        
            if let name = result {
            
                self.webView.evaluateJavaScript(idS) { (result, error) in
                
                    if let email = result {
                    
                      self.webView.evaluateJavaScript(passS0) { (result, error) in
                      
                          if let pass0 = result {
                          
                            self.webView.evaluateJavaScript(passS1) { (result, error) in
                                               
                            
                                if let pass1 = result {
                                
                                    self.webView.evaluateJavaScript(checkS1) { (result, error) in
                                                                              
                                                           
                                                            
                                        if let check = result {
                                        
                                      //      let checkPrivacy = check as! Bool
                                            if((name as? String)!.count > 0 && (email as? String)!.count > 0 &&
                                                (pass0 as? String)!.count > 0 && (pass1 as? String)!.count > 0 )
                                            {
                                                if( pass0 as? String == pass1 as? String)
                                                {
                                                    if((check as! String) == "on")
                                                    {
                                                        // Success
                                                        /*
                                                       
                                                        */
                                                         self.webView.evaluateJavaScript(countryS) { (result, error) in
                                                                      
                                                             if let country = result
                                                            {
                                                                if( (country as? String)!.count > 0)
                                                                {
                                                                    CoreDataManager.shared.saveUser(name: name as! String, id: email as! String, password: pass0 as! String, country: (country as? String)!,answer: "", type:"", onSuccess:{ (success) in
                                                                             
                                                                        
                                                                        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.3", ofType: "html", inDirectory:"www/ucp-v03-g")!)
                                                                        
                                                                        self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                                                                        
                                                                                                                  
                                                                    })
                                                                }
                                                                else
                                                                {
                                                                    // fail
                                                                }
                                                                
                                                            }
                                                                                                              
                                                        }
                                                        
                                                                                                     
                                                    }
                                                    else
                                                    {
                                                        //fail
                                                    }
                                               
                                                }
                                                else
                                                {
                                                    // fail
                                                }
                                            }
                                           
                                            
                                        }
                                        
                                    }
                                
                                }
                                                   
                                            
                            }
                              
                          }
                          
                      }

                        
                    }
                    
                }
            }
            
        }
    }
    func processLogin()
    {
       
        let jsString0 = "document.getElementsByTagName('input')[0].value"
        
        let jsString1 = "document.getElementsByTagName('input')[1].value"
      
        
        webView.evaluateJavaScript(jsString0) { (result, error) in
        
            if let id = result {
            
                
                self.user = CoreDataManager.shared.getUser(query: id as! String)
                
                      
                if((id as! String).count > 0  && self.user.userid!.count > 0 && self.user.userid == (id as! String))
                {
                    // userid 존재
                    self.webView.evaluateJavaScript(jsString1) { (result, error) in
                               
                                
                        if let pass = result {
                                   
                            if(self.user.password == pass as? String )
                            {
                                       
                            
                                
                                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.3", ofType: "html", inDirectory:"www/ucp-v03-g")!)
                                
                                self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                                
                            }
                            
                            else
                            {
                            
                                self.Alert(question: "패스워드를 정확하게 입력하세요.", text: "")
                                             

                            }
                            
                        }
                        else
                        {
                            self.Alert(question: "정보를 정확하게 입력하세요.", text: "")
                                
                        }
                        
                    
                
                    }
                }
                else{
                    
                                   
                         
                    self.Alert(question: "정보를 정확하게 입력하세요.", text: "")
                    
                    
                }
            
        
            }
            else
            {
                       
                self.Alert(question: "정보를 정확하게 입력하세요.", text: "")
                
            }
        }
                    
    }
    func goSignUp()
    {
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.2", ofType: "html", inDirectory:"www/ucp-v03-home")!)
        
        self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        
        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        if navigationAction.navigationType == WKNavigationType.linkActivated {
        
            if(navigationAction.request.url?.absoluteString.contains("login.html") == true)
            {
                  
                processLogin()
    
            }
             
            if(navigationAction.request.url?.absoluteString.contains("signup.html") == true)
            {
                 goSignUp()
                
            }
            if(navigationAction.request.url?.absoluteString.contains("signup_submit.html") == true)
            {
                
                
                processSignUp()
                
            }
            //signup_submit.html
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
                
                handType = "1"
               
            }
            if(navigationAction.request.url?.absoluteString.contains("righthand.html") == true)
            {
               
                
                decisionHandler(.allow)
                
                setHandTypeR()
                
                handType = "2"
                
               
            }
            if(navigationAction.request.url?.absoluteString.contains("env.html") == true)
            {
             
               
                let list = navigationAction.request.url?.absoluteString.components(separatedBy:  "?")
                
                if(list!.count > 1)
                {
                
                    let strWork  = list![1]
                    
                    usageType4 = strWork
                    
                    usageType = handType + usageType2 + usageType3 + usageType4
                    
                    let ret =  CoreDataManager.shared.getUserType(query: usageType)
                    
                    let id = user.userid
                    let password = user.password
                    let country = user.country
                    let name = user.name
                    
                    CoreDataManager.shared.saveUser(name: name! , id: id!, password: password!, country: country!,answer: usageType, type:ret, onSuccess:{ (success) in
                                                                                               
                    
                        print(success)
                        
                                                                                      
                    })
                    
                    
                    print(ret)
                }
                
                decisionHandler(.allow)
                
                setUserEnvironment()
             
            }
            if(navigationAction.request.url?.absoluteString.contains("NO.6.html") == true)
            {
                   
                let list = navigationAction.request.url?.absoluteString.components(separatedBy:  "?")
                      
            
                if(list!.count > 1)
                {
                
                    let strWork  = list![1]
                    usageType2 = strWork
                    print(strWork)
                
                }
                decisionHandler(.allow)

                
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.6", ofType: "html", inDirectory:"www/ucp-v03-g")!)
                
                self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                
                       
            }
            if(navigationAction.request.url?.absoluteString.contains("tutorial.html") == true)
            {
                   
               
                decisionHandler(.allow)

                
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.17", ofType: "html", inDirectory:"www/ucp-v03-t")!)
                
                self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                
                       
            }
            if(navigationAction.request.url?.absoluteString.contains("initial.html") == true)
            {
                   
               
                decisionHandler(.allow)

                
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.3", ofType: "html", inDirectory:"www/ucp-v03-g")!)
                
                self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                
                       
            }
            //initial.html

            if(navigationAction.request.url?.absoluteString.contains("NO.7.html") == true)
            {
                   
                let list = navigationAction.request.url?.absoluteString.components(separatedBy:  "?")
                      
            
                if(list!.count > 1)
                {
                
                    let strWork  = list![1]
                    usageType3 = strWork
                    print(strWork)
                
                }
                decisionHandler(.allow)
                       
            }

 
        }
        else if navigationAction.navigationType == WKNavigationType.formSubmitted
        {
            print("")
        }
        else
        {
            print(navigationAction.navigationType)
        }

          decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //ready to be processed
        let title = webView.title
        if( title == "c2")
        {
    
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            
        }
        else if(title ==  "m1")
        {
       
            getUserType(condition: "Windows")
            let jsString0 = "document.getElementsByTagName('h6')[2].innerHTML = " + "'" + String(self.user.name!) + "'"
             
            webView.evaluateJavaScript(jsString0) { (result, error) in
            
                    // 로그인 이름 설정
              
                
            }
        
            
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
        getApplication()
    }
 
    let query = NSMetadataQuery()
      
    func getApplication()
    {
    
        let predicate = NSPredicate(format: "kMDItemKind == 'Application'")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveWorkMainNotification(_:)), name: NSNotification.Name(rawValue: "NSMetadataQueryDidFinishGatheringNotification"), object: nil)
        
        query.predicate = predicate
        query.start()
           
      //  NSNotification.
    
    }
      @objc func didRecieveWorkMainNotification(_ notification: Notification) {
         // print("Test Notification")
    
        for i in 0...query.resultCount
        {
          //  let dict = query.results[i] as? [String:Any]
            //print (dict)
          //  let name  = dict.va
        }
          //processUrl()
      }
    
   
    func connectDB()
    {
       
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
        

        
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.1", ofType: "html", inDirectory:"www/ucp-v03-home")!)
          
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
     

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

