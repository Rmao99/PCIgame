//
//  FileView.swift
//  Catch the Drop
//
//  Created by Callie on 8/11/17.
//  Copyright © 2017 Project Concern International. All rights reserved.
//
import UIKit
import Foundation


class FileView: UIViewController
{
    var myWebView : UIWebView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = NSURL(string : "https://www.google.com")
        
        myWebView.loadRequest(NSURLRequest(URL:url!))
    }
    
    /*override func didRecieveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }*/
    
    
}
