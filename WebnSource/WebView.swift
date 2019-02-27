//
//  FirstViewController.swift
//  WebnSource
//
//  Created by anges on 16.02.19.
//  Copyright © 2019 anges. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class WebView: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet var WebView: WKWebView!
    @IBOutlet weak var TxtUrl: UITextField!
    var Url = DataExchange()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //
        let UrlString = "https://github.com"
        let DestinationUrl = URL(string: UrlString)
        
        //View Url in TextField
        TxtUrl.text = UrlString
        
        //Load website
        let request = URLRequest(url: DestinationUrl!)
        WebView.load(request)
        
        //Store the current url to exchange the data between 'WebView' and 'SourceCode'
        if let data = self.tabBarController as? DataExchange {
            data.Url = TxtUrl.text
        }
        
        TxtUrl.delegate = self
        WebView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Load Url in case user switches from 'SourceCode' to 'WebView'
        if let data = self.tabBarController as? DataExchange {
            TxtUrl.text = data.Url
            
            //Lord website
            let DestinationUrl = URL(string: data.Url!)
            let request = URLRequest(url: DestinationUrl!)
            WebView.load(request)
        }
    }
    
    //Set text color tp black, while editing url
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TxtUrl.textColor = UIColor.black
    }
    
    //Load the new website data
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let UrlString:String = TxtUrl.text!
        let DestUrl:URL = URL(string: UrlString)!
        
        let request: URLRequest = URLRequest(url: DestUrl)
        
        WebView.load(request)
        
        if let data = self.tabBarController as? DataExchange {
            data.Url = TxtUrl.text
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //Actions when website did finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        TxtUrl.textColor = UIColor.green
        TxtUrl.backgroundColor = UIColor.darkGray
        Url.Url = TxtUrl.text
    }
}

