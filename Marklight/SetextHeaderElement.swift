//
//  SetextHeaderStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches:
///
///     Heading
///     =======
///
///     Subheading
///     ----------
struct SetextHeadingElement: BlockElement {

    fileprivate static var headerSetextPattern: String { return [
        "^(.+?)",     // $1 = Heading text
        "\\p{Z}*",
        "\\n",
        "(==+|--+)",  // $2 = string of ='s or -'s
        "\\p{Z}*",
        "\\n+"
        ].joined(separator: "\n")
    }

    fileprivate static let headersSetextRegex = Regex(pattern: headerSetextPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {
        SetextHeadingElement.headersSetextRegex.matches(document) { (result) -> Void in
            styleApplier.embolden(range: result.range)
            theme.syntaxStyle.apply(styleApplier, range: result.rangeAt(2))
        }
    }
}