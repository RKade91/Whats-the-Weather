//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Rohit Kumar on 2015-06-13.
//  Copyright (c) 2015 RKumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet var userCity: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
   
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        //check whether or not url is equal to nil
        // wont it never be nil?
        if url != nil {
            
            //if url not nill initialize the task with url
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                
                var weather = ""
                
                
                //check if there are any errors
                if error == nil {
                    
                    //this pretty much holds all the HTML code for the url
                    var urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                   // converts the HTML code seperated by "<span class=\"phrase\">"
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    //if it was able to seperate the HTML code by "<span class=\"phrase\">" then the count should be greater than 1 otherwise it didnt find "<span class=\"phrase\">" in the HTML code
                    if urlContentArray.count > 1 {
                        
                        
                        //same thing goes for this array
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        weather = weatherArray[0] as! String
                        
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                    } else { // if urlContentArray is not greater than 1, this this is executed. most likely it will be equal to 1 if it were to execute this
                        
                        urlError = true
                        
                    }
                    
                    
                    
                } else { // if error carches soemthing (error != nil)
                    
                    urlError = true
                    
                }
                
                // this is where pretty much everything comes together
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if urlError == true {
                        
                        self.showError()
                        
                    } else {
                        
                        self.resultLabel.text = weather
                        
                    }
                }
                
            })
            
            task.resume()
            
            
        } else {
            
            showError()
            
        }
        
        
    }
    
    
    func showError() {
        
        resultLabel.text = "Was not able to find weather for " + userCity.text! + ". Please try again"
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

