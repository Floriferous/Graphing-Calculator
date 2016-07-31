//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Florian Bienefelt on 6/30/16.
//  Copyright © 2016 Florian Bienefelt. All rights reserved.
//

import Foundation



class CalculatorBrain
{
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    var description = " "
    
    func setOperand(operand: String) {
        accumulator = Double(operand) ?? (variableValues[operand] ?? 0.0)
        internalProgram.append(operand)
    }
    
    var endOfDes = false
    var lastButton = (String(), String())
    
    func updateDescription(button: String) {
        
        if endOfDes {
            description = " "
            endOfDes = false
        }
        
        switch button {
        case "cos","sin","√":
            description = button + "(" + description + ")"
            endOfDes = true
        case "=": break
        case "M": description += button
        case "→M": endOfDes = true
        default:
            if (Int(button) != nil || button == "." || button == "π" || button == "e") {
                description += button
            } else {
                description += " " + button + " "
            }
        }
        
        if ((Int(lastButton.1) != nil || button == "π" || button == "e") && lastButton.0 == "=" && Int(button) != nil )
        {
            description = button
        }
        
        
        lastButton.1 = lastButton.0
        lastButton.0 = button
    }
    
    
    var variableValues = [String: Double]()
    
    
    func getDescription() -> (String, String) {
        
        if (isPartialResult) {
            return (description, " ...")
        } else
        {
            return (description, " =")
        }
    }
    
    
    var isPartialResult: Bool {
        get {
            return (pending != nil)
        }
    }
    
    
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "x^2" : Operation.UnaryOperation({ pow($0, 2) }),
        "10^x" : Operation.UnaryOperation({ pow(10, $0) }),
        "1/x" : Operation.UnaryOperation({ 1 / $0 }),
        "=" : Operation.Equals
    ]
    
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationinfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    private var pending: PendingBinaryOperationinfo?
    
    private struct PendingBinaryOperationinfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject //Is good for documentation, lets people know this not only is AnyObject, but also a property list
    
    
    // Understand this for assignment 2 when you want to add variables
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(String(operand))
                    } else if let operation = op as? String {
                        if (operation == "M") {
                            setOperand(operation)
                        } else {
                            performOperation(operation)
                        }
                    }
                }
            }
        }
    }
    
    func clear() {
        description = " "
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        variableValues.removeAll()
    }
    
    
    var result: Double {
        get {
            return accumulator
        } // This is a read only property because we only define the get, not the set
    }
}

















