//
//  ViewController.swift
//  PayPalIntegration
//
//  Created by Abraham VG on 27/10/18.
//  Copyright © 2018 Wis. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree


class ViewController: UIViewController {
    
    var clientToken = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchClientToken()
    }
    
    func fetchClientToken() {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            print("clientToken = \(clientToken!)😄")
            self.clientToken = clientToken!
            
            }.resume()
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                print("result = \(result)😄")
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    @IBAction func payAction(_ sender: Any) {
        
        showDropIn(clientTokenOrTokenizationKey: clientToken)
    }
    


}

