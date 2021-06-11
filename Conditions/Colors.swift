//
//  Colors.swift
//  Conditions
//
//  Created by MAC USER on 09/06/2021.
//

import Foundation
import UIKit
class Colors{
    let am = UsefullMethods()
    var colorSunny: UIColor!
    var colorCloudy: UIColor!
    var colorRainy: UIColor!
    init() {
        colorSunny = am.hexStringToUIColor("47AB2F")
        colorCloudy = am.hexStringToUIColor("54717A")
        colorRainy = am.hexStringToUIColor("57575D")
    }
}
