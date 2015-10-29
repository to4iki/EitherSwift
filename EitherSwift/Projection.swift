//
//  Projection.swift
//  EitherSwift
//
//  Created by to4iki on 2015/04/08.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

/**
*   Projects an `Either` into a `Left`.
*/
public struct LeftProjection<A, B> {
    
    /// Either    
    private let e: Either<A, B>
    
    init(_ e: Either<A, B>) {
        self.e = e
    }
    
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
    
    - parameter f: The side-effecting function to execute.
    */
    public func foreach<U>(f: A -> U) {
        switch e {
        case .Left(let l):
            f(l)
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
        return e.fold({ a in Either.left(f(a)) }, { Either.right($0) })
    }
    
    /**
    Binds the given function across `Left`.
    
    - parameter f: the function to bind across `Left`.
    */
    public func flatMap<X>(f: A -> Either<X, B>) -> Either<X, B> {
        return e.fold({ f($0) }, { Either.right($0) })
    }
    
    /**
    Returns `None` if this is a `Right` or if the given predicate
    `p` does not hold for the left value, otherwise, returns a `Left`.
    */
    public func filter(p: A -> Bool) -> Either<A, B>? {
        return e.fold({ p($0) ? Either.left($0) : nil }, { _ in nil} )
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
    
    /// Either
    private let e: Either<A, B>
    
    init(_ e: Either<A, B>) {
        self.e = e
    }
    
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
    
    - parameter f: the side-effecting function to execute.
    */
    public func foreach<U>(f: B -> U) {
        switch e {
        case .Left:
            break
        case .Right(let r):
            f(r)
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
        return e.fold({ Either.left($0) }, { b in Either.right(f(b)) })
    }
    
    /**
    Binds the given function across `Right`.
    
    - parameter f: the function to bind across `Right`.
    */
    public func flatMap<X>(f: B -> Either<A, X>) -> Either<A, X> {
        return e.fold({ Either.left($0) }, { f($0) })
    }
    
    /**
    Returns `None` if this is a `Left` or if the given predicate
    `p` does not hold for the right value, otherwise, returns a `Right`.
    */
    public func filter(p: B -> Bool) -> Either<A, B>? {
        return e.fold({ _ in nil }, { p($0) ? Either.right($0) : nil })
    }
    
    /**
    Returns a `Some` containing the `Right` value
    if it exists or a `None` if this is a `Left`.
    */
    public func toOption() -> B? {
        return e.fold({ _ in nil }, { Optional($0) })
    }
}
