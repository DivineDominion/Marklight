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
        "(               # wrap whole match in $1",
        "!\\[",
        "    (.*?)       # alt text = $2",
        "\\]",
        "",
        "\\p{Z}?            # one optional space",
        "(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
        "",
        "\\[",
        "    (.*?)       # id = $3",
        "\\]",
        "",
        ")"
        ].joined(separator: "\n")
    }

    fileprivate static let imageRegex = Regex(pattern: imagePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)

        ReferenceImageStyle.imageRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            // TODO: add image attachment
            Marklight.imageOpeningSquareRegex.matches(paragraph.string, range: paragraph.paragraphRange) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.imageClosingSquareRegex.matches(paragraph.string, range: paragraph.paragraphRange) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }

            if Marklight.hideSyntax {
                styleApplier.addHiddenAttributes(range: result.range)
            }
        }
    }
}
