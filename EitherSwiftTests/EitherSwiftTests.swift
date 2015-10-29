//
//  EitherSwiftTests.swift
//  EitherSwiftTests
//
//  Created by to4iki on 2/25/15.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

import XCTest
import EitherSwift

struct Error {
    var reason: String
    init(_ reason: String) { self.reason = reason }
}

struct Helper {
    static func `try`(success: Bool, _ message: String) -> Either<Error, String> {
        return success ? Either.right(message) : Either.left(Error(message))
    }
}

class EitherSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLeft() {
        switch Either<Error, String>.left(Error("left")) {
        case .Left(let l):
            XCTAssertEqual(l.reason, "left")
        case .Right:
            XCTAssert(false, "not reached")
        }
    }
    
    func testRight() {
        switch Either<Error, String>.right("right") {
        case .Left:
            XCTAssert(false, "not reached")
        case .Right(let r):
            XCTAssertEqual(r, "right")
        }
    }
    
    func testFold() {
        let e1 = Helper.`try`(false, "error").fold({ "left \($0.reason)" }, { "right \($0)" })
        XCTAssertEqual(e1, "left error")
        
        let e2 = Helper.`try`(true, "success").fold({ "left \($0.reason)" }, { "right \($0)" })
        XCTAssertEqual(e2, "right success")
    }
    
    func testSwap() {
        let e = Either<Int, String>.left(12)
        XCTAssertEqual(e.left.get, 12)
        XCTAssert(e.right.toOption() == nil)
        
        let es = e.swap()
        XCTAssert(es.left.toOption() == nil)
        XCTAssertEqual(es.right.get, 12)
    }
    
    func testSwapOperator() {
        let e = Either<Int, String>.left(12)
        
        let es = ~e
        XCTAssert(es.left.toOption() == nil)
        XCTAssertEqual(es.right.get, 12)
    }
    
    func testMap() {
        let e1 = Helper.`try`(false, "f").map { (s: String) -> String in "\(s) value" }
        XCTAssertEqual(e1.left.get.reason, "f")
        XCTAssert(e1.right.toOption() == nil)
        
        let e2 = Helper.`try`(true, "s").map { (s: String) -> String in "\(s) value" }
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "s value")
    }
    
    func testFlatMap() {
        let e1 = Helper.`try`(false, "f").flatMap { (s: String) -> Either<Error, String> in
            return Either.right("\(s) value")
        }

        XCTAssertEqual(e1.left.get.reason, "f")
        XCTAssert(e1.right.toOption() == nil)
        
        let e2 = Helper.`try`(true, "s").flatMap { (s: String) -> Either<Error, String> in
            return Either.right("\(s) value")
        }
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "s value")
    }
    
    func testflatMapOperator() {
        let e1 = (Helper.`try`(false, "f") >>- Either.right).fold({ _ in "ff"}, { _ in "s"})
        XCTAssertEqual(e1, "ff")
        
        let e2 = (Helper.`try`(true, "s") >>- Either.right).fold({ _ in "f"}, { _ in "ss"})
        XCTAssertEqual(e2, "ss")
    }
    
    func testGetOrElse() {
        let e1 = Helper.`try`(false, "f").getOrElse { "s" }
        XCTAssertEqual(e1, "s")
        
        let e2 = Helper.`try`(true, "s").getOrElse { "s2" }
        XCTAssertEqual(e2, "s")
    }
    
    func testGetOrElseOperator() {
        let e1 = Helper.`try`(false, "f") ?? "s"
        XCTAssertEqual(e1, "s")
        
        let e2 = Helper.`try`(true, "s") ?? "s2"
        XCTAssertEqual(e2, "s")
    }
    
    func testOrElseRawValue() {
        let e1 = Helper.`try`(false, "f").orElse { "s" }
        XCTAssert(e1.left.toOption() == nil)
        XCTAssertEqual(e1.right.get, "s")
        
        let e2 = Helper.`try`(true, "s").orElse { "s2" }
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "s")
        
        let e3 = Helper.`try`(false, "f1").orElse({
            Helper.`try`(false, "f2")
        }).orElse({
            "s"
        })
        XCTAssert(e3.left.toOption() == nil)
        XCTAssertEqual(e3.right.get, "s")
    }
    
    func testOrElse() {
        let e1 = Helper.`try`(false, "f").orElse { Helper.`try`(true, "s") }
        XCTAssert(e1.left.toOption() == nil)
        XCTAssertEqual(e1.right.get, "s")
        
        let e2 = Helper.`try`(true, "s").orElse { Helper.`try`(true, "s2") }
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "s")
        
        let e3 = Helper.`try`(false, "f1").orElse({
            Helper.`try`(false, "f2")
        }).orElse({
            Helper.`try`(true, "s")
        })
        XCTAssert(e3.left.toOption() == nil)
        XCTAssertEqual(e3.right.get, "s")
    }
    
    func testOrElseOperator() {
        let e1 = Helper.`try`(false, "f") ||| "s"
        XCTAssert(e1.left.toOption() == nil)
        XCTAssertEqual(e1.right.get, "s")
        
        let e2 = Helper.`try`(false, "f1") ||| Helper.`try`(false, "f2") ||| Helper.`try`(true, "s")
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "s")
    }
    
    func testCond() {
        let e1 = Either<Error, String>.cond(false, right: { _ in "right" }, left: { _ in Error("left") })
        XCTAssertEqual(e1.left.get.reason, "left")
        XCTAssert(e1.right.toOption() == nil)
        
        let e2 = Either<Error, String>.cond(true, right: { _ in "right" }, left: { _ in Error("left") })
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "right")
    }
    
    func testRightEquality() {
        let e1: Either<NSError, String> = Either.right("either")
        let e2: Either<NSError, String> = Either.right("either")
        XCTAssert(e1 == e2)
    }
    
    func testLeftEquality() {
        let err = NSError(domain: "", code: 0, userInfo: nil)
        let e1: Either<NSError, String> = Either.left(err)
        let e2: Either<NSError, String> = Either.left(err)
        XCTAssert(e1 == e2)
    }
    
    func testRightInequality() {
        let e1: Either<NSError, String> = Either.right("either")
        let e2: Either<NSError, String> = Either.right("different either")
        XCTAssert(e1 != e2)
    }
    
    func testLeftInequality() {
        let err = NSError(domain: "", code: 0, userInfo: nil)
        let err2 = NSError(domain: "", code: 1, userInfo: nil)
        let e1: Either<NSError, String> = Either.left(err)
        let e2: Either<NSError, String> = Either.left(err2)
        XCTAssert(e1 != e2)
    }
    
    func testIsLeft() {
        let e = Helper.`try`(false, "left")
        XCTAssert(e.isLeft == true)
        XCTAssert(e.isRight == false)
    }
    
    func testIsRight() {
        let e = Helper.`try`(true, "right")
        XCTAssert(e.isLeft == false)
        XCTAssert(e.isRight == true)
    }
}
