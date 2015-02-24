EitherSwift
===========

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]

[license]: https://github.com/to4iki/EitherSwift/master/LICENSE

Represents a value of one of two possible types (a disjoint union.)  
Instances of Either are either an instance of Left or Right.

## Description

Swift Either type like [scala.util.Either](http://www.scala-lang.org/api/current/#scala.util.Either)

## Usage

```swift
/// helper
struct Error {
    var reason: String
    init(_ reason: String) { self.reason = reason }
}

func parseInt(s: String) -> Either<Error, Int> {
    if let i = s.toInt() {
        return Either(right: i)
    } else {
        return Either(left: Error("parse error."))
    }
}
```

```swift
let result = parseInt("2")

// isLeft / isRight
result.isLeft // false
result.isRight // true

// get(Forced Unwrapping)
result.right.get // 2

// getOrElse(&&)
result.left.getOrElse { Error("failed") }.reason // failed
result.right.getOrElse { 0 } // 2
result.right ?? 0 // 2

// exists
result.left.exists { _ in true } // false
result.right.exists { $0 % 2 == 0 } // true

// map
result.left.map { $0.reason + "left" } // .Left()
result.right.map { $0 + 2 } // .Right(4)

// flatMap
result.left.flatMap { _ in Either<Error, Int>(right: 12) } // .Left()
result.right.flatMap { _ in Either<Error, Int>(right: 12) } // .Right(12)

// toOption
result.left.toOption() // nil
result.right.toOption() // Some(2)

// fold
result.fold(
    { (e: Error) -> String in "left" },
    { (i: Int) -> String  in "right"}
) // right

// fallack
result.fallback { Either(right: 0) } // .Right(2)
parseInt("a").fallback { Either(right: 0) } // .Right(0)
```

## Methods

### Either\<A, B\>

typealias Failure = A  
typealias Success = B

- Instance Methods
    - `fold<X>(fa: A -> X, _ fb: B -> X) -> X`
    - `swap() -> Either<B, A> `
    - `fallback(f: () -> Either<Failure, Success>) -> Either<Failure, Success>`
- Class Methods
    - `cond<A, B>(test: Bool, right: () -> B, left: () -> A) -> Either<A, B>`

### LeftProjection\<A, B\>
- Instance Methods
    - `getOrElse(or: () -> A)  -> A`
    - `foreach<U>(f: A -> U)`
    - `forall(f: A -> Bool) -> Bool`
    - `exists(f: A -> Bool) -> Bool`
    - `map<X>(f: A -> X) -> Either<X, B>`
    - `flatMap<X>(f: A -> Either<X, B>) -> Either<X, B>`
    - `filter(p: A -> Bool) -> Either<A, B>?`
    - `toOption() -> A?`

### RightProjection\<A, B\>
- Instance Methods
    - `getOrElse(or: () -> B)  -> B`
    - `foreach<U>(f: B -> U)`
    - `forall(f: B -> Bool) -> Bool`
    - `exists(f: B -> Bool) -> Bool`
    - `map<X>(f: B -> X) -> Either<A, X>`
    - `flatMap<X>(f: B -> Either<A, X>) -> Either<A, X>`
    - `filter(p: B -> Bool) -> Either<A, B>?`
    - `toOption() -> B?`

## Installation

## Licence

[MIT](https://github.com/to4iki/EitherSwift/master/LICENSE)

## Author

[to4iki](https://github.com/to4iki)