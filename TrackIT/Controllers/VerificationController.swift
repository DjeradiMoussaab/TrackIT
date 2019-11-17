//
//  VerificationController.swift
//  TrackIT
//
//  Created by Mac on 11/17/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit
import ProgressStepView

class VerificationController: UIViewController {
    @IBOutlet weak var saveView: BorderRadiusView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var confirmButton: BorderRadiusButton!
    @IBOutlet weak var cancelButton: BorderRadiusButton!
    @IBOutlet weak var stepONE: UILabel!
    @IBOutlet weak var stepTWO: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    var firstString = ""
    var secondString = ""
    var progress: ProgressStepView = .init()
    
    var qrCode: UIImage? {
        if let img = createQRFromString(str: "Hello world program created by someone") {
            let someImage = UIImage(
                ciImage: img,
                scale: 0.1,
                orientation: UIImage.Orientation.down
            )
            return someImage
        }
        
        return nil
    }
    
    
    
    private func createQRFromString(str: String) -> CIImage? {
        let stringData = str.data(using: .utf8)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }
    

    @IBOutlet weak var scannerView: QRScannerView!  {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                if ( firstString == "" ) {
                    confirmButton.isHidden = false
                    cancelButton.isHidden = false
                } else {
                    secondString = (qrData?.codeString)!
                    verifyTwoCodes(firstCode: firstString, secondCode: secondString)
                }
            }
        }
    }
    
    func verifyTwoCodes(firstCode: String, secondCode: String) {
        if (firstCode == secondCode) {
            progress.progress = 1.0
            qrCodeImage.image = qrCode
            guard let ciImage = qrCodeImage.image!.ciImage else { return }
            guard let cgImage = cgImage(from: ciImage) else { return } // the above function
            let newImage = UIImage(cgImage: cgImage) // ready to be saved!
            qrCodeImage.image = newImage
            saveView.isHidden = false
        } else {
            progress.progress = 0.0
            firstString = ""
            secondString = ""
            if !self.scannerView.isRunning {
                self.scannerView.startScanning()
            }
        }
    }
    
    @IBAction func saveImageButtonClick(_ sender: Any) {
        saveView.isHidden = true
        UIImageWriteToSavedPhotosAlbum(qrCodeImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    func cgImage(from ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("error")
        } else {
            print("saved")
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func cancelButtonClick(_ sender: Any) {
        progress.progress = 0.0
        firstString = ""
        if !self.scannerView.isRunning {
            self.scannerView.startScanning()
        }
        confirmButton.isHidden = true
        cancelButton.isHidden = true
    }
    @IBAction func confirmButtonClick(_ sender: Any) {
        firstString = (qrData?.codeString)!
        progress.progress = 0.5
        if !self.scannerView.isRunning {
            self.scannerView.startScanning()
        }
        confirmButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsLabel.layer.shadowColor = UIColor.black.cgColor
        instructionsLabel.layer.shadowRadius = 3.0
        instructionsLabel.layer.shadowOpacity = 1.0
        instructionsLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        instructionsLabel.layer.masksToBounds = false
        
        stepONE.layer.shadowColor = UIColor.black.cgColor
        stepONE.layer.shadowRadius = 3.0
        stepONE.layer.shadowOpacity = 1.0
        stepONE.layer.shadowOffset = CGSize(width: 2, height: 2)
        stepONE.layer.masksToBounds = false
        
        stepTWO.layer.shadowColor = UIColor.black.cgColor
        stepTWO.layer.shadowRadius = 3.0
        stepTWO.layer.shadowOpacity = 1.0
        stepTWO.layer.shadowOffset = CGSize(width: 2, height: 2)
        stepTWO.layer.masksToBounds = false
        
        progress = {
            let progress = ProgressStepView(frame: self.view.bounds)
            progress.numberOfPoints = 2
            progress.spacing = 2.0
            progress.progressLineHeight = 12
            progress.circleRadius = 30
            progress.layer.shadowColor = UIColor.black.cgColor
            progress.layer.shadowRadius = 3.0
            progress.layer.shadowOpacity = 1.0
            progress.layer.shadowOffset = CGSize(width: 2, height: 2)
            progress.layer.masksToBounds = false
            progress.circleTintColor = .yellow
            progress.circleStrokeWidth = 2.5
            progress.circleColor = .white

            progress.translatesAutoresizingMaskIntoConstraints = false
            return progress
        }()
        
        self.view.addSubview(progress)

        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progress.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        progress.progress = 0.0
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
}
extension VerificationController: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
        print(qrData?.codeString! ?? "")
    }
    
}
