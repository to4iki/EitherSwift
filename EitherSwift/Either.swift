//
//  Either.swift
//  EitherSwift
//
//  Created by to4iki on 2/25/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
A left `Either` returning `value`
This form is preferred to `Either.Left(Box(value))`
because it does not require dealing with `Box()`

:param: value result value

:returns: Left
*/
public func left<A, B>(value: A) -> Either<A, B> {
    return .Left(Box(value))
}

/**
A right `Either` returning `value`
This form is preferred to `Either.Right(Box(value))`
because it does not require dealing with `Box()`

:param: value result value

:returns: Right
*/
public func right<A, B>(value: B) -> Either<A, B> {
    return .Right(Box(value))
}

/**
*  Represents a value of one of two possible types (a disjoint union.)
*  Instances of Either are either an instance of Left or Right.
*/
public enum Either<A, B> {
    typealias Failure = A
    typealias Success = B
    
    case Left(Box<A>)
    case Right(Box<B>)
    
    public init(left: A) {
        self = .Left(Box(left))
    }
    
    public init(right: B) {
        self = .Right(Box(right))
    }
    
    /// Projects this `Either` as a `Left`.
    public var left: LeftProjection<A, B> { return LeftProjection(e: self) }
    
    /// Projects this `Either` as a `Right`.
    public var right: RightProjection<A, B> { return RightProjection(e: self) }
    
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
    
    :param: fa the function to apply if this is a `Left`
    :param: fb the function to apply if this is a `Right`
    
    :returns: the results of applying the function
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
    If this is a `Left`, then return the left value in `Right` or vice versa.
    */
    public func swap() -> Either<B, A> {
        switch self {
        case .Left(let l):
            return Either<B, A>.Right(l)
        case .Right(let r):
            return Either<B, A>.Left(r)
        }
    }
    
    /**.
    Returns the given argument if `Success` or `Failure` value.
    like Optional Chaining.
    
    :param: f The function to bind across `Success`.
    */
    public func chain<X>(f: (Success) -> Either<Failure, X>)  -> Either<Failure, X> {
        switch self {
        case .Left(let l):
            return Either<Failure, X>(left: l.unbox)
        case .Right(let r):
            return f(r.unbox)
        }
    }
    
    /**
    Returns the given argument if `Failure` or self if `Success`.
    like null Coalescing Operator.
    
    :param: f The rawValue function to bind across `Failure`.
    */
    public func recover(f: () -> Success) -> Either<Failure, Success> {
        switch self {
        case .Left:
            return Either(right: f())
        case .Right:
            return self
        }
    }
    
    /**
    Returns the given argument if `Failure` or self if `Success`.
    like null Coalescing Operator.
    
    :param: f The either function to bind across `Failure`.
    */
    public func recoverWith(f: () -> Either<Failure, Success>) -> Either<Failure, Success> {
        switch self {
        case .Left:
            return f()
        case .Right:
            return self
        }
    }
    
    /**
    If the condition is satisfied, return the given `B` in `Right`,
    otherwise, return the given `A` in `Left`.
    */
    public static func cond<A, B>(test: Bool, right: () -> B, left: () -> A) -> Either<A, B> {
        return test ? Either<A, B>(right: right()): Either<A, B>(left: left())
    }
}

/**
*  Printable
*/
extension Either: Printable {
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

:param: lhs Left hand side
:param: rhs right hand side

:returns: equal
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

:param: lhs Left hand side
:param: rhs right hand side

:returns: inequal
*/
public func != <A, B where A: Equatable, B: Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
    return !(rhs == lhs)
}

/**
*   Projects an `Either` into a `Left`.
*/
public struct LeftProjection<A, B> {
    private let e: Either<A, B>
    
    /**
    Returns the value from this `Left`
    or throws `Runtime error` if this is a `Right`.
    */
    public var get: A {
        return self.toOption()!
    }
    
    /**
    Returns the value from this `Left` or the given argument if this is a `Right`.
    */
    public func getOrElse(or: () -> A)  -> A {
        return e.fold({ $0 }, { _ in or() })
    }
    
