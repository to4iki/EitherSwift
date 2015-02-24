//
//  Either.swift
//  EitherSwift
//
//  Created by to4iki on 2/25/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
*  A reference type that has a value type
*/
public class EitherContainer<X> {
    public let value: X
    
    init(_ value: X) {
        self.value = value
    }
}

/**
*  Represents a value of one of two possible types (a disjoint union.)
*  Instances of Either are either an instance of Left or Right.
*/
public enum Either<A, B> {
    typealias Failure = A
    typealias Success = B
    
    case Left(EitherContainer<A>)
    case Right(EitherContainer<B>)
    
    public init(left: A) {
        self = .Left(EitherContainer<A>(left))
    }
    
    public init(right: B) {
        self = .Right(EitherContainer<B>(right))
    }
    
    /// Projects this `Either` as a `Left`.
    public var left: LeftProjection<A, B> { return LeftProjection<A, B>(e: self) }
    
    /// Projects this `Either` as a `Right`.
    public var right: RightProjection<A, B> { return RightProjection<A, B>(e: self) }
    
    /// Returns `true` if this is a `Left`, `false` otherwise.
    public var isLeft: Bool {
        switch self {
        case .Left(_): return true
        case .Right(_): return false
        }
    }
    
    /// Returns `true` if this is a `Right`, `false` otherwise.
    public var isRight: Bool {
        switch self {
        case .Left(_): return false
        case .Right(_): return true
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
        case .Left(let l): return fa(l.value)
        case .Right(let r): return fb(r.value)
        }
    }
    
    /**
    If this is a `Left`, then return the left value in `Right` or vice versa.
    */
    public func swap() -> Either<B, A> {
        switch self {
        case .Left(let l): return Either<B, A>(right: l.value)
        case .Right(let r): return Either<B, A>(left: r.value)
        }
    }
    
    /**
    Returns the given argument if `Left` or self if `Right`.
    
    :param: f The function to bind across `Left`.
    */
    public func fallback(f: () -> Either<Failure, Success>) -> Either<Failure, Success> {
        switch self {
        case .Left: return f()
        case .Right: return self
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

extension Either: Printable {
    
    public var description: String {
        switch self {
        case .Left(let l): return "Either<A, B>(left: \(l.value))"
        case .Right(let r): return "Either<A, B>(right: \(r.value))"
        }
    }
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
        case .Left(let l): f(l.value)
        case .Right(_): break
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
        return e.fold({ a in Either<X, B>(left: f(a)) }, { Either<X, B>(right: $0) })
    }
    
    /**
    Binds the given function across `Left`.
    
    :param: f The function to bind across `Left`.
    */
    public func flatMap<X>(f: A -> Either<X, B>) -> Either<X, B> {
        return e.fold({ f($0) }, { Either<X, B>(right: $0) })
    }
    
    /**
    Returns `None` if this is a `Right` or if the given predicate
    `p` does not hold for the left value, otherwise, returns a `Left`.
    */
    public func filter(p: A -> Bool) -> Either<A, B>? {
        return e.fold({ p($0) ? Either<A, B>(left: $0) : nil }, { _ in nil} )
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
        case .Left(_): break
        case .Right(let r): f(r.value)
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
        return e.fold({ Either<A, X>(left: $0) }, { b in Either<A, X>(right: f(b)) })
    }
    
    /**
    Binds the given function across `Right`.
    
    :param: f The function to bind across `Right`.
    */
    public func flatMap<X>(f: B -> Either<A, X>) -> Either<A, X> {
        return e.fold({ Either<A, X>(left: $0) }, { f($0) })
    }
    
    /**
    Returns `None` if this is a `Left` or if the given predicate
    `p` does not hold for the right value, otherwise, returns a `Right`.
    */
    public func filter(p: B -> Bool) -> Either<A, B>? {
        return e.fold({ _ in nil }, { p($0) ? Either<A, B>(right: $0) : nil })
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
public func ??<A, B>(left: LeftProjection<A, B>, right: @autoclosure () -> A) -> A {
    return left.getOrElse(right)
}

/**
right.getOrElse Operator
*/
public func ??<A, B>(right: RightProjection<A, B>, left: @autoclosure () -> B) -> B {
    return right.getOrElse(left)
}
