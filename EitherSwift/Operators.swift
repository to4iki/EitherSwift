//
//  Operators.swift
//  EitherSwift
//
//  Created by to4iki on 4/10/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//


/// Bind | Sequences and composes two monadic actions by passing the value inside the monad on the
/// left to a function on the right yielding a new monad.
infix operator >>- {
    associativity left
    precedence 110
}

/// Fanin | Given two functions with the same target but different sources, this function splits
/// the input between the two and merges the output.
infix operator ||| {
    associativity right
    precedence 120
}