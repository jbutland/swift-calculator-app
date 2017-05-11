//
//  CalculatorModel.swift
//  Calculator
//
//  Created by jonnynoise on 5/9/17.
//  Copyright © 2017 jbutland. All rights reserved.
//

import Foundation



struct CalculatorController {
    
    private var accumulator: Double?
    private var op1: Double?
    private var resultIsPending: Bool = false
    private var descriptiom: String?
    
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case percentOperation((Double,Double) -> Double)
        case equals
        case allClear
    }

    private var operations: Dictionary<String, Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "∛" : Operation.unaryOperation({pow($0, (1/3))}),
        "x²" : Operation.unaryOperation({pow($0, 2)}),
        "x³" : Operation.unaryOperation({pow($0, 3)}),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "±" : Operation.unaryOperation({-$0}),
        "ʸ√" : Operation.binaryOperation({pow($0, (1/$1))}),
        "✕" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "xʸ" : Operation.binaryOperation({pow($0, $1)}),
        "%" : Operation.percentOperation({$0 * ($1/100)}),
        "=" : Operation.equals,
        "AC" : Operation.allClear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                   accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    op1 = accumulator
                    accumulator = nil
                }
            case .percentOperation(let function):
                if accumulator != nil{
                    if op1 == nil{
                        op1 = 1
                    }
                    getPercent = PendingBinaryOperation(function: function, firstOperand: op1!)
                    returnPercent()

                }
            case .equals:
                performPendingBinaryOperation()

            case .allClear:
                allClear();
                
            }
        
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private mutating func returnPercent(){
        if getPercent != nil && accumulator != nil {
            accumulator = getPercent!.perform(with: accumulator!)
            getPercent = nil
        }
    }
    
    private mutating func allClear()
    {
        accumulator = 0.0;
        pendingBinaryOperation = nil
        getPercent = nil
    }
    
    private var getPercent: PendingBinaryOperation?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
                return accumulator            }
        
    }
}
