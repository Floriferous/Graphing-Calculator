//
//  GraphView.swift
//  calculator2
//
//  Created by Florian Bienefelt on 7/3/16.
//  Copyright © 2016 Florian Bienefelt. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    let axes = AxesDrawer()
    @IBInspectable
    var ppu: CGFloat = 20 { didSet { setNeedsDisplay() } }
    
    var origin: CGPoint = CGPoint() { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            ppu *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    func changeOrigin(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            let translation = recognizer.translationInView(self)
            origin = CGPoint(x: origin.x + translation.x, y: origin.y + translation.y)
        default: break
        }
        recognizer.setTranslation(CGPointZero, inView: self)
    }
    
    func setTheOrigin(recognizer: UITapGestureRecognizer) {
        recognizer.numberOfTapsRequired = 2
        switch recognizer.state {
        case .Ended:
            let newOrigin = recognizer.locationInView(self)
            origin = CGPoint(x: newOrigin.x, y: newOrigin.y)
        default: break
        }
    }
    
    var drawFunc = UIBezierPath()
    
//    func makeFunc() {
//        
//        drawFunc.removeAllPoints()
//        drawFunc.moveToPoint(CGPoint(x: -10000, y: 0))
//        
//        for xPoint in 0...Int(bounds.width) {
//            let axesX: CGFloat = (CGFloat(xPoint) - origin.x) / ppu
//            let axesY: CGFloat = 4 //find axesY with axesX
//            let yPoint: CGFloat = origin.y - (axesY * ppu)
//            
//            drawFunc.addLineToPoint(CGPoint(x: CGFloat(xPoint), y: yPoint))
//        }
//    }
    
    func addPoint(pt: CGPoint) {
        drawFunc.addLineToPoint(pt)
    }
    
    
    override func drawRect(rect: CGRect) {
        
        axes.drawAxesInRect(
            CGRect(
                x: 0, y: 0,
                width: bounds.size.width, height: bounds.size.height),
            origin: origin,
            pointsPerUnit: CGFloat(ppu)
        )
        
        UIColor.blackColor().set()
        drawFunc.lineWidth = 2.0
        drawFunc.stroke()
    }
    
    func reset() {
        origin = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
