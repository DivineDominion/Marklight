//
//  CodeBlockStyle.swift
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
struct CodeBlockStyle: BlockStyle {

    fileprivate static var codeBlockPattern: String { return [
        "(?:\\n\\n|\\A\\n?)",
        "(                        # $1 = the code block -- one or more lines, starting with a space",
        "(?:",
        "    (?:[\\p{Z}]{4})       # Lines must start with a tab-width of spaces",
        "    .*\\n+",
        ")+",
        ")",
        "((?=^\\p{Z}{0,3}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
        ].joined(separator: "\n")
    }

    fileprivate static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static var fencedCodeBlockPattern: String { return [
        "^(`{3}([\\S]+)?)\\n",  // $1 = opening fence, $2 = language
        "([\\s\\S]+)",          // $3 = code block
        "\\n(`{3})"             // $4 = opening fence
        ].joined(separator: "")
    }

    fileprivate static let fencedCodeBlockRegex = Regex(pattern: fencedCodeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, document: Document) {

        // TODO: refactor in Marklight to not compute this everytime
        let codeFont = Marklight.codeFont(Marklight.textSize)
        let codeColor = Marklight.codeColor

        CodeBlockStyle.codeBlockRegex.matches(document) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)
            styleApplier.addColorAttribute(codeColor, range: result.range)
        }

        CodeBlockStyle.fencedCodeBlockRegex.matches(document) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)

            [result.rangeAt(1),
             result.rangeAt(4)].forEach { fenceRange in
                styleApplier.addColorAttribute(Marklight.syntaxColor, range: fenceRange)
            }

            styleApplier.addColorAttribute(codeColor, range: result.rangeAt(3))
        }
    }
}
