//
//  ReferenceDefinitionStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct ReferenceDefinitionStyle: BlockStyle {

    fileprivate static var referenceLinkPattern: String { return [
        "^\\p{Z}{0,3}\\[([^\\[\\]]+)\\]:  # id = $1",
        "  \\p{Z}*",
        "  \\n?                   # maybe *one* newline",
        "  \\p{Z}*",
        "<?(\\S+?)>?              # url = $2",
        "  \\p{Z}*",
        "  \\n?                   # maybe one newline",
        "  \\p{Z}*",
        "(?:",
        "    (?<=\\s)             # lookbehind for whitespace",
        "    [\"(]",
        "    (.+?)                # title = $3",
        "    [\")]",
        "    \\p{Z}*",
        ")?                       # title is optional",
        "(?:\\n+|\\Z)"
        ].joined(separator: "")
    }

    fileprivate static let referenceLinkRegex = Regex(pattern: referenceLinkPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        ReferenceDefinitionStyle.referenceLinkRegex.matches(document) { (result) -> Void in
            styleApplier.addColorAttribute(Marklight.syntaxColor, range: result.range)
        }
    }
}
