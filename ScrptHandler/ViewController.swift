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
        if let url = URL(string: "https://stage.rockstreamer.com?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDEzOTMsInByb3ZpZGVyX2lkIjoicGhvbmUiLCJyb2xlIjowLCJ1c2VybmFtZSI6Iis4ODAxNzk4MDk5OTc3IiwicGxhdGZvcm0iOiJpc2NyZWVuIiwicGFydG5lciI6IkdQX01ZR1AiLCJzdWJzY3JpYmUiOmZhbHNlLCJwYWNrYWdlSW5mbyI6bnVsbCwiaXNUVk9EIjpmYWxzZSwidHZvZEV4cGlyZURhdGUiOiIxOTcwLTAxLTAxIiwiaWF0IjoxNzA5NjQzOTY4LCJleHAiOjE3MDk3MzAzNjh9.cG0BRZ5gdIGA5FvV2KruYNxt6x_SxuETTnXW-4SKwV01UdFdFAbDvU7D0k0tbD48gHNOFKMDxzKCtrNfdKwQTLdEjuiQEMl_jMXxs_ZixgEnmufiJswpYJb8nRfEKbRHWojg4hv0A1K8bPDwz9lJwd99AHjGD-AJUzNpr68-KYA3UHrv3GiCb659o_9mLfQo5q4cifh2VOSDPksBpGVyxPoYcK7ZF4TTve2Dqnb2xlG9lL86VhLnz2TvUK4eRfV1RK9HsRo8mMqnUM042iVpqgwXw3V0mbloRxqMOQNL4Fd8be17bDTgyKuPa4nmsg6X-7zpQxV5xvhpEedQ4QZvmST1EGlMeUOZ0cRLUoHWlubEkuqmFbci6Zf5BDdreSSE3JeDpqlzVEZNT517YnnNxul9zG9VZACsu7MX2MbAXGEhLsBhglZLmiUwLdcDcKCcIUkWcmf9YcuF63Un3CARhX1h6DGC5k-7YdzzM54R_epWIiHxEccW84N2lzkyRijFi8h5EZvFtXO46ug6kweYeOgYlxM5nPWv3fonhVHuXkWFaoA-8OMHO8sj7CFIRfGDdhYRRhVPHgfM3TICn2N5OruLRvwzQahRpMQqbsp2ai1MgCpEtsT3J2Gp2KtmKtjA86M62LDAmmncyGqp02tXatoVNiL9yywFI3iCZsDeCP0") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }


}

extension ViewController: WKScriptMessageHandler, WKNavigationDelegate {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // MARK: - 1st Callback found
        
        if message.name == "onTokenStatus", let tokenStatusInfo = message.body as? [String: Any] {
            if let status = tokenStatusInfo["status"],
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
                    let params = body["paramsIOS"] as? [String: Any]
                    // Do something with the data received from JavaScript
                    print("Event Name: \(eventName ?? "")")
                    print("Parameters: \(params ?? [:])")
                
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
