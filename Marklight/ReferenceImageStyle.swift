//
//  ReferenceImageStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 24.07.17.
//  Copyright © 2017 Dolomate. All rights reserved.
//

import Foundation

/// Matches
///
///     ![Title][identifier]
struct ReferenceImageStyle: InlineStyle {

    fileprivate static var imagePattern: String { return [
        "(!\\[)          # opening 1st bracket = $1",
        "    (.*?)       # alt text = $2",
        "(\\])           # closing 1st bracket = $3",
        "",
        "\\p{Z}?            # one optional space",
        "(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
        "",
        "(\\[)           # opening 2nd bracket = $4",
        "    (.*?)       # id = $5",
        "(\\])           # opening 1st bracket = $6",
        ].joined(separator: "\n")
    }

    fileprivate static let imageRegex = Regex(pattern: imagePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        let codeFont = Marklight.codeFont

        ReferenceImageStyle.imageRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            // TODO: add image attachment

            if Marklight.hideSyntax {
                styleApplier.addHiddenAttributes(range: result.range)
                return
            }

            [result.rangeAt(1),
             result.rangeAt(3),
             result.rangeAt(4),
             result.rangeAt(6)].forEach { (bracketRange: NSRange) in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: bracketRange)
            }
        }
    }
}
