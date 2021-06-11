//
//  Themes.swift
//  Conditions
//
//  Created by MAC USER on 11/06/2021.
//

import UIKit

class Themes: UIViewController {

    @IBOutlet weak var imtheme: UIImageView!
    @IBOutlet weak var lbtheme: UILabel!
    let um=UsefullMethods()
    var theme=""
    override func viewDidLoad() {
        super.viewDidLoad()
        theme=um.gettheme()
        if(theme==""){
            theme="FOREST"
            um.savetheme(data: theme)
        }
        
        lbtheme.text=theme
        // Do any additional setup after loading the view.
    }
    @IBAction func forestPressed(_ sender: UIButton) {
        settheme(data: "FOREST")
    }
    @IBAction func seaPressed(_ sender: UIButton) {
        settheme(data: "SEA")
    }
    func settheme(data:String){
        if(data=="FOREST"){
            imtheme.image=UIImage(named: "forest_sunny")
        }else{
            imtheme.image=UIImage(named: "sea_sunnypng")
        }
        lbtheme.text=data
        um.savetheme(data: data)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
