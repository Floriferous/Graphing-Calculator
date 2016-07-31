//
//  GraphViewController.swift
//  calculator2
//
//  Created by Florian Bienefelt on 7/3/16.
//  Copyright © 2016 Florian Bienefelt. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    private var brain2 = CalculatorBrain()
    
    @IBOutlet weak var graphView: GraphView!
        {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,
                action: #selector(GraphView.changeScale(_:))
                ))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(
                target: graphView,
                action: #selector(GraphView.changeOrigin(_:))
                ))
            
            graphView.addGestureRecognizer(UITapGestureRecognizer(
                target: graphView,
                action: #selector(GraphView.setTheOrigin(_:))
                ))
            
            updateUI();
            
            graphView.reset()
        }
    }
    
    
    private func updateUI() {
        
    }
    
    var currentProgram = [AnyObject]()
    
    func drawGraph() {
        graphView.drawFunc.removeAllPoints()
        graphView.drawFunc.moveToPoint(CGPoint(x: -10000, y: 0))
        
        for xPoint in 0...Int(graphView.bounds.width) {
            
            let axesX: CGFloat = (CGFloat(xPoint) - graphView.origin.x) / graphView.ppu
            let axesY: CGFloat = CGFloat(calcProgram(currentProgram, xVariable: Double(axesX)))
            let yPoint: CGFloat = graphView.origin.y - (axesY * graphView.ppu)
            
            graphView.addPoint(CGPoint(
                x: CGFloat(xPoint),
                y: yPoint))
            
            //print("x = \(axesX), y = \(axesY)")
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        drawGraph()
    }
    
    override func viewDidAppear(animated: Bool) {
        drawGraph()
    }
    
    
    func calcProgram(program: AnyObject?, xVariable: Double) -> Double {
        
        //print("prog = \(program), x = \(xVariable)")
        
        if var programArray = program as? [AnyObject] {
            if (programArray.count > 0) {
                for i in 0...(programArray.count - 1) {
                    if let variable = programArray[i] as? String {
                        if (variable == "M") {
                            programArray[i] = xVariable
                        }
                    }
                }
            }
            print("prog = \(programArray), x = \(xVariable)")
            if program != nil {
                brain2.program = programArray
                return brain2.result
            }
        }
        
        return 0.0
        
    }
    
    
}


