//
//  TrackingController.swift
//  TrackIT
//
//  Created by Mac on 11/15/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit

class TrackingController: UIViewController {

    @IBOutlet weak var trackingButton: UIButton!
    @IBOutlet weak var QRcodeButton: UIButton!
    @IBOutlet weak var customerIDTextField: UITextField!
    var customerID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        customerIDTextField.layer.cornerRadius = 8.0
        customerIDTextField.clipsToBounds = true
        QRcodeButton.layer.cornerRadius = 8.0
        trackingButton.layer.cornerRadius = 8.0

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func TrackingButtonClick(_ sender: Any) {
        self.customerID = customerIDTextField.text!
        self.ChangeScreen()
    }
    
    @IBAction func QRCodeButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let QRScannerViewController = storyBoard.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        self.navigationController?.pushViewController(QRScannerViewController, animated: true)
    }
    
    
    func ChangeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LuggagesController = storyBoard.instantiateViewController(withIdentifier: "LuggagesController") as! LuggagesController
        LuggagesController.customerID = customerID
        self.navigationController?.pushViewController(LuggagesController, animated: true)
    }
    
    

}
