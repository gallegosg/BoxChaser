//
//  OptionsVC.swift
//  GetTheDot
//
//  Created by Gerardo Gallegos on 9/11/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftySound
//import SwiftyStoreKit
//import StoreKit

/*
var sharedSecret = "a4420cfdadeb45ca959688917d4d25dc"

 RegisteredPurchase : String {
    case RemoveAds
    
}



class NetworkActivityIndicatorManager : NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    class func networkOperationFinished(){
        if loadingCount > 0 {
            loadingCount -= 1
            
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
    }
}
*/
class OptionsVC: UIViewController {

    
    @IBOutlet weak var muteSwitch: UISwitch!
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    @IBOutlet weak var blackOutlet: UIButton!
    @IBOutlet weak var yellowOutlet: UIButton!
    @IBOutlet weak var orangeOutlet: UIButton!
    @IBOutlet weak var greenOutlet: UIButton!
    @IBOutlet weak var purpleOutlet: UIButton!
    @IBOutlet weak var blueOutlet: UIButton!
    
    var array: [UIButton]!

    /*
    let appBundleId = "com.GerGal.BoxChaser"
    
    var RemoveAds = RegisteredPurchase.RemoveAds
    */
    let totalScore = UserDefaults.standard.integer(forKey: "totalScore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make view landscape
        //let value = UIInterfaceOrientation.landscapeRight.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        
        //BORDER
        self.view?.layer.borderWidth = 1
        self.view?.layer.borderColor = UIColor.red.cgColor
        
        muteSwitch.isOn = UserDefaults.standard.bool(forKey: "muteSwitchState")
        muteSwitch.onTintColor = UIColor(red: 0.90, green: 0, blue: 0.01, alpha: 1)
        
        //removeAdsButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        totalScoreLabel.text = "Total Score: \(totalScore)"
        
        
        
        //set button tags and targets
        blackOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        yellowOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        orangeOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        greenOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        purpleOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        blueOutlet.addTarget(self, action: #selector(checkSelected(sender:)), for: .touchUpInside)
        
        blackOutlet.tag = 0
        yellowOutlet.tag = 1
        orangeOutlet.tag = 2
        greenOutlet.tag = 3
        purpleOutlet.tag = 4
        blueOutlet.tag = 5
        
        array = [blackOutlet, yellowOutlet, orangeOutlet, greenOutlet, purpleOutlet, blueOutlet]

    
        //SELECT last color used when closing screen
        for item in array{
            if item.tag == UserDefaults.standard.integer(forKey: "colorTag"){
                item.layer.cornerRadius = 30
                item.layer.borderWidth = 4
                if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                    item.layer.cornerRadius = 50
                    item.layer.borderWidth = 6
                }
                item.layer.borderColor = UIColor.red.cgColor
            }
        }

        
        //Check which balls have been unlocked
        checkBallsUnlocked()
        
    }
    
    
    // configure supported orientations to landscape right
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    //disble autorotate
    override var shouldAutorotate: Bool {
        return false
    }
   
    //hide status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }

    @IBAction func muteSwitchAction(_ sender: Any) {
        
        UserDefaults.standard.set(muteSwitch.isOn, forKey: "muteSwitchState")

        if muteSwitch.isOn {
            print("sound is on")
            Sound.enabled = true
            Sound.play(file: "menu", fileExtension: ".mp3", numberOfLoops: -1)

        } else {
            print("sound is off")
            Sound.enabled = false

        }
    }
    
    @IBAction func removeAdsAction(_ sender: Any) {
        //purchase(RemoveAds)
        //turn off purchases for now
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    //check the collr chosen and save
    @objc func checkSelected(sender:UIButton) {
        array = [blackOutlet, yellowOutlet, orangeOutlet, greenOutlet, purpleOutlet, blueOutlet]

        
        sender.layer.cornerRadius = 30
        sender.layer.borderWidth = 4
        sender.layer.borderColor = UIColor.red.cgColor
        
        UserDefaults.standard.set(sender.tag, forKey: "colorTag")
        for item in array {
            if item.tag != sender.tag {
                item.layer.borderWidth = 0
            }
        }
    }
    
    //Check which balls have been unlocked
    //CHange to increments of 1000 before release
    //100 just for testing
    func checkBallsUnlocked(){
        if totalScore >= 500 {
            yellowOutlet.isHidden = false
        }
        if totalScore >= 1000 {
            orangeOutlet.isHidden = false
        }
        if totalScore >= 1500 {
            greenOutlet.isHidden = false
        }
        if totalScore >= 2000 {
            purpleOutlet.isHidden = false
        }
        if totalScore >= 2500 {
            blueOutlet.isHidden = false
        }
    }
    
    
    
    //CHOOSE BALL COLOR
    @IBAction func black(_ sender: Any) {
        UserDefaults.standard.set("black", forKey: "userBall")
    }
    @IBAction func yellow(_ sender: Any) {
        UserDefaults.standard.set("yellow", forKey: "userBall")
    }
    @IBAction func orange(_ sender: Any) {
        UserDefaults.standard.set("orange", forKey: "userBall")
    }
    @IBAction func green(_ sender: Any) {
        UserDefaults.standard.set("green", forKey: "userBall")
    }
    @IBAction func purple(_ sender: Any) {
        UserDefaults.standard.set("purple", forKey: "userBall")
    }
    @IBAction func blue(_ sender: Any) {
        UserDefaults.standard.set("blue", forKey: "userBall")
    }
    
    //////////////////////////////////////////////////////////////////////
    
    
    /*
    //////////////////////////////////////////////////////////////////////
    //IN APP PURCHASE
    //AD REMOVAL CODE/////////////////////////////////////////////////////

    func getInfo(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([appBundleId + "." + purchase.rawValue]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    func purchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(appBundleId + "." + purchase.rawValue, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                
                //turn ads off if user purchase is successful
                UserDefaults.standard.set(true, forKey: "adsRemoved")
                print("Ads Removed")
                
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    @IBAction func restorePurchases() {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                // Deliver content from server, then:
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    @IBAction func verifyReceipt() {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production)
        let password = sharedSecret
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: password, completion: completion)
    }
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                
                let productId = self.appBundleId + "." + purchase.rawValue
                
                switch purchase {
              
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt
                    )
                    self.showAlert(self.alertForVerifyPurchase(purchaseResult))
                }
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    #if os(iOS)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    #endif
}

// MARK: User facing alerts
extension UIViewController {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return alertWithTitle("Thank You", message: "Purchase completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult) -> UIAlertController {
        
        switch result {
        case .purchased:
            print("Product is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
 */
}
