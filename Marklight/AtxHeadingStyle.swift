//
//  AtxHeadingStyle.swift
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
struct AtxHeadingStyle: BlockStyle {

    fileprivate static var headerAtxPattern: String { return [
        "^(\\#{1,6})  # $1 = string of #'s",
        "\\p{Z}*",
        "(.+?)        # $2 = Header text",
        "\\p{Z}*",
        "(\\#*)       # $3 = optional closing #'s (not counted)",
        "\\n+"
        ].joined(separator: "\n")
    }

    fileprivate static let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        AtxHeadingStyle.headersAtxRegex.matches(document) { (result) -> Void in
            styleApplier.embolden(range: result.range)

            [result.rangeAt(1),
             result.rangeAt(3)].forEach { hashRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: hashRange) }
                else { Marklight.theme.syntaxStyle.apply(styleApplier, range: hashRange) }
            }
        }
    }
}
