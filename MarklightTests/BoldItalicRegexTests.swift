//
//  BoldItalicRegexTests.swift
//  Marklight
//
//  Created by Christian Tietze on 21.07.17.
//  Copyright © 2017 Dolomate. All rights reserved.
//

import XCTest
@testable import Marklight

/// Helper to match the whole `string` with `regex`.
func match(_ string: String, _ regex: Regex, completion: @escaping (NSTextCheckingResult?) -> Void) {

    let wholeRange = NSRange(location: 0, length: (string as NSString).length)

    regex.matches(string, range: wholeRange, completion: completion)
}

class BoldItalicRegexTests: XCTestCase {
}

// MARK: - Bold

/// A CommonMark compatible matcher should not match these.
internal var boldNonMatches: [String] {
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

    func testStrictBold() {

        ["hi **bold** text",
         "hi __bold__ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, BoldStyle.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 6 {
                    XCTAssertEqual(result.rangeAt(4), NSMakeRange(5, 4))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra__word__ emphasis", BoldStyle.strictBoldRegex) { _ in
            XCTFail("intraword emphasis with underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword bold emphasis")
            match("intra**word** emphasis", BoldStyle.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 6 {
                    XCTAssertEqual(result.rangeAt(0), NSMakeRange(5, 8))
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(5, 2))
                    XCTAssertEqual(result.rangeAt(4), NSMakeRange(7, 4))
                    XCTAssertEqual(result.rangeAt(5), NSMakeRange(11, 2))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                }
                callbackExp.fulfill()
            }
        }

        do {
            var nestedMatches = 0
            let outerCallbackExp = expectation(description: "Matched nested outer bold")
            let innerCallbackExp = expectation(description: "Matched nested inner bold")
            match("__foo, __bar__, baz__", BoldStyle.strictBoldRegex) {
                if nestedMatches == 0 {
                    // Outer emphasis
                    if let result = $0,
                        result.numberOfRanges == 6 {
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 2))
                        XCTAssertEqual(result.rangeAt(4), NSMakeRange(2, 17))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    outerCallbackExp.fulfill()
                } else if nestedMatches == 1 {
                    // Inner emphasis
                    if let result = $0,
                        result.numberOfRanges == 6 {
                        XCTAssertEqual(result.rangeAt(2), NSMakeRange(7, 2))
                        XCTAssertEqual(result.rangeAt(4), NSMakeRange(9, 3))
                        XCTAssertEqual(result.rangeAt(5), NSMakeRange(12, 2))
                    } else {
                        XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
                    }
                    innerCallbackExp.fulfill()
                }
                nestedMatches += 1
            }
            XCTAssertEqual(nestedMatches, 2, "Should match twice")
        }

        // Left & right flanking
        ["Sentence **end**.",
         "Sentence __end__."].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, BoldStyle.strictBoldRegex) {
                if let result = $0,
                    result.numberOfRanges == 6 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 2))
                    XCTAssertEqual(result.rangeAt(4), NSMakeRange(11, 3))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        boldNonMatches.forEach { string in
            match(string, BoldStyle.strictBoldRegex) { _ in
                XCTFail("\"\(string)\" should not match")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

// MARK: - Italic

/// A CommonMark compatible matcher should not match these.
internal var italicNonMatches: [String] {
    return [
        "Calculate 1*2*3 please.",
        "Underscore my_name_now ok?",
        "no *newlines\n*",
        "_ foo bar_",
        "* a *",
        "a * foo bar*",
        "not _matching*",
        "not *matching_",
        "no *(*foo)",
        "nah (foo*)*"
    ]
}

extension BoldItalicRegexTests {

    func testStrictItalic() {

        ["hi *italic* text",
         "hi _italic_ text"].forEach { string in
            let callbackExp = expectation(description: "Matched \(string)")
            match(string, ItalicStyle.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 5 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(3, 1))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(4, 6))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        match("intra_word_ emphasis", ItalicStyle.strictItalicRegex) { _ in
            XCTFail("intraword emphasis with underscore disallowed")
        }
        do {
            let callbackExp = expectation(description: "Matched intraword emphasis")
            match("intra*word* emphasis", ItalicStyle.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 5 {
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
            match(string, ItalicStyle.strictItalicRegex) {
                if let result = $0,
                    result.numberOfRanges == 5 {
                    XCTAssertEqual(result.rangeAt(2), NSMakeRange(9, 1))
                    XCTAssertEqual(result.rangeAt(3), NSMakeRange(10, 3))
                } else {
                    XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges))) in \(string)")
                }
                callbackExp.fulfill()
            }
        }

        italicNonMatches.forEach { string in
            match(string, ItalicStyle.strictItalicRegex) { _ in
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
        match("**hi *italic* text**", ItalicStyle.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 5 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(5, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(6, 6))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold")
        match("**hi *italic* text**", BoldStyle.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 6 {
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(2, 16))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testBoldAndItalic_SameGlyph_NestingPrecedence() {

        let italicCallback = expectation(description: "Matched italics on the inside")
        match("***italic***", ItalicStyle.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 5 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(2, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(3, 6))
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(9, 1))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold on the outside")
        match("***bold***", BoldStyle.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 6 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 2))
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(2, 6))
                XCTAssertEqual(result.rangeAt(5), NSMakeRange(8, 2))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testItalicAndBold() {

        let italicCallback = expectation(description: "Matched italics")
        match("*hi **italic** text*", ItalicStyle.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 5 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(1, 18))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold")
        match("*hi **italic** text*", BoldStyle.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 6 {
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(6, 6))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testItalicAndBold_DifferentGlyphWithoutAlphanumericCharacterInBetween() {

        let italicCallback = expectation(description: "Matched italics next to bold syntax")
        match("_**italic**_", ItalicStyle.strictItalicRegex) {
            if let result = $0,
                result.numberOfRanges == 5 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(0, 1))
                XCTAssertEqual(result.rangeAt(3), NSMakeRange(1, 10))
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(11, 1))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            italicCallback.fulfill()
        }

        let boldCallback = expectation(description: "Matched bold")
        match("_**bold**_", BoldStyle.strictBoldRegex) {
            if let result = $0,
                result.numberOfRanges == 6 {
                XCTAssertEqual(result.rangeAt(2), NSMakeRange(1, 2))
                XCTAssertEqual(result.rangeAt(4), NSMakeRange(3, 4))
                XCTAssertEqual(result.rangeAt(5), NSMakeRange(7, 2))
            } else {
                XCTFail("wrong number of matches (\(String(describing: $0?.numberOfRanges)))")
            }
            boldCallback.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