    /**
    Executes the given side-effecting function if this is a `Left`.
    
    :param: f The side-effecting function to execute.
    */
    public func foreach<U>(f: A -> U) {
        switch e {
        case .Left(let l):
            f(l.unbox)
        case .Right:
            break
        }
    }
    
    /**
    Returns `true` if `Right` or returns the result of the application of
    the given function to the `Left` value.
    */
    public func forall(f: A -> Bool) -> Bool {
        return e.fold({ f($0) }, { _ in true } )
    }
    
    /**
    Returns `false` if `Right` or returns the result of the application of
    the given function to the `Left` value.
    */
    public func exists(f: A -> Bool) -> Bool {
        return e.fold({ f($0) }, { _ in false } )
    }
    
    /**
    Maps the function argument through `Left`.
    */
    public func map<X>(f: A -> X) -> Either<X, B> {
        return e.fold({ a in left(f(a)) }, { right($0) })
    }
    
    /**
    Binds the given function across `Left`.
    
    :param: f The function to bind across `Left`.
    */
    public func flatMap<X>(f: A -> Either<X, B>) -> Either<X, B> {
        return e.fold({ f($0) }, { right($0) })
    }
    
    /**
    Returns `None` if this is a `Right` or if the given predicate
    `p` does not hold for the left value, otherwise, returns a `Left`.
    */
    public func filter(p: A -> Bool) -> Either<A, B>? {
        return e.fold({ p($0) ? left($0) : nil }, { _ in nil} )
    }
    
    /**
    Returns a `Some` containing the `Left` value if it exists or a
    `None` if this is a `Right`.
    */
    public func toOption() -> A? {
        return e.fold({ Optional($0) }, { _ in nil })
    }
}

/**
*  Projects an `Either` into a `Right`.
*/
public struct RightProjection<A, B> {
    private let e: Either<A, B>
    
    /**
    Returns the value from this `Right`
    or throws `Runtime error` if this is a `Left`.
    */
    public var get: B {
        return self.toOption()!
    }
    
    /**
    Returns the value from this `Right` or the given argument if this is a `Left`
    */
    public func getOrElse(or: () -> B) -> B {
        return e.fold({ _ in or() }, { $0 })
    }
    
    /**
    Executes the given side-effecting function if this is a `Right`.
    
    :param: f The side-effecting function to execute.
    */
    public func foreach<U>(f: B -> U) {
        switch e {
        case .Left:
            break
        case .Right(let r):
            f(r.unbox)
        }
    }
    
    /**
    Returns `true` if `Left` or returns the result of the application of
    the given function to the `Right` value.
    */
    public func forall(f: B -> Bool) -> Bool {
        return e.fold({ _ in true }, { f($0) })
    }
    
    /**
    Returns `false` if `Left` or returns the result of the application of
    the given function to the `Right` value.
    */
    public func exists(f: B -> Bool) -> Bool {
        return e.fold({ _ in false }, { f($0) })
    }
    
    /**
    The given function is applied if this is a `Right`.
    */
    public func map<X>(f: B -> X) -> Either<A, X> {
        return e.fold({ left($0) }, { b in right(f(b)) })
    }
    
    /**
    Binds the given function across `Right`.
    
    :param: f The function to bind across `Right`.
    */
    public func flatMap<X>(f: B -> Either<A, X>) -> Either<A, X> {
        return e.fold({ left($0) }, { f($0) })
    }
    
    /**
    Returns `None` if this is a `Left` or if the given predicate
    `p` does not hold for the right value, otherwise, returns a `Right`.
    */
    public func filter(p: B -> Bool) -> Either<A, B>? {
        return e.fold({ _ in nil }, { p($0) ? right($0) : nil })
    }
    
    /**
    Returns a `Some` containing the `Right` value
    if it exists or a `None` if this is a `Left`.
    */
    public func toOption() -> B? {
        return e.fold({ _ in nil }, { Optional($0) })
    }
}

/**
left.getOrElse Operator
*/
public func ?? <A, B>(left: LeftProjection<A, B>, right: @autoclosure () -> A) -> A {
    return left.getOrElse(right)
}

/**
right.getOrElse Operator
*/
public func ?? <A, B>(right: RightProjection<A, B>, left: @autoclosure () -> B) -> B {
    return right.getOrElse(left)
}
