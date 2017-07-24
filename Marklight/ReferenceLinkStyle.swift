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
        "(\\[)                          # opening 1st bracket = $1",
        "    (\(Marklight.getNestedBracketsPattern()))  # link text = $2",
        "(\\])                          # closing 1st bracket = $3",
        "",
        "\\p{Z}?                        # one optional space",
        "(?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
        "",
        "(\\[)                          # opening 2nd bracket = $4",
        "    (.*?)                      # id = $5",
        "(\\])                          # opening 2nd bracket = $6",
        ].joined(separator: "\n")
    }

    fileprivate static let anchorRegex = Regex(pattern: anchorPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)

        ReferenceLinkStyle.anchorRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            [result.rangeAt(1),
             result.rangeAt(3),
             result.rangeAt(4),
             result.rangeAt(6)].forEach { (bracketRange: NSRange) in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: bracketRange)
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
