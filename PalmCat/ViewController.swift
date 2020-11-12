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
class ViewController: NSViewController , WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler{
    
    @IBOutlet weak var webView:WKWebView!

    @IBOutlet weak var button:NSButton!
    
    var timer = Timer()
    
    var handType:String = ""
    var usageType2:String = ""
    var usageType3:String = ""
    var usageType4:String = ""
    
    var usageType:String = ""
    
    var user:Users!
    
    var selectedApplication = "Windows"
    var selectedGestureIndex:Int = 0
    var selectedGestureOldIndex:Int = -1

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
    
    func getSelectEventListener() -> String
    {
        let script =
            "document.getElementsByClassName('select-field')[1]." +
                "addEventListener('change', function(event){ " +
                "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
                "}); " + // L1
        "document.getElementsByClassName('select-field')[2]." +
            "addEventListener('change', function(event){ " +
            "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
            "}); "  +   // L1

        "document.getElementsByClassName('select-field')[4]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); "  + // L2
        "document.getElementsByClassName('select-field')[5]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); "  + // L2

        "document.getElementsByClassName('select-field')[7]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + //L3
        "document.getElementsByClassName('select-field')[8]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + //L3
      
        "document.getElementsByClassName('select-field')[10]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L4
        "document.getElementsByClassName('select-field')[11]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L4

        "document.getElementsByClassName('select-field')[13]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L5
        "document.getElementsByClassName('select-field')[14]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L5

        "document.getElementsByClassName('select-field')[16]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L6
        "document.getElementsByClassName('select-field')[17]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L6

        "document.getElementsByClassName('select-field')[19]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L7
        "document.getElementsByClassName('select-field')[20]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L7

        "document.getElementsByClassName('select-field')[22]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L8
        "document.getElementsByClassName('select-field')[23]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L8

        "document.getElementsByClassName('select-field')[25]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L9
        "document.getElementsByClassName('select-field')[26]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L9

        "document.getElementsByClassName('select-field')[28]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L10
        "document.getElementsByClassName('select-field')[29]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L10

        "document.getElementsByClassName('select-field')[31]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L11
        "document.getElementsByClassName('select-field')[32]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L11

        "document.getElementsByClassName('select-field')[34]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L12
        "document.getElementsByClassName('select-field')[35]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L12

        "document.getElementsByClassName('select-field')[37]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L13
        "document.getElementsByClassName('select-field')[38]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L13

        "document.getElementsByClassName('select-field')[40]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L14
        "document.getElementsByClassName('select-field')[41]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L14

        "document.getElementsByClassName('select-field')[43]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L15
        "document.getElementsByClassName('select-field')[44]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); " + // L15

        "document.getElementsByClassName('select-field')[46]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); " +
             "}); " + // L16
        "document.getElementsByClassName('select-field')[47]." +
             "addEventListener('change', function(event){ " +
             "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t4'); " +
             "}); "  // L16

        
        return script
    }
    
