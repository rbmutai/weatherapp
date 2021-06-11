//
//  NetworkCall.swift
//  Conditions
//
//  Created by MAC USER on 09/06/2021.
//

import Foundation
import UIKit
import ACProgressHUD_Swift


class NetworkCall {
    let progressDialog = ACProgressHUD.shared
    let CL=Colors()
    let am = UsefullMethods()
    let mainurl = "https://api.openweathermap.org/data/2.5/"
    let appid="9b7b14f09341fe85ef16a14244603a61"
    let units="metric"
    let errorMessage="There was an error during connection"
    var delegate: NetworkCallDelegate?
    
    func fetchforcast(latitude:String,longitude:String){
        showProgressDialog(message: "Please wait,fetching weather forcast...")
        var additional = "onecall?lat=" + latitude + "&lon=" + longitude + "&exclude=minutely,hourly&appid=" + appid + "&units=" + units
        networkCallRequest(urlparameters: additional)
    }
    func fetchcurrentweather(latitude:String,longitude:String){
        showProgressDialog(message: "Please wait,fetching current weather...")
        var additional = "find?lat=" + latitude + "&lon=" + longitude + "&cnt=1&appid=" + appid + "&units=" + units
        networkCallRequest(urlparameters: additional)
    }
    
    func networkCallRequest(urlparameters: String){
        guard Reachability.isConnectedToNetwork() else {
            self.showErrorDialog(message: "No internet connection!")
            self.hideProgressDialog()
            return
        }
       
        let config = URLSessionConfiguration.default //Session Configuration
        let session = URLSession(configuration: config) //Load configuration into session
        var requestURL = mainurl + urlparameters
        
        print("\(requestURL)")
        let url: URL = URL(string:requestURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        request.httpShouldHandleCookies = false
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
               
                DispatchQueue.main.async {
                    self.hideProgressDialog()
                    self.showErrorDialog(message: self.errorMessage)
                    
                }
                return
            }else {
                
                if error != nil {
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        self.hideProgressDialog()
                        self.showErrorDialog(message: self.errorMessage)
                        
                    }
                    
                    
                }else{
                    
                    do{
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any> {
                            DispatchQueue.main.async {
                                self.hideProgressDialog()
                                self.ProcessResponse(ResultFromServer: json)
                                
                            }
                        }else {
                            DispatchQueue.main.async {
                                self.hideProgressDialog()
                                self.showErrorDialog(message: self.errorMessage)
                                
                            }
                        }
                        
                    }catch{
                        print("error in serialization")
                        DispatchQueue.main.async {
                            self.hideProgressDialog()
                            self.showErrorDialog(message: self.errorMessage)
                            
                        }

                    }
                }
                
            }
            
            
        })
        task.resume()
        
        
    }
    func showErrorDialog(message:String){
        SweetAlert().showAlert("Alert", subTitle: message, style: AlertStyle.error)
    }
    func ProcessResponse(ResultFromServer: Dictionary<String, Any>){
        print("response = \(ResultFromServer)")
        delegate?.serviceCallResponse(ResultFromServer: ResultFromServer)
    }
    func showProgressDialog(message: String){
        progressDialog.progressText = message
        progressDialog.enableBlurBackground = false
        progressDialog.indicatorColor = CL.colorSunny
        progressDialog.showHUD()
    }
    
    func hideProgressDialog(){
        progressDialog.hideHUD()
    }
}
public protocol NetworkCallDelegate {
    func serviceCallResponse(ResultFromServer: Dictionary<String, Any>)
    
}
