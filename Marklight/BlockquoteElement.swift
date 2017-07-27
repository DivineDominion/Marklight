//
//  BlockquoteElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches:
///
///     > Quoted text
struct BlockquoteElement: BlockElement {

    fileprivate static var blockQuotePattern: String { return [
        "(                           # Wrap whole match in $1",
        "    (",
        "    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
        "        .+\\n               # rest of the first line",
        "    (.+\\n)*                # subsequent consecutive lines",
        "    \\n*                    # blanks",
        "    )+",
        ")"
        ].joined(separator: "\n")
    }

    fileprivate static let blockQuoteRegex = Regex(pattern: blockQuotePattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static let blockQuoteOpeningRegex = Regex(pattern: "(^\\p{Z}*>\\p{Z})", options: [.anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        BlockquoteElement.blockQuoteRegex.matches(document) { (result) -> Void in
            theme.quoteStyle.apply(styleApplier, range: result.range)

            BlockquoteElement.blockQuoteOpeningRegex.matches(document.string, range: result.range) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { theme.syntaxStyle.apply(styleApplier, range: innerResult.range) }
            }
        }
    }
}
