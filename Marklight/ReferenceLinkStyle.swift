//
//  ReferenceLinkInlineStyle
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Style for:
///
///    [Title](http://example.com)
struct ReferenceLinkStyle: InlineStyle {

    fileprivate static var anchorPattern: String { return [
        "(                                  # wrap whole match in $1",
        "    \\[",
        "        (\(Marklight.getNestedBracketsPattern()))  # link text = $2",
        "    \\]",
        "",
        "    \\p{Z}?                        # one optional space",
        "    (?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
        "",
        "    \\[",
        "        (.*?)                      # id = $3",
        "    \\]",
        ")"
        ].joined(separator: "\n")
    }

    fileprivate static let anchorRegex = Regex(pattern: anchorPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)

        ReferenceLinkStyle.anchorRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            // TODO: use match sub ranges
            Marklight.openingSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.closingSquareRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }

            // TODO: see issue #12; what is this used for?
            Marklight.parenRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)

                if hideSyntax {
                    styleApplier.addHiddenAttributes(range: NSMakeRange(innerResult.range.location, 1))
                    styleApplier.addHiddenAttributes(range: NSMakeRange(innerResult.range.location + innerResult.range.length - 1, 1))
                }
            }
        }
    }
}
