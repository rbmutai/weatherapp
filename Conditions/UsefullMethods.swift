//
//  UsefullMethods.swift
//  Conditions
//
//  Created by MAC USER on 09/06/2021.
//

import Foundation
import UIKit
class UsefullMethods{
    let prefs:UserDefaults
    init(){
        prefs = UserDefaults.standard
    }
    func showalerts(_ tle:String,mg:String,viewcontroller:UIViewController){
        
        let alert=UIAlertController(title: tle, message: mg, preferredStyle: .alert)
        let action=UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(action)
        viewcontroller.present(alert, animated: true, completion: nil)
        
    }
   
    func savetheme(data:String){
        prefs.setValue(data, forKey: "THEME")
    }
    func gettheme()->String{
       
        let theme=prefs.string( forKey: "THEME")
        if theme==nil {
            return ""
        }
        return prefs.string( forKey: "THEME")! as String
        
    }
    func savefavourites(data:String){
        prefs.setValue(data, forKey: "FAVOURITES")
    }
    func getfavourites()->String{
        
        let favs=prefs.string( forKey: "FAVOURITES")
        if favs==nil {
            return ""
        }
        return prefs.string( forKey: "FAVOURITES")! as String
       
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        
        var rgbValue:UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
