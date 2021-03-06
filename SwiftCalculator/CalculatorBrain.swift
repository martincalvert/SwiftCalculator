//
//  CalculatorBrain.swift
//  SwiftCalculator
//
//  Created by Martin Calvert on 8/10/15.
//  Copyright (c) 2015 Martin Calvert. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var history = String?()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("➕", +))
        learnOp(Op.BinaryOperation("✖️", *))
        learnOp(Op.BinaryOperation("➖") { $1 - $0 })
        learnOp(Op.BinaryOperation("➗") { $1 / $0 })
        learnOp(Op.UnaryOperation("√") { sqrt($0) })
        learnOp(Op.UnaryOperation("sin") { sin($0) })
        learnOp(Op.UnaryOperation("cos") { cos($0) })
    }
    var program: AnyObject{
        get{
            return opStack.map { $0.description }
        }
        set{
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remaingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(let symbol, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    history! += "(\(operand) \(symbol)) "
                    return (operation(operand), operandEvaluation.remaingOps )
                }
            case .BinaryOperation(let symbol, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remaingOps)
                    if let operand2 = op2Evaluation.result{
                        history! += "(\(operand1) \(symbol) \(operand2)) "
                        return (operation(operand1, operand2), op2Evaluation.remaingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> (Double?, String?){
        history = ""
        let (result, remainder) = evaluate(opStack)
        return (result, history)
    }
    
    func pushOperand(operand: Double) -> (Double?, String?){
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperand(symbol: String) -> (Double?, String?){
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}