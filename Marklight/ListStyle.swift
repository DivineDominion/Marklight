//
//  ListStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct ListStyle: BlockStyle {

    fileprivate static var _markerUL: String { return "[*+-]" }
    fileprivate static var _markerOL: String { return "\\d+[.]" }
    fileprivate static var _listMarker: String { return "(?:\(_markerUL)|\(_markerOL))" }
    fileprivate static let listOpeningRegex = Regex(pattern: _listMarker, options: [.allowCommentsAndWhitespace])

    fileprivate static var _wholeList: String { return [
        "(                               # $1 = whole list",
        "  (                             # $2",
        "    \\p{Z}{0,3}",
        "    (\(_listMarker))            # $3 = first list item marker",
        "    \\p{Z}+",
        "  )",
        "  (?s:.+?)",
        "  (                             # $4",
        "      \\z",
        "    |",
        "      \\n{2,}",
        "      (?=\\S)",
        "      (?!                       # Negative lookahead for another list item marker",
        "        \\p{Z}*",
        "        \(_listMarker)\\p{Z}+",
        "      )",
        "  )",
        ")"
        ].joined(separator: "\n")
    }
    fileprivate static var listPattern: String { return "(?:(?<=\\n\\n)|\\A\\n?)" + _wholeList }
    fileprivate static let listRegex = Regex(pattern: listPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        ListStyle.listRegex.matches(document) { (result) -> Void in
            ListStyle.listOpeningRegex.matches(document.string, range: result.range) { (innerResult) -> Void in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range)
            }
        }
    }
}
