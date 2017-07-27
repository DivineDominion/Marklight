//
//  AtxHeadingElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches
///
///     # Heading
///
///     ## Subheading ##
struct AtxHeadingElement: BlockElement {

    fileprivate static var headerAtxPattern: String { return [
        "^[\\ ]{0,3}\\\\{0}(\\#{1,6})", // $1 = string of #'s
        "\\p{Z}+",
        "(.+?)",                        // $2 = Header text
        "\\p{Z}*",
        "(\\#*)",                       // $3 = optional closing #'s (not counted)
        "\\n+"
        ].joined(separator: "\n")
    }

    fileprivate static let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        AtxHeadingElement.headersAtxRegex.matches(document) { (result) -> Void in
            // TODO: Solve quickfix.
            // Without re-applying the base style, on iOS the headers will 
            // obtain a hidden style when you type elsewhere.
            theme.baseStyle.apply(styleApplier, range: result.range)

            styleApplier.embolden(range: result.range)

            [result.rangeAt(1),
             result.rangeAt(3)].forEach { hashRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: hashRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: hashRange) }
            }
        }
    }
}
