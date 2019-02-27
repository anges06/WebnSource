//
//  SecondViewController.swift
//  WebnSource
//
//  Created by anges on 16.02.19.
//  Copyright © 2019 anges. All rights reserved.
//

import UIKit
import Foundation

class SourceCode: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var TxtUrl: UITextField!
    @IBOutlet var MainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = self.tabBarController as? DataExchange {
            LoadData(UrlString: data.Url!)

            TxtUrl.text = data.Url
            
            //Helper function to load offline data
            //LoadFakeData()
        }
        
        TxtUrl.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let data = self.tabBarController as? DataExchange {
            LoadData(UrlString: data.Url!)
            
            TxtUrl.text = data.Url
            
            //Helper function to load offline data
            //LoadFakeData()
        }
    }
    
    //Function to reload the source code
    @IBAction func RefreshWebsiteData(_ sender: Any) {
        print("refresh selected")
        
        LoadData(UrlString: TxtUrl.text!)
        
        if let data = self.tabBarController as? DataExchange {
            data.Url = TxtUrl.text
        }
    }
    
    
    //Load data into TextView
    func LoadData(UrlString: String)
    {
        //ActivityIndicator while source code will be loaded
        let LoadingView: UIView = UIView()
        LoadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        LoadingView.center = MainView.center
        LoadingView.backgroundColor = UIColor(red: 0.664, green: 0.664, blue: 0.664, alpha: 0.8)
        LoadingView.clipsToBounds = true
        LoadingView.layer.cornerRadius = 10
        LoadingView.layer.zPosition = 1
        
        let Waiter: UIActivityIndicatorView = UIActivityIndicatorView()
        Waiter.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Waiter.layer.cornerRadius = 10
        Waiter.center = LoadingView.center
        Waiter.hidesWhenStopped = true
        Waiter.style = UIActivityIndicatorView.Style.white
        Waiter.startAnimating()
        Waiter.layer.zPosition = 2
        
        MainView.addSubview(Waiter)
        MainView.addSubview(LoadingView)
        
        //try to load the website
        guard let url = URL(string: UrlString) else {
            print("Error: \(UrlString) doesn't seem to be a valid URL")
            self.TextView.text = "Error: \(String(describing: UrlString)) doesn't seem to be a valid URL"
            return
        }
        
        //LOad data in a new task
        URLSession.shared.dataTask(with: url) {(Outdata, response, error) in
            guard let data = Outdata else {
                
                print(error!.localizedDescription)
                
                //In case Internet is not available
                DispatchQueue.main.async
                {
                        //do some stuff here
                }
                
                return
            }
        
            //Load html string into TextView
            DispatchQueue.main.async
            {
                    let HTMLString = String(data: data, encoding: String.Encoding.ascii)
                    print("HTML : \(String(describing: HTMLString))")
                    self.TextView.attributedText = self.getColoredText(text: HTMLString!)
                    
                    LoadingView.isHidden = true
                    Waiter.stopAnimating()
            }
            
            print(error?.localizedDescription as Any)
            
        }.resume()
    }
    
    //Load the data, when a new url is entered
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        LoadData(UrlString: TxtUrl.text!)
        
        if let data = self.tabBarController as? DataExchange {
                data.Url = TxtUrl.text
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //Helper function to load offline data
    func LoadFakeData()
    {
        let LoadingView: UIView = UIView()
        LoadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        LoadingView.center = MainView.center
        LoadingView.backgroundColor = UIColor(red: 0.664, green: 0.664, blue: 0.664, alpha: 0.3)
        LoadingView.clipsToBounds = true
        LoadingView.layer.cornerRadius = 10
        
        let Waiter: UIActivityIndicatorView = UIActivityIndicatorView()
        Waiter.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Waiter.layer.cornerRadius = 10
        Waiter.center = LoadingView.center
        Waiter.hidesWhenStopped = true
        Waiter.style = UIActivityIndicatorView.Style.white
        Waiter.startAnimating()
        Waiter.layer.zPosition = 1
        LoadingView.layer.zPosition = 2
        
        MainView.addSubview(Waiter)
        MainView.addSubview(LoadingView)
        
        //input.rtf contains 'offline data'
        //Create this file with any html data that will be loaded into TextView
        do {
            let path = Bundle.main.path(forResource: "input", ofType: "rtf")
            let text = try String(contentsOfFile: path!, encoding: .utf8)
            print(text)
            
            TextView.attributedText = getColoredText(text: text)
            
            LoadingView.isHidden = true
            Waiter.stopAnimating()
        }
        catch let error {
            print("Error: \(error)")
            TextView.text = "Error getting data...."
        }
    }
    
    
    func getColoredText(text:String) -> NSMutableAttributedString{
        
        //==============================================================================
        //Colors for syntax highlighting
        let ClrBody = UIColor(red: 0.933, green: 0.602, blue: 0.970, alpha: 1.0)
        let ClrMetaName = UIColor(red: 0.465, green: 0.554, blue: 0.970, alpha: 1.0)
        let ClrMetaProperty = UIColor(red: 0.610, green: 0.970, blue: 0.913, alpha: 1.0)
        let ClrMetaHttp = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let ClrLinkCross = UIColor(red: 0.5, green: 0.97, blue: 0.38, alpha: 1.0)
        let ClrLinkRel = UIColor(red: 0.967, green: 0.942, blue: 0.076, alpha: 1.0)
        let ClrDiv = UIColor(red: 0.970, green: 0.669, blue: 0.669, alpha: 1.0)
        let ClrAhref = UIColor(red: 0.970, green: 0.338, blue: 0.330, alpha: 1.0)
        let ClrHeaderClass = UIColor(red: 0.166, green: 0.942, blue: 0.076, alpha: 1.0)
        let ClrAClass = UIColor(red: 1.0, green: 0.464, blue: 0.262, alpha: 1.0)
        let ClrButtonClass = UIColor(red: 0.377, green: 0.777, blue: 0.910, alpha: 1.0)
        let ClrNavClass = UIColor(red: 0.785, green: 0.224, blue: 0.828, alpha: 1.0)
        let ClrDivClass = UIColor(red: 0.7, green: 1.0, blue: 1.0, alpha: 1.0)
        let ClrUlClass = UIColor(red: 0.371, green: 0.371, blue: 0.371, alpha: 1.0)
        let ClrLiClass = UIColor(red: 0.514, green: 0.246, blue: 1.0, alpha: 1.0)
        let ClrSvg = UIColor(red: 0.610, green: 0.970, blue: 0.913, alpha: 1.0)
        let ClrComment = UIColor(red: 1.0, green: 0.186, blue: 0.573, alpha: 1.0)
        let ClrImg = UIColor(red: 0.470, green: 0.5, blue: 1.0, alpha: 1.0)
        let ClrSpan = UIColor(red: 1.0, green: 0.832, blue: 0.473, alpha: 1.0)
        let ClrHx = UIColor(red: 1.0, green: 0.33, blue: 0.473, alpha: 1.0)
        let ClrP = UIColor(red: 0.169, green: 0.478, blue: 0.473, alpha: 1.0)
        let ClrForm = UIColor(red: 1.0, green: 0.986, blue: 0.0, alpha: 1.0)
        let ClrDi = UIColor(red: 0.88, green: 0.71, blue: 0.5, alpha: 1.0)
        let ClrDt = UIColor(red: 0.88, green: 0.71, blue: 1.0, alpha: 1.0)
        let ClrLabel = UIColor(red: 0.88, green: 0.015, blue: 1.0, alpha: 1.0)
        let ClrInput = UIColor(red: 0.0, green: 0.015, blue: 1.0, alpha: 1.0)
        let ClrScript = UIColor(red: 0.0, green: 0.563, blue: 0.319, alpha: 1.0)
        //==============================================================================
        
        
        //prepare the source data and save into array
        let string:NSMutableAttributedString = NSMutableAttributedString(string: text)
        let words:[String] = text.components(separatedBy: "\n") as [String]
        
        //run through the array
        for input in words {
            
            let word = input.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //expand the syntax if required
            if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<body") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrBody, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<meta name") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrMetaName, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<meta property") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrMetaProperty, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<meta http") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrMetaHttp, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<link crossorigin") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrLinkCross, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<link rel") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrLinkRel, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<div") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrDiv, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<a href") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrAhref, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<header class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrHeaderClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<a class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrAClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<button class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrButtonClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<nav class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrNavClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<div class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrDivClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<ul class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrUlClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<li class") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrLiClass, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<svg") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrSvg, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<!--") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrComment, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<img") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrImg, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<span") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrSpan, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<form") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrForm, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h1") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h1") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h2") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h2") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h3") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h3") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h4") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h4") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h5") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h5") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<h6") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</h6") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrHx, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<p ") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrP, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<di ") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</di") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrDi, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<dt ") ||
                     word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("</dt") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrDt, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<label") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrLabel, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<input") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrInput, range: range)
            }
            else if (word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).hasPrefix("<script") && word.hasSuffix(">")) {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: ClrScript, range: range)
            }  
            else
            {
                let range:NSRange = (string.string as NSString).range(of: word as String)
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.cyan, range: range)
            }
        }
        return string
    }
    
}
