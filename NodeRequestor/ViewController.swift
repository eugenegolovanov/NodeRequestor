//
//  ViewController.swift
//  NodeRequestor
//
//  Created by eugene golovanov on 7/7/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //----------------------------------------------------------------------------------------
    //MARK: - Properties
    
    //Sliders
    @IBOutlet weak var getTodosIdSlider: UISlider!
    @IBOutlet weak var putTodosIdSlider: UISlider!
    @IBOutlet weak var delTodosIdSlider: UISlider!
    
    //Labels
    @IBOutlet weak var getTodosIdLabel: UILabel!
    @IBOutlet weak var putTodosIdLabel: UILabel!
    @IBOutlet weak var delTodosIdLabel: UILabel!
    

    
    //----------------------------------------------------------------------------------------
    //MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    //----------------------------------------------------------------------------------------
    //MARK: - Request Actions


    @IBAction func getAllTodos(sender: UIButton) {
        
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
                    
                    
                    //If NOT Array
                    if let desc = json["description"] as? String {
                        print("JSON is NOT Array")
                            print("DESCRIPT: \(desc)")
                    }
                    
                    //If ARRAY
                    if let todoArray = json as? [AnyObject] {
                        print("JSON is ARRAY")

                        for todo in todoArray  {
                            if let desc = todo["description"] as? String {
                                print("DESCRIPT: \(desc)")
                            }
                        }
                    }

                    
                    
                    
                } catch {
                    print("ERROR:\(error)")
                }
            }
        }
        task.resume();
    }
    
    
    
    @IBAction func getTodosById(sender: UIButton) {
        guard let id = Int(getTodosIdLabel.text!) else {
            print("error getting id for getTodosById")
            return
        }
        
        print("Got ID:\(id)")

    }

    
    
    //----------------------------------------------------------------------------------------
    //MARK: - Slider Actions

    @IBAction func getTodosIdSliderAction(sender: UISlider) {
        getTodosIdLabel.text = "\(Int(round(sender.value)))"
    }
    @IBAction func putTodosIdSliderAction(sender: UISlider) {
        putTodosIdLabel.text = "\(Int(round(sender.value)))"
    }
    @IBAction func delTodosIdSliderAction(sender: UISlider) {
        delTodosIdLabel.text = "\(Int(round(sender.value)))"
    }

    
    
    

}

