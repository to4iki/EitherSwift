//
//  Either.swift
//  EitherSwift
//
//  Created by to4iki on 2/25/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
Represents a value of one of two possible types (a disjoint union.)
Instances of Either are either an instance of Left or Right.

- Left:  Left Value
- Right: Right Value
*/
public enum Either<A, B>: EitherType {
    case Left(Box<A>)
    case Right(Box<B>)
    
    /**
    A left `Either` returning `value`
    This form is preferred to `Either.Left(Box(value))`
    because it does not require dealing with `Box()`
    
    - parameter value: result value
    
    - returns: Left
    */
    public static func left(value: A) -> Either<A, B> {
        return Left(Box(value))
    }
    
    /**
    A right `Either` returning `value`
    This form is preferred to `Either.Right(Box(value))`
    because it does not require dealing with `Box()`
    
    - parameter value: result value
    
    - returns: Right
    */
    public static func right(value: B) -> Either<A, B> {
        return Right(Box(value))
    }
    
    /// Projects this `Either` as a `Left`.
    public var left: LeftProjection<A, B> {
        return LeftProjection(self)
    }
    
    /// Projects this `Either` as a `Right`.
    public var right: RightProjection<A, B> {
        return RightProjection(self)
    }
    
    /// Returns `true` if this is a `Left`, `false` otherwise.
    public var isLeft: Bool {
        switch self {
        case .Left:
            return true
        case .Right:
            return false
        }
    }
    
    /// Returns `true` if this is a `Right`, `false` otherwise.
    public var isRight: Bool {
        switch self {
        case .Left:
            return false
        case .Right:
            return true
        }
    }
    
    /**
    Applies `fa` if this is a `Left` or `fb` if this is a `Right`.
    
    - parameter fa: the function to apply if this is a `Left`
    - parameter fb: the function to apply if this is a `Right`
    
    - returns: the results of applying the function
    */
    public func fold<X>(fa: A -> X, _ fb: B -> X) -> X {
        switch self {
        case .Left(let l):
            return fa(l.unbox)
        case .Right(let r):
            return fb(r.unbox)
        }
    }
    
    /**
    Flip the left/right values in this disjunction.
    Alias for `~`
    
    - returns: the results of swap
    */
    public func swap() -> Either<B, A> {
        switch self {
        case .Left(let l):
            return Either<B, A>.Right(l)
        case .Right(let r):
            return Either<B, A>.Left(r)
        }
    }
    
    /**
    Return the right value of this disjunction or the given default if left.
    like null Coalescing Operator.
    Alias for `??`
    
    - parameter or: the rawValue function to bind across `Left`.
    
    - returns: Right Value
    */
    public func getOrElse(or: () -> B) -> B {
        return right.getOrElse(or)
    }
    
    /**
    Return this if it is a right, otherwise, return the given value.
    like null Coalescing Operator.
    Alias for `|||`
    
    - parameter or: the rawValue function to bind across `Left`.
    
    - returns: Either<A, B>
    */
    public func orElse(or: () -> B) -> Either<A, B> {
        return fold({ _ in Either.right(or()) }, { _ in self })
    }
    
    /**
    Return this if it is a right, otherwise, return the given value.
    like null Coalescing Operator.
    Alias for `|||`
    
    - parameter or: the either function to bind across `Left`.
    
    - returns: Either<A, B>
    */
    public func orElse(or: () -> Either<A, B>) -> Either<A, B> {
        return fold({ _ in or() }, { _ in self })
    }
    
    /**
    Maps `Right` values with `f`, and re-wraps `Left` values.
    
    - parameter f: the function to bind across `Right`.
    
    - returns: Either<A, X>
    */
    public func map<X>(f: B -> X) -> Either<A, X> {
        return right.map(f)
    }
    
    /**.
    Returns the result of applying `f` to `Right` values, or re-wrapping `Left` values.
    Alias for `>>-`
    
    - parameter f: the function to bind across `Right`.
    
    - returns: Either<A, X>
    */
    public func flatMap<X>(f: B -> Either<A, X>) -> Either<A, X> {
        return right.flatMap(f)
    }
    
    /**
    If the condition is satisfied, return the given `B` in `Right`,
    otherwise, return the given `A` in `Left`.
    
    - parameter test:  predicate
    - parameter right: the either function to bind across `Right`.
    - parameter left:  the either function to bind across `Left`.
    
    - returns: Either<A, B>
    */
    public static func cond<A, B>(test: Bool, right: () -> B, left: () -> A) -> Either<A, B> {
        return test ? Either<A, B>.right(right()): Either<A, B>.left(left())
    }
}

/**
*  Printable
*/
extension Either: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Left(let l):
            return "Left: \(l.unbox)"
        case .Right(let r):
            return "Right: \(r.unbox)"
        }
    }
}

/**
Equatable
Equality for Either is defined by the equality of the contained types

- parameter lhs: Left hand side
- parameter rhs: right hand side

- returns: equal
*/
public func == <A, B where A: Equatable, B: Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
    switch (lhs, rhs) {
    case let (.Right(l), .Right(r)):
        return l.unbox == r.unbox
    case let (.Left(l), .Left(r)):
        return l.unbox == r.unbox
    default:
        return false
    }
}

/**
Equatable
Inequality for Either is defined by the inequality of the contained types

- parameter lhs: Left hand side
- parameter rhs: right hand side

- returns: inequal
*/
public func != <A, B where A: Equatable, B: Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
    return !(rhs == lhs)
}

/**
Flip the left/right values in this disjunction. Alias for `swap`

- parameter either: Either<A, B>

- returns: the results of swap
*/
public prefix func ~ <A, B>(eithr: Either<A, B>) -> Either<B, A> {
    return eithr.swap()
}

/**
Return the right value of this disjunction or the given default if left. Alias for `getOrElse`

- parameter eithr: Either<A, B>
- parameter or:    the rawValue function to bind across `Left`.

- returns: Right Value
*/
public func ?? <A, B>(eithr: Either<A, B>, or:  B) -> B {
    return eithr.getOrElse { or }
}

/**
Return this if it is a right, otherwise, return the given value. Alias for `orElse`

- parameter eithr: Either<A, B>
- parameter or:    the rawValue function to bind across `Left`.

- returns: Either<A, B>
*/
public func ||| <A, B>(eithr: Either<A, B>, or:  B) -> Either<A, B> {
    return eithr.orElse { or }
}

/**
Return this if it is a right, otherwise, return the given value. Alias for `orElse`

- parameter eithr: Either<A, B>
- parameter or:    the either function to bind across `Left`.

- returns: Either<A, B>
*/
public func ||| <A, B>(eithr: Either<A, B>, or: Either<A, B>) -> Either<A, B> {
    return eithr.orElse { or }
}

/**
Returns the result of applying `f` to `Right` values, or re-wrapping `Left` values. Alias for `flatMap`

- parameter either: Either<A, B>
- parameter f:      the function to bind across `Right`.

- returns: Either<A, X>
*/
public func >>- <A, B, X>(either: Either<A, B>, f: B -> Either<A, X>) -> Either<A, X> {
    return either.flatMap(f)
}
