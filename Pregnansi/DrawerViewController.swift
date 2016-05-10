//
//  DrawerViewController.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/25/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import UIKit

class DrawerViewController: UITableViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var email: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        onUserUpdated()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onUserUpdated",
            name: Config.USER_UPDATED, object: nil)
        // self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "flowers.png")!)
    }

    @IBAction func onHome(sender: AnyObject) {
        self.performSegueWithIdentifier("showHome", sender: nil)
    }
    
    @IBAction func onInsights(sender: AnyObject) {
//        self.performSegueWithIdentifier("showInsights", sender: nil)
        let storyboard = UIStoryboard(name: "Independent", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ScaleConnect")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func onBrowse(sender: AnyObject) {
        self.performSegueWithIdentifier("showBrowse", sender: nil)
    }
    
    @IBAction func onDueDate(sender: AnyObject) {
        self.performSegueWithIdentifier("showDueDate", sender: nil)
    }
    
    @IBAction func onHelp(sender: AnyObject) {
        self.performSegueWithIdentifier("showHelp", sender: nil)
    }
    
    @IBAction func onAbout(sender: AnyObject) {
        self.performSegueWithIdentifier("showAbout", sender: nil)
    }
    
    func onUserUpdated() {
        let app = Utils.sharedInstance();
        if (app.user != nil) {
            name.setTitle(app.user!.name, forState: .Normal)
            email.setTitle(app.user!.email, forState: .Normal)
        }
    }
}
