//
//  CalculatorBrain.swift
//  Calculator 2.0
//
//  Created by Nicholas Ionata on 7/21/16.
//  Copyright © 2016 Frums Studio. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "cos": Operation.UnaryOperation(cos),
        "√": Operation.UnaryOperation(sqrt),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "×": Operation.BinaryOperation({ $0 * $1}),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryFunctionInfo(binaryFunction: function, firstOperand: accumulator)
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
    
    private var pending: PendingBinaryFunctionInfo?
    
    private struct PendingBinaryFunctionInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
        
    }
}