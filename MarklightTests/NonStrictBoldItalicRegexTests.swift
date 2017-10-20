//
//  NonStrictBoldItalicRegexTests.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-22.
//  Copyright © 2017 MAcTeo. See LICENSE for details.
//

import XCTest
@testable import Marklight

class NonStrictBoldItalicRegexTests: XCTestCase {
}

// MARK: - Bold

fileprivate extension Marklight {
    static var boldPattern: String { return "(\\*\\*|__) (?=\\S) (.+?[*_]*?) (?<=\\S) (\\1)" }
    static var boldRegex: Regex { return Regex(pattern: boldPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines]) }
}

extension NonStrictBoldItalicRegexTests {

    func testBold() {

        ["hi **bold** text",
         "hi __bold__ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.boldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(3, 8))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(3, 2))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(5, 4))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(9, 2))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra__word__ emphasis", Marklight.boldRegex) { _ in
            XCTFail("intraword emphasis with bold underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword bold emphasis")
            match("intra**word** emphasis", Marklight.boldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(5, 8))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(5, 2))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(7, 4))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(11, 2))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                }
                callbackExp.fulfill()
            }
        }

        do {
            var nestedMatches = 0
            let outerCallbackExp = expectation(description: "Matched outer bold")
            let innerCallbackExp = expectation(description: "Matched inner bold")
            match("__foo, __bar__, baz__", Marklight.boldRegex) {
                if nestedMatches == 0 {
                    // Outer emphasis
                    if let result = $0,
                        result.numberOfRanges == 4 {
                        XCTAssertEqual(result.range(at: 0), NSMakeRange(0, 21))
                        XCTAssertEqual(result.range(at: 1), NSMakeRange(0, 2))
                        XCTAssertEqual(result.range(at: 2), NSMakeRange(2, 17))
                        XCTAssertEqual(result.range(at: 3), NSMakeRange(19, 2))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    nestedMatches += 1
                    outerCallbackExp.fulfill()
                } else if nestedMatches == 1 {
                    // Inner emphasis
                    if let result = $0,
                        result.numberOfRanges == 4 {
                        XCTAssertEqual(result.range(at: 0), NSMakeRange(7, 5))
                        XCTAssertEqual(result.range(at: 1), NSMakeRange(7, 2))
                        XCTAssertEqual(result.range(at: 2), NSMakeRange(9, 3))
                        XCTAssertEqual(result.range(at: 3), NSMakeRange(12, 2))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    innerCallbackExp.fulfill()
                }
            }
        }

        // Left & right flanking
        ["Sentence **end**.",
         "Sentence __end__."].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.boldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(9, 7))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(9, 2))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(11, 3))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(14, 2))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        boldNonMatches.forEach { string in
            match(string, Marklight.boldRegex) { _ in
                XCTFail("\"\(string)\" should not match")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

}

// MARK: - Italic

fileprivate extension Marklight {
    static var italicPattern: String = "(\\*|_) (?=\\S) (.+?) (?<=\\S) (\\1)"
    static var italicRegex: Regex = Regex(pattern: italicPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
}

extension NonStrictBoldItalicRegexTests {
    func testItalic() {

        ["hi *italic* text",
         "hi _italic_ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.italicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(3, 8))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(3, 1))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(4, 6))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(10, 1))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra_word_ emphasis", Marklight.italicRegex) { _ in
            XCTFail("intraword emphasis with underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword emphasis")
            match("intra*word* emphasis", Marklight.italicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(5, 6))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(5, 1))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(6, 4))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(10, 1))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                }
                callbackExp.fulfill()
            }
        }

        // Left & right flanking with punctuation
        ["Sentence *end*.",
         "Sentence _end_."].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.italicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.range(at: 0), NSMakeRange(9, 5))
                    XCTAssertEqual(result.range(at: 1), NSMakeRange(9, 1))
                    XCTAssertEqual(result.range(at: 2), NSMakeRange(10, 3))
                    XCTAssertEqual(result.range(at: 3), NSMakeRange(13, 1))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        italicNonMatches.forEach { string in
            match(string, Marklight.italicRegex) { _ in
                XCTFail("\"\(string)\" should not match")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}
