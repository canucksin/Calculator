//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Farzin Faghihi on 2017-03-12.
//  Copyright © 2017 Farzin Faghihi. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    var description = " "
    private var lastDescriptionValue = ""
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "±": Operation.unaryOperation({ -$0 }),
        "√": Operation.unaryOperation(sqrt),
        "π": Operation.constant(Double.pi),
        "%": Operation.unaryOperation({ $0 / 100 }),
        "xⁿ": Operation.binaryOperation(pow),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                if (resultIsPending) {
                    description = description.replacingOccurrences(of: lastDescriptionValue, with: "")
                    description += symbol
                } else {
                    description = symbol
                }
                lastDescriptionValue = symbol
            case .unaryOperation(let function):
                if (accumulator != nil) {
                    if (resultIsPending) {
                        description = description.replacingOccurrences(of: lastDescriptionValue, with: "")
                        let currentDescriptionValue = symbol + "(" + lastDescriptionValue + ")"
                        description += currentDescriptionValue
                        lastDescriptionValue = currentDescriptionValue
                    } else {
                        let currentDescriptionValue = symbol + "(" + description + ")"
                        description = currentDescriptionValue
                        lastDescriptionValue = currentDescriptionValue
                    }
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                performPendingBinaryOperation()
                if (accumulator != nil) {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    description += symbol
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = nil
                description = " "
                pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if (resultIsPending && accumulator != nil) {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if (resultIsPending) {
            description += String(accumulator!)
            lastDescriptionValue = String(accumulator!)
        } else {
            description = String(accumulator!)
        }
    }
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil ? true : false
    }
    
    var result: Double? {
        return accumulator
    }
}
