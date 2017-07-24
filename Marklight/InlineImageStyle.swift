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
        "(                     # wrap whole match in $1",
        "  !\\[",
        "      (.*?)           # alt text = $2",
        "  \\]",
        "  \\s?                # one optional whitespace character",
        "  \\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])       # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joined(separator: "\n")
    }

    fileprivate static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)

        InlineImageStyle.imageInlineRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            // TODO: add image attachment

            if hideSyntax { styleApplier.addHiddenAttributes(range: result.range) }

            Marklight.imageOpeningSquareRegex.matches(paragraph.string, range: paragraph.paragraphRange) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.imageClosingSquareRegex.matches(paragraph.string, range: paragraph.paragraphRange) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.parenRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
        }
    }
}
