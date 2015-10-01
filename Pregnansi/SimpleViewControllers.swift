//
//  SimpleViewControllers.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/27/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//


import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: Config.HELP_URL)
        helpView.loadRequest(NSMutableURLRequest(URL: url!))
    }
}

class AboutViewController: UIViewController {
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.version.text = version
        }
    }
}


class TopBarViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

class DueDateViewController: UIViewController {
    @IBOutlet weak var dueDate: UIDatePicker!

    @IBAction func onOK(sender: AnyObject) {
        let millis: Int = Int(dueDate.date.timeIntervalSince1970) * 1000
        UserUpdate.init(feature: "DUE_DATE_MILLIS=\(millis)").execute()
        print("DUE_DATE_MILLIS=\(millis)")
    }
}
