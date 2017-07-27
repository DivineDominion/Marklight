//
//  ListElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct ListElement: BlockElement {

    fileprivate static var _markerUL: String { return "[*+-]" }
    fileprivate static var _markerOL: String { return "\\d+[.]" }
    fileprivate static var _listMarker: String { return "(?:\(_markerUL)|\(_markerOL))" }

    fileprivate static var listPattern: String { return [
        "(?:(?<=\\n\\n)|\\A\\n?)",
        "(",                     // $1 = whole list
        "  (",                   // $2
        "    \\p{Z}{0,3}",
        "    (\(_listMarker))",  // $3 = first list item marker
        "    \\p{Z}+",
        "  )",
        "  (?s:.+?)",
        "  (",                   // $4
        "      \\z",
        "    |",
        "      \\n{2,}",
        "      (?=\\S)",
        "      (?!",             // Negative lookahead for another list item marker
        "        \\p{Z}*",
        "        \(_listMarker)\\p{Z}+",
        "      )",
        "  )",
        ")"
        ].joined()
    }

    fileprivate static let listRegex = Regex(pattern: listPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static var listItemPattern: String { return [
        "^\\p{Z}*(\(_listMarker))", // $1 = list marker
        "(.*?)$"                    // $2 = list item text
        ].joined()
    }

    fileprivate static let listItemRegex = Regex(pattern: listItemPattern, options: [.anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        ListElement.listRegex.matches(document) { (result) -> Void in
            theme.listStyle.apply(styleApplier, range: result.range)

            ListElement.listItemRegex.matches(document.string, range: result.range) { (innerResult) -> Void in
                theme.syntaxStyle.apply(styleApplier, range: innerResult.rangeAt(1))
            }
        }
    }
}
