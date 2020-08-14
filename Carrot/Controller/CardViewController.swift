//
//  CardViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 13/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import FirebaseStorage
import BarcodeScanner

class CardViewController: UIViewController {

    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func rescanCode(_ sender: Any) {
        let barcodeVC = BarcodeScannerViewController()
        barcodeVC.codeDelegate = self
        barcodeVC.errorDelegate = self
        barcodeVC.dismissalDelegate = self

        present(barcodeVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        cardCode.image = barcode
        controller.dismiss(animated: true, completion: nil)
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
                let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
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
