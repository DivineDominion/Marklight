//
//  InlineImageStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches
///
///     ![Title](http://example.com/image.png)
struct InlineImageStyle: InlineStyle {

    fileprivate static var imageInlinePattern: String { return [
        "(!\\[)              # opening 1st bracket = $1",
        "    (.*?)           # alt text = $2",
        "(\\])               # closing 1st bracket = $3",
        "\\s?                # one optional whitespace character",
        "(\\()               # opening paren = $4",
        "    \\p{Z}*",
        "    (\(Marklight.nestedParensPattern))    # href = $5",
        "    \\p{Z}*",
        "    (               # $6",
        "    (['\"])         # quote char = $7",
        "    (.*?)           # title = $8",
        "    \\5             # matching quote",
        "    \\p{Z}*",
        "    )?              # title is optional",
        "(\\))               # closing paren = $9",
        ].joined(separator: "\n")
    }

    fileprivate static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        let codeFont = Marklight.codeFont

        InlineImageStyle.imageInlineRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            // TODO: add image attachment

            if hideSyntax {
                styleApplier.addHiddenAttributes(range: result.range)
                return
            }

            [result.range(at: 1),
             result.range(at: 3),
             result.range(at: 4),
             result.range(at: 9)].forEach { (bracketRange: NSRange) in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: bracketRange)
            }
        }
    }
}