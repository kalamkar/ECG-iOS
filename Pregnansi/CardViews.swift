//
//  CardViews.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/28/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

// Tag Numbers for card subviews
// Title   1
// Text    2
// Image   3
// Icon    4
// Decor   5

import UIKit

class CardView: UICollectionViewCell {
    var titleView: UILabel?
    var textView: UILabel?
    var photoView: UIImageView?
    var iconView: UIImageView?
    var decorView: UIImageView?
    
    var card: Card?
    var title: String?
    var text: String?
    
    func setData(card: Card) {
        titleView = viewWithTag(1) as? UILabel
        textView = viewWithTag(2) as? UILabel
        photoView = viewWithTag(3) as? UIImageView
        iconView = viewWithTag(4) as? UIImageView
        decorView = viewWithTag(5) as? UIImageView
        
        self.card = card
        title = card.getTitle()
        text = card.getText()
        
        if (titleView != nil && title != nil) {
            titleView?.text = title
        } else if (titleView != nil) {
            titleView?.hidden = true
        }

        if (textView != nil && text != nil) {
            textView?.text = text
        } else if (textView != nil) {
            textView?.hidden = true
        }

        if (photoView != nil && card.image != nil) {
            downloadImage(card.image!, imageView: photoView!)
        } else if (photoView != nil) {
            let index: Int = abs((self.card?.text?.hashValue)!) % Config.BACKGROUND_IMAGES.count
            downloadImage(Config.BACKGROUND_IMAGES[index], imageView: photoView!)
        }
        
        if (iconView != nil && card.icon != nil) {
            downloadImage(card.icon!, imageView: iconView!)
        } else if (iconView != nil) {
            iconView?.hidden = true
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data)
        }.resume()
    }
    
    func downloadImage(url: String, imageView: UIImageView){
        getDataFromUrl(NSURL(string: url)!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = UIImage(data: data!)
            }
        }
    }
    
    func setRandomDecoration(array: [String]) {
        let index: Int = abs((card?.text?.hashValue)!) % array.count
        let background: String = array[index]
        self.decorView?.image = UIImage(named: background + ".png")!
    }
}

class SizeCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.BOTTOM_LEFT_DECOR)
        titleView?.text = card.text
        let trimesterView: UILabel? = viewWithTag(12) as? UILabel
        let weekView: UILabel? = viewWithTag(13) as? UILabel
        let progressView: UIProgressView? = viewWithTag(14) as? UIProgressView
        
        // TODO(abhi): get real data here
        trimesterView?.text = "2nd"
        weekView?.text = "23rd"
        progressView?.setProgress(0.62, animated: false)
    }
}

class TipCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
    }
}

class PollCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.BOTTOM_RIGHT_DECOR)
    }
}

class SymptomCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.BOTTOM_RIGHT_DECOR)

        // TODO(abhi): Implement the interaction
//        let slider: UISlider? = viewWithTag(11) as? UISlider
//        let selectionView: UILabel? = viewWithTag(12) as? UILabel
//        let submitButton: UIButton? = viewWithTag(13) as? UIButton
    }
}

class VoteCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
    }
}

class ActionCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.BOTTOM_LEFT_DECOR)
        
        let actionButton: UIButton? = viewWithTag(11) as? UIButton
        let actionIcon: UIImageView? = viewWithTag(12) as? UIImageView
        
        let action: Card.Action = card.getAction()
        if let actionTextIcon: [String] = Config.ACTION_TEXT_ICONS[action] {
            actionButton?.titleLabel?.text = actionTextIcon[0]
            actionIcon?.image = UIImage(named: actionTextIcon[1])
        }
    }
}

class ToDoCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
    }
}

class InsightCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.CENTER_DECOR)
    }
}

class BasicCard: CardView {
    override func setData(card: Card) {
        super.setData(card)
        setRandomDecoration(Config.CENTER_DECOR)
    }
}
