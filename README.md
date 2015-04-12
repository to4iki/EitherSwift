EitherSwift
===========

[![Build Status](https://travis-ci.org/to4iki/EitherSwift.svg)][status]
[![Version](https://img.shields.io/cocoapods/v/EitherSwift.svg?style=flat)][version]
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]
[![Platform](https://img.shields.io/cocoapods/p/EitherSwift.svg?style=flat)][platform]

[status]: https://travis-ci.org/to4iki/EitherSwift
[version]: http://cocoadocs.org/docsets/EitherSwift
[license]: https://github.com/to4iki/EitherSwift/master/LICENSE
[platform]: http://cocoadocs.org/docsets/EitherSwift

Represents a value of one of two possible types (a disjoint union.)  
Instances of Either are either an instance of Left or Right.

## Description

Swift Either type like [scala.util.Either](http://www.scala-lang.org/api/current/#scala.util.Either)  
++ some in  [\/ - scalaz.\/](http://docs.typelevel.org/api/scalaz/stable/7.0.2/doc/#scalaz.$bslash$div)

## Usage

## Methods

### Either\<A, B\>

- Instance Methods
    - `fold<X>(fa: A -> X, _ fb: B -> X) -> X`
    - `swap() -> Either<B, A>`
    - `getOrElse(or: () -> B) -> B`
    - `orElse(or: () -> B) -> Either<A, B>`
    - `orElse(or: () -> Either<A, B>) -> Either<A, B>`
    - `map<X>(f: B -> X) -> Either<A, X>` Right Projection
    - `flatMap<X>(f: B -> Either<A, X>) -> Either<A, X>` Right Projection
- Class Methods
    - `left(value: A) -> Either<A, B>`
    - `right(value: B) -> Either<A, B>`
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

### CocoaPods

```ruby
pod 'EitherSwift'
```

## Licence

[MIT](https://github.com/to4iki/EitherSwift/master/LICENSE)

## Author

[to4iki](https://github.com/to4iki)
