//
//  ViewController.swift
//  NodeRequestor
//
//  Created by eugene golovanov on 7/7/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func requestAction(sender: UIButton) {
        
        let urlPath: String = "https://egtodo.herokuapp.com/todos"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            //in case of error
            if error != nil {
                print("shit err")
                return
            } else {
                guard let data = data else {print("error getting data"); return}
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//                    print("JSON:\(json)")
                    

                    //output of json is array
                    for todo in json as! [AnyObject] {
                        if let desc = todo["description"] as? String {
                            print("DESCRIPT: \(desc)")
                        }
                    }

                    
                    
                } catch {
                    print("ERROR:\(error)")
                }
            }
        }
        task.resume();
    }

    
    
    
    
    
    
    

}

