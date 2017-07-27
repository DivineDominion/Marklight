//
//  InlineLinkElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches:
///
///    foo [bar](http://baz/)
struct InlineLinkElement: SpanElement {

    fileprivate static var anchorInlinePattern: String { return [
        "(\\[)                   # opening 1st bracket = $1",
        "    (\(Marklight.nestedBracketsPattern))   # link text = $2",
        "(\\])                   # closing 1st bracket = $3",
        "(\\()                   # opening paren = $4",
        "    \\p{Z}*",
        "    (\(Marklight.nestedParensPattern))   # href = $5",
        "    \\p{Z}*",
        "    (                   # $6",
        "        (['\"])         # quote char = $7",
        "        (.*?)           # title = $8",
        "        \\5             # matching quote",
        "        \\p{Z}*         # ignore any spaces between closing quote and )",
        "    )?                  # title is optional",
        "(\\))                   # closing paren = $9",
        ].joined(separator: "\n")
    }

    fileprivate static let anchorInlineRegex = Regex(pattern: anchorInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    internal static let coupleSquareRegex  = Regex(pattern: "\\[(.*?)\\]", options: [])
    internal static let coupleRoundRegex   = Regex(pattern: "\\((.*?)\\)", options: [])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        InlineLinkElement.anchorInlineRegex.matches(paragraph) { (result) -> Void in
            theme.linkStyle.apply(styleApplier, range: result.range)

            var destinationLink : String?

            // TODO: use $5?
            InlineLinkElement.coupleRoundRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { theme.syntaxStyle.apply(styleApplier, range: innerResult.range) }
                
                var range = innerResult.range
                range.location = range.location + 1
                range.length = range.length - 2

                let substring = (paragraph.string as NSString).substring(with: range)
                guard substring.lengthOfBytes(using: .utf8) > 0 else { return }

                destinationLink = substring
                styleApplier.addLinkAttribute(substring, range: range)
            }

            [result.rangeAt(1),
             result.rangeAt(3)].forEach { (bracketRange: NSRange) in
                theme.syntaxStyle.apply(styleApplier, range: bracketRange)
            }

            guard let destinationLinkString = destinationLink else { return }

            // TODO: use $2?
            InlineLinkElement.coupleSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                var range = innerResult.range
                range.location = range.location + 1
                range.length = range.length - 2

                let substring = (paragraph.string as NSString).substring(with: range)
                guard substring.lengthOfBytes(using: .utf8) > 0 else { return }

                styleApplier.addLinkAttribute(destinationLinkString, range: range)
            }
        }
    }
}
