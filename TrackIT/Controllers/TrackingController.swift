//
//  TrackingController.swift
//  TrackIT
//
//  Created by Mac on 11/15/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit

class TrackingController: UIViewController {

    @IBOutlet weak var customerIDTextField: UITextField!
    var customerID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func TrackingButtonClick(_ sender: Any) {
        self.customerID = customerIDTextField.text!
        self.ChangeScreen()
    }
    
    func ChangeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LuggagesController = storyBoard.instantiateViewController(withIdentifier: "LuggagesController") as! LuggagesController
        LuggagesController.customerID = customerID
        self.navigationController?.pushViewController(LuggagesController, animated: true)
    }
    
    

}
