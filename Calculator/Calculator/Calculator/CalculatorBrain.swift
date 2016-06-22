//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Shridhar Bhalekar on 6/20/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2;
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand : Double
    }
    
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value;
            case .UnaryOperation(let function):
                accumulator = function(accumulator);
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            }
        }
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
