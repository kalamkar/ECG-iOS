//
//  CardsViewController.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import UIKit

class CardsViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onUserUpdated",
                name: Config.USER_UPDATED, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let credentials: [String]? = Utils.getStoredCredentials()
        if (credentials == nil) {
            let storyboard = UIStoryboard(name: "Independent", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUp")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onUserUpdated() {
        let app = Utils.sharedInstance();
        if (app.user != nil) {
            print("We have user \(app.user!.name!) with \(app.user!.cards.count) cards.")
//            for card: Card in app.user!.cards {
//                print("title = \(card.getTitle()) text=\(card.getText())")
//            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.reloadData()
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let app = Utils.sharedInstance();
        if (app.user == nil || app.user?.cards == nil) {
            return 0
        }
        return (app.user?.cards.count)!
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let app = Utils.sharedInstance();

        if (app.user == nil || indexPath.item >= app.user?.cards.count) {
            print("User or card at \(indexPath.item) not available")
            return collectionView.dequeueReusableCellWithReuseIdentifier("basic", forIndexPath: indexPath)
        }
        let card: Card = (app.user?.cards[indexPath.item])!
        let reuseIdentifier = getCardUIIdentifier(card)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        (cell as? CardView)?.setData(card)
        return cell
    }
    
    func getCardUIIdentifier(card: Card) -> String {
        switch(card.getType()) {
        case Card.Type.SIZE:
            return "size"
        case Card.Type.TODO:
            return "todo"
        case Card.Type.VOTE:
            return "chart"
        case Card.Type.TIP:
            return "tip"
        case Card.Type.MILESTONE:
            return "tip"
        case Card.Type.CARE:
            return "action"
        case Card.Type.SYMPTOM:
            return "symptom"
        case Card.Type.POLL:
            return "poll"
        case Card.Type.INSIGHT:
            return "insight"
        default:
            return card.getAction() == Card.Action.NONE ? "basic" : "action"
        }
    }
}


