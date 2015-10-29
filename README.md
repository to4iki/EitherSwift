EitherSwift
===========

[![Build Status][status-image]][status-url]
[![Pods version][pod-image]][pod-url]
[![Carthage compatible][carthage-image]][carthage-url]
[![License][license-image]][license-url]
[![platform][platform-image]][platform-url]

Represents a value of one of two possible types (a disjoint union.)  
Instances of Either are either an instance of Left or Right.

## Description

Swift Either type like [scala.util.Either](http://www.scala-lang.org/api/current/#scala.util.Either)  
++ some in  [\/ - scalaz.\/](http://docs.typelevel.org/api/scalaz/stable/7.0.2/doc/#scalaz.$bslash$div)

Take **Right Projection** is decided it would be want.

## Requirements

- Swift 2 or later
- iOS 8.0 or later

## Usage

```swift
struct Error {
    var reason: String
    init(_ reason: String) { self.reason = reason }
}
let resultL = Either<Error, String>.left(Error("failed"))
let resultR = Either<Error, String>.right("ok")
```

#### isLeft / isRight
```swift
resultR.isRight // true
resultR.isLeft  // false
```

#### swap(~)
```swift
~Either<String, String>.left("failed") ?? "fallback" // failed
```

#### getOrElse(??)
```swift
// Alias for Right Projection.getOrElse
resultL ?? "fallback" // fallback
resultR ?? "fallback" // success
```

#### orElse(|||)
```swift
// Right Projection
resultL ||| "ok" // .Right("ok")
Either<Error, String>.left(Error("failed1")) ||| resultL ||| resultR // .Right("ok")
```

#### map
```swift
// Alias for Right Projection.map
resultR.map { "\($0)!" } // .Right("ok!")
resultL.map { "\($0)!" } // .Left(Error("failed"))
```

#### flatMap(>>-)
```swift
func isFull<T>(string: String) -> Either<T, Bool> {
    return .right(!string.isEmpty)
}

(resultL >>- isFull).fold(
    { e in e.reason},
    { s in s.description }
)
// failed

(resultR >>- isFull).fold(
    { e in e.reason},
    { s in s.description }
)
// true
```

## Methods

### Either\<A, B\>

- Instance Methods
    - `fold<X>(fa: A -> X, _ fb: B -> X) -> X`
    - `swap() -> Either<B, A>`
    - `getOrElse(or: () -> B) -> B` Right Projection
    - `orElse(or: () -> B) -> Either<A, B>` Right Projection
    - `orElse(or: () -> Either<A, B>) -> Either<A, B>` Right Projection
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

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "to4iki/EitherSwift"
```

Run `carthage update` and follow the steps as described in Carthage's [README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).


### [CocoaPods](http://cocoapods.org/)
Version 0.36 or higher is required. Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```rb
pod 'EitherSwift'
```

Make sure that you are integrating your dependencies using frameworks: add `use_frameworks!` to your Podfile. Then run `pod install`.

## Licence

[MIT](http://to4iki.mit-license.org/)

## Author

[to4iki](https://github.com/to4iki)

[status-url]: https://travis-ci.org/to4iki/EitherSwift
[status-image]: https://travis-ci.org/to4iki/EitherSwift.svg

[pod-url]: http://cocoadocs.org/docsets/EitherSwift
[pod-image]: https://img.shields.io/cocoapods/v/EitherSwift.svg?style=flat

[platform-url]: http://cocoadocs.org/docsets/EitherSwift
[platform-image]: https://img.shields.io/cocoapods/p/EitherSwift.svg?style=flat

[carthage-url]: https://github.com/Carthage/Carthage
[carthage-image]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat

[license-url]: http://to4iki.mit-license.org/
[license-image]: http://img.shields.io/badge/license-MIT-brightgreen.svg