    func getUserType(condition:String)
    {
    
     //   connectDB()
        
        let c = "app_Name =" + "'" + condition + "'" + " && touch='t4'"
        
        let query = OHMySQLQueryRequestFactory.select(self.user.type!, condition: c )
        
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
            var option = String()
        
        if ( response == nil || (response! as! NSArray).count == 0)
        {
            option.append("<option>")
                                
                              
                    option.append("Not Selected")
                    
                    option.append("</option>")
               //     let script = "var sel1 = document.getElementsByTagName('select')[1];sel1.disabled = true; sel1.innerHTML = " + "'" + option + "'"
                 

            let script =  "var sel0 = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex) + "].disabled = true;" +
                         "var sel = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex + 1) + "];" +
                               "sel.disabled = true; sel.innerHTML = " +
                              "'" + option + "'"

                              
                     webView.evaluateJavaScript(script) { (result, error) in
                                   
                                       
                                   
                     }
                              
            
            return
            
        }
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
        /*
        var gestureScript = ""
        
                
        
            "var sel1 = document.getElementById('field-3');  sel1.addEventListener('change', function(event){ "
            +   "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); }); "
            +   "var sel2 = document.getElementById('field-2'); "
            +   "sel2.addEventListener('change', function(event){ "
            +   "               window.webkit.messageHandlers.iosListener0.postMessage(event.target.value+'/t4'); }); "
        */
        var gestureSrcript = getGestureNodeStr(index: selectedGestureIndex)
           
        gestureSrcript =  gestureSrcript + ""
        let script =
                   
                    "var sel0 = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex) + "].disabled = true;" +
                     "var sel = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex + 1) + "];" +
                           "sel.disabled = false; sel.innerHTML = " +
                           
                          "'" + option + "';"
                        /*
                        +
                        "sel.addEventListener('change', function(event){ "
                        +   "window.webkit.messageHandlers.iosListener0.postMessage(event.target.value + '/t3'); }); "
                    */
         

        
        /*
             
         
                 
                
              +   "var g16 = document.getElementById('w-node-822986547cd3-ac9b38a6');"
         */
        
        webView.evaluateJavaScript(script) { (result, error) in
                      
                          
                      
        }
    }
    func getUserType2(condition:String)
    {
    
        //connectDB()
        
        let c = "app_Name =" + "'" + condition + "'" + " && touch='t5'"
        
        let query = OHMySQLQueryRequestFactory.select(self.user.type!, condition: c )
        
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        var option = String()
        
        if ( response == nil || (response! as! NSArray).count == 0)
        {
            option.append("<option>")
                        
                      
            option.append("Not Selected")
            
            option.append("</option>")
            //let script = "var sel2 = document.getElementsByTagName('select')[2];sel2.disabled = true; sel2.innerHTML = " + "'" + option + "'"
              
            let script =
                  
                      "var sel = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex + 2) + "];" +
                      
                      "sel.disabled = true; sel.innerHTML = " +
                      
                      "'" + option + "'"
                     
                      
                      
             webView.evaluateJavaScript(script) { (result, error) in
                           
                               
                           
             }
                      
            return
        }
        if(( response! as! NSArray).count > 0 )
        {
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
               
            //   let script = "var sel = document.getElementsByTagName('select')[2]; sel.disabled = false;sel.innerHTML = " + "'" + option + "'"
               
            let script =
            
                "var sel = document.getElementsByClassName('select-field')" + "[" + String( 3 * selectedGestureIndex + 2) + "];" +
                
                "sel.disabled = false; sel.innerHTML = " +
                
                "'" + option + "';"
                    /*
                    +
               "sel.addEventListener('change', function(event){ "
               +   "               window.webkit.messageHandlers.iosListener0.postMessage(event.target.value+'/t4'); }); "
               */
                
               webView.evaluateJavaScript(script) { (result, error) in
                             
                                 
                             
               }
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
    
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            
        }
        else if(title ==  "m1")
        {
       
            getUserType(condition: "Windows")
            getUserType2(condition: "Windows")
                
            let jsString0 = "document.getElementsByTagName('h6')[2].innerHTML = " + "'" + String(self.user.name!) + "'"
             
            webView.evaluateJavaScript(jsString0) { (result, error) in
            
                    // 로그인 이름 설정
              
                
            }
          
            //
        
            
        }
        
    }
    func getGestureNodeStr(index:Int) -> String
    {
        var ret:String = String()
        if(index == 0)
        {
            ret = "document.getElementById('w-node-564723dfef21-ac9b38a6')"
        }
        if(index == 1)
        {
            ret = "document.getElementById('w-node-79cc6ab97542-ac9b38a6')"
        }
        if(index == 2)
        {
            ret = "document.getElementById('w-node-95579da77bd2-ac9b38a6')"
        }
        if(index == 3)
        {
            ret = "document.getElementById('w-node-dad1676e0d33-ac9b38a6')"
        }
        if(index == 4)
        {
            ret = "document.getElementById('w-node-a1a3e9616227-ac9b38a6')"
        }
        if(index == 5)
        {
            ret = "document.getElementById('w-node-f6a103bd1d2f-ac9b38a6')" //
        }
        if(index == 6)
        {
            ret = "document.getElementById('w-node-ece2b31bb864-ac9b38a6')"//
        }
        if(index == 7)
        {
            ret = "document.getElementById('w-node-8a1acc0fa404-ac9b38a6')"//
        }
        if(index == 8)
        {
            ret = "document.getElementById('w-node-fae6c0dc1d55-ac9b38a6')" //
        }
        if(index == 9)
        {
            ret = "document.getElementById('w-node-c7a8152b2124-ac9b38a6')" //
        }
        if(index == 10)
        {
            ret = "document.getElementById('w-node-afec249d2bb2-ac9b38a6')" //
        }
        if(index == 11)
        {
            ret = "document.getElementById('w-node-55bfbb2e8d16-ac9b38a6')" //
        }
        if(index == 12)
        {
            ret = "document.getElementById('w-node-7733dff13436-ac9b38a6')" //
        }
        if(index == 13)
        {
            ret = "document.getElementById('w-node-6ae5e178c622-ac9b38a6')" //
        }
        if(index == 14)
        {
            ret = "document.getElementById('w-node-9657988b3af9-ac9b38a6')" //
        }
        if(index == 15)
        {
            ret = "document.getElementById('w-node-822986547cd3-ac9b38a6')"
        }

        return ret
    
      
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       
        let content = message.body as! String
        var msg = String()
        for i in 0..<content.characters.count - 3{
           
            let index = content.index(content.startIndex, offsetBy:i)
            
            msg.append(content[index])
            
        }
        var msg2 = String()
        for i in content.characters.count - 3..<content.characters.count{
         
            let index = content.index(content.startIndex, offsetBy:i)
          
          msg2.append(content[index])
          
        }
           
    
        if(msg2.contains("t3") == true) // touch 3
        {
           
            print("message: \(msg)")
            
        }
        else if(msg2.contains("t4") == true) // touch 4
        {
              
            print("message: \(msg)")
            
        }
        
        else if(msg2 == "OPT")
        {
            // application 클릭
            if(msg == "Windows Default")
            {
                msg = "Windows"
            }
            if(msg == "MS Power point")
            {
                //
                msg = "MS Powerpoint"
            }
            if(msg == "MS Power point")
            {
               //
                msg = "MS Powerpoint"
            }
            print("message: \(msg)")
            
            selectedApplication = msg
            //
            getUserType(condition: selectedApplication)
            getUserType2(condition: selectedApplication)
            
            var oldNode = getGestureNodeStr(index: selectedGestureOldIndex)
            
            oldNode = oldNode + ".click()"
            
                      
                               
            
            webView.evaluateJavaScript(oldNode ) { (result, error) in
                         
            }
            

        }
                
        if(msg2.contains("g") == true)
        {
            print("message: \(msg)")
            
            var num = String()
             
            for i in content.characters.count - 2..<content.characters.count{
            
                let index = content.index(content.startIndex, offsetBy:i)
                 num.append(content[index])
                     
                  
            }
            if( num == "00")
            {
                selectedGestureIndex = 0
            }
            else if( num == "01")
            {
                
                
                selectedGestureIndex = 1
            }
            else if( num == "02")
            {
                   selectedGestureIndex = 2
            }
            else if( num == "03")
            {
                selectedGestureIndex = 3
            }
            else if( num == "04")
            {
                selectedGestureIndex = 4
            }
            else if( num == "05")
            {
                   selectedGestureIndex = 5
            }
            else if( num == "06")
            {
                selectedGestureIndex = 6
            }
            else if( num == "07")
            {
                selectedGestureIndex = 7
            }
            else if( num == "08")
            {
                 selectedGestureIndex = 8
            }
            else if( num == "09")
            {
                selectedGestureIndex = 9
            }
            else if( num == "10")
            {
                selectedGestureIndex = 10
            }
            else if( num == "11")
            {
                selectedGestureIndex = 11
            }
            else if( num == "12")
            {
                selectedGestureIndex = 12
            }
            else if( num == "13")
            {
                selectedGestureIndex = 13
            }
            else if( num == "14")
            {
                selectedGestureIndex = 14
            }
            else if( num == "15")
            {
                selectedGestureIndex = 15
            }
            
            if(selectedGestureOldIndex != -1)
            {
                
                var oldNode = getGestureNodeStr(index: selectedGestureOldIndex)
                oldNode = oldNode + ".classList.remove('w--current');"
                       
                var curNode = getGestureNodeStr(index: selectedGestureIndex)
                
                curNode =  curNode + "g.classList.add('w--current');"
                 
                          
                webView.evaluateJavaScript(oldNode + curNode) { (result, error) in
                
                    self.getUserType(condition: self.selectedApplication)
                    
                    self.getUserType2(condition: self.selectedApplication)
                    
                }
            }
                  
            
            selectedGestureOldIndex = selectedGestureIndex
             
    
            
           

        }
        
        // and whatever other actions you want to take
    }
    
    /*
             
      */
    
    
    @objc func timerAction(){
             
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NO.16", ofType: "html", inDirectory:"www/cup-v03-m")!)
        
        
        let config = WKWebViewConfiguration()
                  
        let str =  getSelectEventListener()

        let source =
           "var x = document.getElementsByClassName('text-block-3');"
        +   "    x[0].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[0].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[1].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[1].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[2].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[2].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[3].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[3].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[4].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[4].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[5].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[5].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[6].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[6].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[7].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[7].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[8].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[8].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[9].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[9].innerHTML + 'OPT');"
        +   "   });"
        +   "    x[10].addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( x[10].innerHTML + 'OPT');"
        +   "   });"
            
        +   "var g1 = document.getElementById('w-node-564723dfef21-ac9b38a6');"
        +   "g1.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L1' + 'g00');"
        +   "});"
        +   "var g2 = document.getElementById('w-node-79cc6ab97542-ac9b38a6');"
        +   "g2.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L2' + 'g01');"
        +   "});"
        
        +   "var g3 = document.getElementById('w-node-95579da77bd2-ac9b38a6');"
        +   "g3.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L3' + 'g02');"
        +   "});"
        +   "var g4 = document.getElementById('w-node-dad1676e0d33-ac9b38a6');"
        +   "g4.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L4' + 'g03');"
        +   "});"
        +   "var g5 = document.getElementById('w-node-a1a3e9616227-ac9b38a6');"
        +   "g5.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L5' + 'g04');"
        +   "});"
        +   "var g6 = document.getElementById('w-node-f6a103bd1d2f-ac9b38a6');"
        +   "g6.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L6' + 'g05');"
        +   "});"
        +   "var g7 = document.getElementById('w-node-ece2b31bb864-ac9b38a6');"
        +   "g7.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L7' + 'g06');"
        +   "});"
        +   "var g8 = document.getElementById('w-node-8a1acc0fa404-ac9b38a6');"
        +   "g8.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L8' + 'g07');"
        +   "});"
            
        +   "var g9 = document.getElementById('w-node-fae6c0dc1d55-ac9b38a6');"
        +   "g9.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L9' + 'g08');"
        +   "});"
            
        +   "var g10 = document.getElementById('w-node-c7a8152b2124-ac9b38a6');"
        +   "g10.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L10' + 'g09');"
        +   "});"
            
        +   "var g11 = document.getElementById('w-node-afec249d2bb2-ac9b38a6');"
        +   "g11.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L11' + 'g10');"
        +   "});"
        +   "var g12 = document.getElementById('w-node-55bfbb2e8d16-ac9b38a6');"
        +   "g12.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L12' + 'g11');"
        +   "});"
            
        +   "var g13 = document.getElementById('w-node-7733dff13436-ac9b38a6');"
        +   "g13.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L13' + 'g12');"
        +   "});"
        +   "var g14 = document.getElementById('w-node-6ae5e178c622-ac9b38a6');"
        +   "g14.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L14' + 'g13');"
        +   "});"
        +   "var g15 = document.getElementById('w-node-9657988b3af9-ac9b38a6');"
        +   "g15.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L15' + 'g14');"
        +   "});"
        +   "var g16 = document.getElementById('w-node-822986547cd3-ac9b38a6');"
        +   "g16.addEventListener('click', function(){ "
        +   "       window.webkit.messageHandlers.iosListener0.postMessage( 'L16' + 'g15');"
        +   "});"
        + str
     
        
        
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        config.userContentController.addUserScript(script)
        
        config.userContentController.add(self, name: "iosListener0")
               
     //   config.userContentController.add(self, name: "iosListener1")
                      
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1200, height: 700), configuration: config)
                        
        webView.navigationDelegate = self
        
                                   
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
       
        self.view.addSubview(webView)
              
        
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

