//
//  ProjectionTests.swift
//  EitherSwift
//
//  Created by to4iki on 2015/04/09.
//  Copyright (c) 2015 to4iki. All rights reserved.
//

import XCTest
import EitherSwift

class ProjectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLeftGet() {
        let e = Helper.try(false, "left")
        XCTAssertEqual(e.left.get.reason, "left")
        // XCTAssertEqual(e.right.get, "left") Runtime Error
    }
    
    func testRightGet() {
        let e = Helper.try(true, "right")
        XCTAssertEqual(e.right.get, "right")
        // XCTAssertEqual(e.left.get.reason, "right") Runtime Error
    }
    
    func testLeftToOption() {
        let e = Helper.try(false, "left")
        XCTAssert(e.left.toOption()?.reason != nil)
        XCTAssert(e.right.toOption() == nil)
    }
    
    func testRightToOption() {
        let e = Helper.try(true, "right")
        XCTAssert(e.left.toOption() == nil)
        XCTAssert(e.right.toOption() != nil)
    }
    
    func testLeftGetOrElse() {
        let e = Helper.try(false, "left")
        XCTAssertEqual(e.left.getOrElse { Error("or") }.reason, "left")
        XCTAssertEqual(e.right.getOrElse { "or" }, "or")
    }
    
    func testRightGetOrElse() {
        let e = Helper.try(true, "right")
        XCTAssertEqual(e.left.getOrElse { Error("or") }.reason, "or")
        XCTAssertEqual(e.right.getOrElse { "or" }, "right")
    }
    
    func testLeftForeach() {
        let e = Helper.try(false, "left")
        
        var (leftWasCall, rightWasCall) = (false, false)
        e.left.foreach { _ in leftWasCall = true }
        e.right.foreach { _ in rightWasCall = true }
        
        XCTAssert(leftWasCall == true)
        XCTAssert(rightWasCall == false)
    }
    
    func testRightForeach() {
        let e = Helper.try(true, "right")
        
        var (leftWasCall, rightWasCall) = (false, false)
        e.left.foreach { _ in leftWasCall = true }
        e.right.foreach { _ in rightWasCall = true }
        
        XCTAssert(leftWasCall == false)
        XCTAssert(rightWasCall == true)
    }
    
    func testLeftForall() {
        let e = Helper.try(false, "left")
        XCTAssert(e.left.forall { count($0.reason) > 3 } == true)
        XCTAssert(e.left.forall { count($0.reason) > 4 } == false)
        XCTAssert(e.right.forall { count($0) > 100 } == true)
    }
    
    func testRightForall() {
        let e = Helper.try(true, "right")
        XCTAssert(e.left.forall { count($0.reason) > 100 } == true)
        XCTAssert(e.right.forall { count($0) > 4 } == true)
        XCTAssert(e.right.forall { count($0) > 5 } == false)
    }
    
    func testLeftExists() {
        let e = Helper.try(false, "left")
        XCTAssert(e.left.exists { count($0.reason) > 3 } == true)
        XCTAssert(e.left.exists { count($0.reason) > 4 } == false)
        XCTAssert(e.right.exists { count($0) > 100 } == false)
    }
    
    func testRightExists() {
        let e = Helper.try(true, "right")
        XCTAssert(e.left.exists { count($0.reason) > 100 } == false)
        XCTAssert(e.right.exists { count($0) > 4 } == true)
        XCTAssert(e.right.exists { count($0) > 5 } == false)
    }
    
    func testLeftMap() {
        let e1 = Either<Int, Int>.left(12).left.map { $0 + 2 } // .Left(14)
        let e2 = Either<Int, Int>.right(12).left.map { $0 + 2 } // .Right(12)
        XCTAssertEqual(e1.left.get, 14)
        XCTAssert(e1.right.toOption() == nil)
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, 12)
    }
    
    func testRightMap() {
        let e1 = Either<Int, Int>.left(12).right.map { $0 + 2 } // .Left(12)
        let e2 = Either<Int, Int>.right(12).right.map { $0 + 2 } // .Right(14)
        XCTAssertEqual(e1.left.get, 12)
        XCTAssert(e1.right.toOption() == nil)
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, 14)
    }
    
    func testLeftFlatMap() {
        let e1 = Either<Int, Int>.left(12).left.flatMap { _ in Either<String, Int>.left("swift") } // .Left("swift")
        let e2 = Either<Int, Int>.right(12).left.flatMap { _ in Either<String, Int>.left("swift") } // .Right(12)
        XCTAssertEqual(e1.left.get, "swift")
        XCTAssert(e1.right.toOption() == nil)
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, 12)
    }
    
    func testRightFlatMap() {
        let e1 = Either<Int, Int>.left(12).right.flatMap { _ in Either<Int, String>.right("swift") } // .Left(12)
        let e2 = Either<Int, Int>.right(12).right.flatMap { _ in Either<Int, String>.right("swift") } // .Right("swift")
        XCTAssertEqual(e1.left.get, 12)
        XCTAssert(e1.right.toOption() == nil)
        XCTAssert(e2.left.toOption() == nil)
        XCTAssertEqual(e2.right.get, "swift")
    }
    
    func testLeftFilter() {
        let e = Helper.try(false, "left")
        XCTAssert(e.left.filter { count($0.reason) > 3 } != nil)
        XCTAssert(e.left.filter { count($0.reason) > 4 } == nil)
        XCTAssert(e.right.filter { count($0) > 100 } == nil)
    }
    
    func testRightFilter() {
        let e = Helper.try(true, "right")
        XCTAssert(e.left.filter { count($0.reason) > 100 } == nil)
        XCTAssert(e.right.filter { count($0) > 4 } != nil)
        XCTAssert(e.right.filter { count($0) > 5 } == nil)
    }
}