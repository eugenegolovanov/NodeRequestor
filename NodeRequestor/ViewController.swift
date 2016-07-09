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
    @IBOutlet weak var delTodosIdSlider: UISlider!
    
    //Labels
    @IBOutlet weak var getTodosIdLabel: UILabel!
    @IBOutlet weak var delTodosIdLabel: UILabel!
    
    //Query field
    @IBOutlet weak var queryField: UITextField!
    
    //Put
    @IBOutlet weak var putDescriptionField: UITextField!
    
    //Post
    @IBOutlet weak var postDescriptionField: UITextField!
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
                            if let desc = todo["description"] as? String,
                            let id = todo["id"] as? Int {
                                print("-----------------------------------")
                                print("id:\(id)  DESCRIPT: \(desc)")
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
        print("\nGot ID:\(id)")
        
        
        let urlPath: String = "https://egtodo.herokuapp.com/todos/\(id)"
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
                    if let desc = json["description"] as? String,
                    let id = json["id"] as? Int {
                        print("-----------------------------------")
                        print("id:\(id)  DESCRIPT: \(desc)")
                    }
                    
                    
                } catch {
                    print("Could not find todo\nERROR:\(error)")
                }
            }
        }
        task.resume();
    }

    
    
    
    @IBAction func getTodosByQuery(sender: UIButton) {
        
        guard let queryString = self.queryField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) else {
            print("Could not get query from queryField")
            return
        }
        
        if queryString == "" {
            print("Text Field is empty")
            return
        } else {
            print("GOT TEXT:\(queryString)")
        
            let urlPath: String = "https://egtodo.herokuapp.com/todos" + "?q=" + queryString
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
                                if let desc = todo["description"] as? String,
                                    let id = todo["id"] as? Int {
                                    print("-----------------------------------")
                                    print("id:\(id)  DESCRIPT: \(desc)")
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

    
    }
    
    
    
    
    
    
    @IBAction func postTodoButtonPressed(sender: UIButton) {
        
        guard let postString = self.postDescriptionField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) else {
            print("Could not get query from postDescriptionField")
            return
        }
        
        if postString == "" {
            print("POST Text Field is empty")
            return
        } else {
            print("POST TEXT:\(postString)")
        }
        let paramsDictionary = ["description":postString,"completed":"true"]
        
        //POST
        self.postRequest(paramsDictionary) { (data, response, error) in
            if error == nil {
                print("PORT RESPONSE:\(response)")
            } else {
                print("POST ERR:\(error)")
            }
        }
    }
    
    
    
    
    
    
    func postRequest(params:Dictionary<String, String>, completion: (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void) {
        let urlPath: String = "https://egtodo.herokuapp.com/todos"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        
        // Verify downloading data is allowed
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        } catch let error as NSError {
            print("Error in request post: \(error)")
            request.HTTPBody = nil
        } catch {
            print("Catch all error: \(error)")
        }
        
        
        
        // Post the data
        let task = session.dataTaskWithRequest(request) { data, response, error in
            completion(data: data, response: response, error: error)
        }
        
        task.resume()

    }

    
    
    
    @IBAction func delTodosById(sender: UIButton) {
        guard let id = Int(delTodosIdLabel.text!) else {
            print("error getting id for delTodosById")
            return
        }
        print("\nGot ID:\(id)")
        
        
        let urlPath: String = "https://egtodo.herokuapp.com/todos/\(id)"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "DELETE"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            //in case of error
            if error != nil {
                print("delete err")
                return
            } else {
//                guard let data = data else {print("error getting data"); return}
//                guard let response = response else {print("error getting response"); return}
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 404 {
                        print("Error in response:\(response)")
                        
                    } else {
                        print("DELETED Successfully DATA:\(data)")
                        print("response:\(response)")
                    }
                    
                }
                

            }
        }
        task.resume();
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func putTodosById(sender: UIButton) {
        
        
        guard let putString = self.putDescriptionField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) else {
            print("Could not get query from putDescriptionField")
            return
        }
        
        if putString == "" {
            print("PUT Text Field is empty")
            return
        } else {
            print("PUT TEXT:\(putString)")
        }
        let paramsDictionary = ["description":putString,"completed":"true"]

        
        let id = 4
        
        
        //PUT
        self.putRequest(id: id, params: paramsDictionary) { (data, response, error) in
            if error == nil {
                print("PUT RESPONSE:\(response)")
            } else {
                print("PUT ERR:\(error)")
            }
        }

        
    }

    
    
    
    
    func putRequest(id id:Int, params:Dictionary<String, String>, completion: (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void) {
        let urlPath: String = "https://egtodo.herokuapp.com/todos/" + "\(id)"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        
        // Verify downloading data is allowed
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        } catch let error as NSError {
            print("Error in request post: \(error)")
            request.HTTPBody = nil
        } catch {
            print("Catch all error: \(error)")
        }
        
        
        
        // Post the data
        let task = session.dataTaskWithRequest(request) { data, response, error in
            completion(data: data, response: response, error: error)
        }
        
        task.resume()
        
    }

    
    
    
    //----------------------------------------------------------------------------------------
    //MARK: - Slider Actions

    @IBAction func getTodosIdSliderAction(sender: UISlider) {
        getTodosIdLabel.text = "\(Int(round(sender.value)))"
    }
    @IBAction func delTodosIdSliderAction(sender: UISlider) {
        delTodosIdLabel.text = "\(Int(round(sender.value)))"
    }

    
    
    

}

