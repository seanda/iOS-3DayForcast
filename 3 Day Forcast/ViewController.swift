//
//  ViewController.swift
//  3 Day Forcast
//
//  Created by Sean Daniel on 2016-03-18.
//  Copyright © 2016 SeanDaniel.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let baseURL = "http://www.weather-forecast.com/locations/"
    
    let tailURL = "/forecasts/latest"
    
    
    @IBOutlet weak var searchCity: UITextField!
    
    @IBOutlet weak var forecastLabel: UILabel!
    @IBAction func searchCityClick(sender: AnyObject) {
        searchCity.text = ""
    }
    
    @IBAction func getForcast(sender: AnyObject) {
        
        let spaceCheck = NSString(string: searchCity.text!)
        
        let finalURL = baseURL + searchCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + tailURL
        
        print(finalURL)
        
        let masterURL = NSURL(string: finalURL)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(masterURL) { (data, response, Error) -> Void in
            
            // Will happen when task completes
                
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if webContent.containsString("Weather Forecast Summary") {
                            
                        var weatherStrings = webContent.componentsSeparatedByString("<span class=\"phrase\">")
                        var tempForeCast = weatherStrings[1].componentsSeparatedByString("</span>")
                        let newString = NSString(string: tempForeCast[0])
                            
                        let forecast = newString.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        //let toArray = newString.componentsSeparatedByString("&deg;")
                        //let forecast = toArray.joinWithSeparator("°")
                            
                        self.forecastLabel.text = forecast
                        self.forecastLabel.alpha = 1
                            
                            
                    
                    } else {
                        
                        self.forecastLabel.text = "\(self.searchCity.text!) not found, please enter a city name."
                    
                    }
                    
                })
                
            } else {
                
            }
                
                self.forecastLabel.text = "No Internet Connection"
        }
            
        task.resume()
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Close the keyboard if they touch outside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Close the keyboard if they touch the "return" key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        searchCity.resignFirstResponder()
        return true
    }

}

