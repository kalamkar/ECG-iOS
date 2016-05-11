//
//  ChartView.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/11/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation
import UIKit

class ChartView : UIView {
    
    private var data: [UInt8] = []
    private var updateCount: Int = 0
    
    func update(chunk: [UInt8]) {
        if (Config.GRAPH_LENGTH < (data.count + chunk.count)) {
            for _ in 0..<chunk.count {
                data.removeFirst()
            }
        }
        for i in 0..<chunk.count {
            data.append(chunk[i])
        }

        updateCount += 1
        if (updateCount >= 0 /* Config.GRAPH_UPDATE_INTERVAL */) {
            self.setNeedsDisplay()
            updateCount = 0
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef! = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context, 0, 0, 0.9, 0.8);
        CGContextSetLineWidth(context, 0.75);
        CGContextMoveToPoint(context, 0 ,0)
        for i in 0..<data.count {
            CGContextAddLineToPoint(context, getX(i), CGFloat(data[i]))
        }
        CGContextStrokePath(context);
    }
    
    func getX(x: Int) -> CGFloat {
        return CGFloat(x) * self.bounds.size.width / CGFloat(Config.GRAPH_LENGTH)
    }
    
    func getY(y: UInt8) -> CGFloat {
        return CGFloat(Config.SHORT_GRAPH_MAX - Int(y)) * self.bounds.size.height / CGFloat(Config.SHORT_GRAPH_MAX)
    }
}
