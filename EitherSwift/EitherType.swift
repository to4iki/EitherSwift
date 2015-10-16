//
//  EitherType.swift
//  EitherSwift
//
//  Created by to4iki on 4/12/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
*  A type representing an alternative of one of two types.
*/
public protocol EitherType {
    typealias LeftValue
    typealias RightValue
    
    /// Constructs a `Left` instance.
    static func left(value: LeftValue) -> Self
    
    /// Constructs a `Right` instance.
    static func right(value: RightValue) -> Self
    
    /// Returns the result of applying `f` to `Left` values, or `g` to `Right` values.
    func fold<Result>(fa: LeftValue -> Result, _ fb: RightValue -> Result) -> Result
}
