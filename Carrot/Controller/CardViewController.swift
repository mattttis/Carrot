//
//  CardViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 13/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import BarcodeScanner
import Kingfisher

class CardViewController: UIViewController {

    var currentBrightNess: CGFloat? = nil
    let dbRef = Firestore.firestore().collection(K.FStore.users).document(Auth.auth().currentUser!.uid)
    let listID = UserDefaults.standard.string(forKey: "listID")
    let storageRef = Storage.storage().reference().child(K.FStore.users).child(Auth.auth().currentUser!.uid).child(K.User.barcodeImage)
    var image: UIImage?
    
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let code = UserDefaults.standard.string(forKey: K.User.barcodeNumber) {
            self.cardNumber.text = code
            
            if let barcode = BarCodeI.generateBarcode(from: code) {
                self.cardCode.image = barcode
                self.cardCode.backgroundColor = UIColor.white
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        currentBrightNess = UIScreen.main.brightness
        setBrightness(to: CGFloat(1.0))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setBrightness(to: currentBrightNess!)
    }
    
    @IBAction func rescanCode(_ sender: Any) {
        
        let headerLabel = NSLocalizedString("Scan barcode",
        comment: "Displayed in the scanner view controller")
        
        let headerButtonCancel = NSLocalizedString("Cancel",
        comment: "Displayed in the scanner view controller to cancel modal")
        
        let messageText = NSLocalizedString("You don't have to press anything, we will start scanning automatically once we detect a barcode within the window.",
        comment: "Displayed in the scanner view controller to explain the scanning process")
        
        
        let barcodeVC = BarcodeScannerViewController()
        barcodeVC.headerViewController.titleLabel.text = String.localizedStringWithFormat(headerLabel)
        barcodeVC.headerViewController.closeButton.setTitle(String.localizedStringWithFormat(headerButtonCancel), for: .normal)
        
        barcodeVC.messageViewController.textLabel.text = String.localizedStringWithFormat(messageText)
        barcodeVC.headerViewController.titleLabel.tintColor = UIColor.label
        barcodeVC.headerViewController.closeButton.tintColor = UIColor.label
        barcodeVC.codeDelegate = self
        barcodeVC.errorDelegate = self
        barcodeVC.dismissalDelegate = self

        present(barcodeVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func setBrightness(to value: CGFloat, duration: TimeInterval = 0.3, ticksPerSecond: Double = 120) {
        let startingBrightness = UIScreen.main.brightness
        let delta = value - startingBrightness
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond

        let time = DispatchTime.now()

        for i in 1...totalTicks {
            DispatchQueue.main.asyncAfter(deadline: time + delayBetweenTicks * Double(i)) {
                UIScreen.main.brightness = max(min(startingBrightness + (changePerTick * CGFloat(i)),1),0)
            }
        }
    }
    
    func saveImage() {
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.005) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://carrot-ios.appspot.com")
        let storageProfileRef = storageRef.child(K.FStore.users).child(Auth.auth().currentUser!.uid).child(K.User.barcodeImage)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if let e = error {
                print("Error uploading profile picture: \(e.localizedDescription)")
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageURL = url?.absoluteString {
                    self.dbRef.updateData([
                        K.User.barcodeImage: metaImageURL
                    ])
                }
            }
        }
    }
}

//MARK: - Delegate methods of the BarcodeScanner
extension CardViewController: BarcodeScannerCodeDelegate {
    
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    
    cardNumber.text = code
    print("Barcode Data: \(code)")
    print("Symbology Type: \(type)")
    
    cardCode.image = nil
    
    if let barcode = BarCodeI.generateBarcode(from: code) {
        image = barcode
        saveImage()
        cardCode.image = barcode
        cardCode.backgroundColor = UIColor.white
        controller.dismiss(animated: true, completion: nil)
        
        // Save code to Firestore list
        let ref = Firestore.firestore().collection(K.FStore.lists).document(listID!)
        ref.updateData([
            K.User.barcodeNumber: code
        ])
        
        UserDefaults.standard.set(code, forKey: K.User.barcodeNumber)
        UserDefaults.standard.synchronize()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      controller.resetWithError()
    }
    
  }
}

// MARK: - BarcodeScannerErrorDelegate
extension CardViewController: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}

// MARK: - BarcodeScannerDismissalDelegate
extension CardViewController: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

// MARK: - Generate barcode from string
class BarCodeI {
    class func generateBarcode(from string: String) -> UIImage? {
        print("generateBarCode: \(string)")
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            
            //Margin
            filter.setValue(7.00, forKey: "inputQuietSpace")
            filter.setValue(data, forKey: "inputMessage")
            
            //Scaling
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let context:CIContext = CIContext.init(options: nil)
                let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
                let rawImage:UIImage = UIImage.init(cgImage: cgImage)
                
                
                let cgimage: CGImage = (rawImage.cgImage)!
                // let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
                let cropZone = CGRect(x: 0, y: 0, width: Int(280), height: Int(110))
                let cWidth: size_t  = size_t(cropZone.size.width)
                let cHeight: size_t  = size_t(cropZone.size.height)
                let bitsPerComponent: size_t = cgimage.bitsPerComponent
                let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)
                
                let context2: CGContext = CGContext(data: nil, width: cWidth, height: cHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!
                
                context2.draw(cgimage, in: cropZone)
                
                let result: CGImage  = context2.makeImage()!
                let finalImage = UIImage(cgImage: result)
                
                return finalImage
            }
        }
        return nil
    }
}
