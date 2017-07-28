//
//  CodeBlockElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

/// Matches fenced code blocks:
///
///    ```
///    Code here
///    ```
///
/// And standard indented blocks:
///
///        Code here
///
struct CodeBlockElement: BlockElement {

    fileprivate static var codeBlockPattern: String { return [
        "(?:\\n\\n|\\A\\n?)",
        "(                        # $1 = the code block -- one or more lines, starting with a space",
        "(?:",
        "    (?:[\\p{Z}]{4}|\\t)  # Lines must start with a tab-width of spaces",
        "    .*\\n+",
        ")+",
        ")",
        "((?=^\\p{Z}{0,3}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
        ].joined(separator: "\n")
    }

    fileprivate static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static var fencedCodeBlockPattern: String { return [
        "^\\n(`{3}([\\S]+)?)\\n",  // $1 = opening fence, $2 = language
        "([\\s\\S]+?)",         // $3 = code block
        "\\n(`{3})\\n"             // $4 = opening fence
        ].joined(separator: "")
    }

    fileprivate static let fencedCodeBlockRegex = Regex(pattern: fencedCodeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        CodeBlockElement.codeBlockRegex.matches(document) { (result) -> Void in
            theme.codeBlockStyle.apply(styleApplier, range: result.range)
        }

        CodeBlockElement.fencedCodeBlockRegex.matches(document) { (result) -> Void in
            theme.codeBlockStyle.apply(styleApplier, range: result.range)

            [result.rangeAt(1),
             result.rangeAt(4)].forEach { fenceRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: fenceRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: fenceRange) }
            }
        }
    }
}
