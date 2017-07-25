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
struct SetextHeadingStyle: BlockStyle {

    fileprivate static var headerSetextPattern: String { return [
        "^(.+?)",
        "\\p{Z}*",
        "\\n",
        "(==+|--+)",  // $1 = string of ='s or -'s
        "\\p{Z}*",
        "\\n+"
        ].joined(separator: "\n")
    }

    fileprivate static let headersSetextRegex = Regex(pattern: headerSetextPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {
        SetextHeadingStyle.headersSetextRegex.matches(document) { (result) -> Void in
            styleApplier.embolden(range: result.range)
            theme.syntaxStyle.apply(styleApplier, range: result.rangeAt(1))
        }
    }
}
