//
//  ViewController.swift
//  ScrptHandler
//
//  Created by ahmed rajib on 28/1/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebSide()
    }
    
    private func loadWebSide() {
        
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // MARK: - onTokenStatus 1st Script
        contentController.add(self, name: "onTokenStatus")
        
        // MARK: -     2nd script
        contentController.add(self, name: "onContentChange")
        
        // MARK: -      3rd script
        contentController.add(self, name: "onEventExecute")
        
        configuration.userContentController = contentController
        
        
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        view.addSubview(webView)

        // Load a website
        if let url = URL(string: "https://dev.rockstreamer.com/?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDEyOTcsInByb3ZpZGVyX2lkIjoicGhvbmUiLCJyb2xlIjowLCJ1c2VybmFtZSI6Iis4ODAxNzkzNzI2Nzc2IiwicGxhdGZvcm0iOiJpc2NyZWVuIiwicGFydG5lciI6IkdQX01ZR1AiLCJzdWJzY3JpYmUiOnRydWUsInBhY2thZ2VJbmZvIjp7Im5hbWUiOiJTdWJzY3JpYmUiLCJkZXNjcmlwdGlvbiI6IlN1YnNjcmliZSIsInByaWNlIjoiMzAiLCJ1bml0IjoiQkRUIiwiY291bnRyeUNvZGUiOiJCRCIsImNvbG9yQ29kZSI6bnVsbCwicHJvZHVjdElkIjoiR1BPQ0lTQ1JFRU5QMSIsInBheW1lbnRNZXRob2RUeXBlIjoic2VydmljZV9idW5kbGUiLCJleHBpcmVEYXRlIjoiMjAyNC0wMi0xNSJ9LCJpc1RWT0QiOnRydWUsInR2b2RFeHBpcmVEYXRlIjoiMjAyNC0wMi0xNSIsImlhdCI6MTcwNjQyOTk4NCwiZXhwIjoxNzA2NTE2Mzg0fQ.Yw3a1sq88G-vaOX0YnLgC_dZH5x3V5L80zcQX60x8endm970h-LTD4POkxIE632fIlmqDg9NUT0F10KL7_FqGs_fV9ZedQf6dOV3vSKYVaAWw7a7o9bvtoBNVz0hkaaUQvjanpjD9dlmr0RDKi3f66CdnPGtGaMydd-LKVOs36y46oBR7A_he0agLiR6vve_JQFCkavS0vAJi52V7ZenqBNrU4zeuJ89FtMh7RNQoQSjYudS4WFQtc5obSggWB9RpYzPAPz9uiT5V3wd_qBKIlWv5wFVcP02mJj7hc7BfhrDXyC1zo_Cyj9OpyWLUDNYe2kRBGKm45vm2ipHtCyk-6uROasPMQhv3vY8WelkeVRbkgUYH8wmUje8d8b71QRkF-TZgFnFnJWBSturN3EWM_s7bNmndW75UUAc5IsZVCJNgBzmL-OwWSnuWAcpbaLNxsNIqiQXG83RP4Bc7fvM4VvE9ltc-0I70W0SYQa60dpME6zCHjSmbzU-V2_gv9VIKsFxKWE7b5C4R2imMweC_fManMCl4_4P-bi_XmKf1uBXeOvns08oYaj4mGtih2vgVY4DJSk7zDBxruQm2r7CRlmk2MZHOMzvBhmAqdbYufQbYiE5QrNC_-LgioWGKUGmrffutfSfhN1KrQoT7_R9zqs0izOkRWqtj8qwqduTpyk") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }


}

extension ViewController: WKScriptMessageHandler, WKNavigationDelegate {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // MARK: - 1st Callback found
        
        if message.name == "onTokenStatus", let tokenStatusInfo = message.body as? [String: Any] {
            if let status = tokenStatusInfo["status"] as? Bool,
               let message = tokenStatusInfo["message"] as? String {
                print("Received token status message from website:")
                print("Status: \(status)")
                print("Message: \(message)")
                self.showToast(message: message, font: .systemFont(ofSize: 12.0))
            }
        }

        // MARK: - 2nd Call Found
        
        if message.name == "onContentChange" {
            // Handle the message from JavaScript
            if let body = message.body as? [String: Any] {
                let contentUrl = body["contentUrl"] as? String
                let isPremium = body["isPremium"] as? Bool
                
                // Do something with the data received from JavaScript
                print("Content URL: \(contentUrl ?? "")")
                print("Is Premium: \(isPremium ?? false)")
            }
        }
        
        
        // MARK: - 3rd Callback Found
        
        if message.name == "onEventExecute" {
                // Handle the message from JavaScript
                if let body = message.body as? [String: Any] {
                    let eventName = body["name"] as? String
                    let params = body["params"] as? [String]

                    // Do something with the data received from JavaScript
                    print("Event Name: \(eventName ?? "")")
                    print("Parameters: \(params ?? [])")
                
            }
        }
    }
    
    // Implement WKNavigationDelegate method if needed
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Web page finished loading
        
        if let currentWebsite = webView.url {
            debugPrint("DEBUG:  CurrentWebPage ", currentWebsite.absoluteString)
        }
    }
    

    
    
    // Called when navigation starts
       func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           // You can inspect the URL here to detect which page is being loaded
           if let url = webView.url {
               print("Navigating to page: \(url)")
           }
       }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.red
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
