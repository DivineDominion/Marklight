//
//  InlineLinkStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct InlineLinkStyle: InlineStyle {

    fileprivate static var anchorInlinePattern: String { return [
        "(                           # wrap whole match in $1",
        "    \\[",
        "        (\(Marklight.getNestedBracketsPattern()))   # link text = $2",
        "    \\]",
        "    \\(                     # literal paren",
        "        \\p{Z}*",
        "        (\(Marklight.getNestedParensPattern()))   # href = $3",
        "        \\p{Z}*",
        "        (                   # $4",
        "        (['\"])           # quote char = $5",
        "        (.*?)               # title = $6",
        "        \\5                 # matching quote",
        "        \\p{Z}*                # ignore any spaces between closing quote and )",
        "        )?                  # title is optional",
        "    \\)",
        ")"
        ].joined(separator: "\n")
    }

    fileprivate static let anchorInlineRegex = Regex(pattern: anchorInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)

        InlineLinkStyle.anchorInlineRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            var destinationLink : String?

            Marklight.coupleRoundRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range) }
                
                var range = innerResult.range
                range.location = range.location + 1
                range.length = range.length - 2

                let substring = (paragraph.string as NSString).substring(with: range)
                guard substring.lengthOfBytes(using: .utf8) > 0 else { return }

                destinationLink = substring
                styleApplier.addLinkAttribute(substring, range: range)
            }

            Marklight.openingSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range) }
            }

            Marklight.closingSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range) }
            }

            guard let destinationLinkString = destinationLink else { return }

            Marklight.coupleSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
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
