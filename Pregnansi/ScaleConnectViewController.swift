//
//  ScaleConnectViewController.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/27/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScaleConnectViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var success: UIImageView!
    
    @IBOutlet weak var helpView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        let app: AppDelegate = Utils.sharedInstance()
        app.scaleClient.scanScales() {
            peripheral -> Void in
            
            self.spinner.stopAnimating()
            Utils.setWeighingScale(peripheral.identifier)
            
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
}
