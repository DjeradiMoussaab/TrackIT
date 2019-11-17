//
//  QRScannerViewController.swift
//  TrackIT
//
//  Created by Mac on 11/16/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit

class QRScannerViewController: UIViewController {

    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                ChangeScreen(customerID: (qrData?.codeString!)!)
            }
        }
    }
    func ChangeScreen(customerID: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LuggagesController = storyBoard.instantiateViewController(withIdentifier: "LuggagesController") as! LuggagesController
        LuggagesController.customerID = customerID
        self.navigationController?.pushViewController(LuggagesController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerView.startScanning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func cancelButtonClick(_ sender: Any) {
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TrackingController = storyBoard.instantiateViewController(withIdentifier: "TrackingController") as! TrackingController
        self.navigationController?.pushViewController(TrackingController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
        print(qrData?.codeString! ?? "")
    }

}

