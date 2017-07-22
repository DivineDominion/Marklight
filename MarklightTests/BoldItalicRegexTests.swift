//
//  BoldItalicRegexTests.swift
//  Marklight
//
//  Created by Christian Tietze on 21.07.17.
//  Copyright © 2017 Dolomate. All rights reserved.
//

import XCTest
@testable import Marklight

class BoldItalicRegexTests: XCTestCase {

    /// Helper to match the whole `string` with `regex`.
    func match(_ string: String, _ regex: Regex, completion: @escaping (NSTextCheckingResult?) -> Void) {

        let wholeRange = NSRange(location: 0, length: (string as NSString).length)

        regex.matches(string, range: wholeRange, completion: completion)
    }
}

// MARK: - Bold

/// A CommonMark compatible matcher should not match these.
fileprivate var boldNonMatches: [String] {
    return [
        "** foo bar**",
        "__ foo bar__",
        "a**foo bar**", // left & right flanking on opening
        "**foo bar**z", // left & right flanking on closing
        "no **\nnewlines**",
        "** a **"
    ]
}

extension BoldItalicRegexTests {

    func testBold() {

        ["hi **bold** text",
         "hi __bold__ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.boldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(3, 8))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(3, 2))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(5, 4))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(9, 2))
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
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(5, 8))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(5, 2))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(7, 4))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(11, 2))
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
                        XCTAssertEqual(result.rangeAt(0), NSMakeRange(0, 21))
                        XCTAssertEqual(result.rangeAt(1), NSMakeRange(0, 2))
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(2, 17))
                        XCTAssertEqual(result.rangeAt(3), NSMakeRange(19, 2))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    nestedMatches += 1
                    outerCallbackExp.fulfill()
                } else if nestedMatches == 1 {
                    // Inner emphasis
                    if let result = $0,
                        result.numberOfRanges == 4 {
                        XCTAssertEqual(result.rangeAt(0), NSMakeRange(7, 5))
                        XCTAssertEqual(result.rangeAt(1), NSMakeRange(7, 2))
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 3))
                        XCTAssertEqual(result.rangeAt(3), NSMakeRange(12, 2))
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
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(9, 7))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(9, 2))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(11, 3))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(14, 2))
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

    func testStrictBold() {

        ["hi **bold** text",
         "hi __bold__ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(5, 4))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra__word__ emphasis", Marklight.strictBoldRegex) { _ in
            XCTFail("intraword emphasis with underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword bold emphasis")
            match("intra**word** emphasis", Marklight.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(5, 8))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(5, 2))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(7, 4))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(11, 2))
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
            match("__foo, __bar__, baz__", Marklight.strictBoldRegex) {
                if nestedMatches == 0 {
                    // Outer emphasis
                    if let result = $0,
                        result.numberOfRanges == 4 {
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 2))
                        XCTAssertEqual(result.rangeAt(3), NSMakeRange(2, 17))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    nestedMatches += 1
                    outerCallbackExp.fulfill()
                } else if nestedMatches == 1 {
                    // Inner emphasis
                    if let result = $0,
                        result.numberOfRanges == 4 {
                        XCTAssertEqual(result.rangeAt(0), NSMakeRange(7, 5))
                        XCTAssertEqual(result.rangeAt(1), NSMakeRange(7, 2))
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 3))
                        XCTAssertEqual(result.rangeAt(3), NSMakeRange(12, 2))
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
            match(string, Marklight.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 2))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(11, 3))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        boldNonMatches.forEach { string in
            match(string, Marklight.strictBoldRegex) { _ in
                XCTFail("\"\(string)\" should not match")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

// MARK: - Italic

/// A CommonMark compatible matcher should not match these.
fileprivate var italicNonMatches: [String] {
    return [
        "Calculate 1*2*3 please.",
        "Underscore my_name_now ok?",
        "no *newlines\n*",
        "_ foo bar_",
        "* a *",
        "a * foo bar*",
        "not _matching*",
        "not *matching_",
        "*(*foo)",
        "(foo*)*"
    ]
}

extension BoldItalicRegexTests {

    func testItalic() {

        ["hi *italic* text",
         "hi _italic_ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.italicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(3, 8))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(3, 1))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(4, 6))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(10, 1))
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
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(5, 6))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(5, 1))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(6, 4))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(10, 1))
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
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(9, 5))
                    XCTAssertEqual(result.rangeAt(1), NSMakeRange(9, 1))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(10, 3))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(13, 1))
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

    func testStrictItalic() {

        ["hi *italic* text",
         "hi _italic_ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, Marklight.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(3, 1))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(4, 6))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra_word_ emphasis", Marklight.strictItalicRegex) { _ in
            XCTFail("intraword emphasis with underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword emphasis")
            match("intra*word* emphasis", Marklight.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(5, 1))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(6, 4))
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
            match(string, Marklight.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 4 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 1))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(10, 3))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        italicNonMatches.forEach { string in
            match(string, Marklight.strictItalicRegex) { _ in
                XCTFail("\"\(string)\" should not match")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

// MARK: Mixed Bold & Italic

extension BoldItalicRegexTests {

    func testBoldAndItalic() {

        let italicCallback = expectation(description: "Matched italics")
        match("**hi *italic* text**", Marklight.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 4 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(5, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(6, 6))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold")
        match("**hi *italic* text**", Marklight.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 4 {
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(2, 16))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testItalicAndBold() {

        let italicCallback = expectation(description: "Matched italics")
        match("*hi **italic** text*", Marklight.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 4 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(1, 18))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold")
        match("*hi **italic** text*", Marklight.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 4 {
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(6, 6))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

}
