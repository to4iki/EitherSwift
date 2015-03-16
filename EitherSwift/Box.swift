//
//  Box.swift
//  EitherSwift
//
//  Created by to4iki on 2015/03/16.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
*  A reference type that has a value type
*/
public final class Box<T> {
    public let unbox: T
    
    init(_ value: T) {
        self.unbox = value
    }
}
