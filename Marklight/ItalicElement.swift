//
//  ItalicElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct ItalicElement: SpanElement {

    fileprivate static var strictItalicPattern: String {
        return [
            "(^|\\s|[:alpha:])",
            "(?:[\\*_]{0}|[\\*_]{2})(\\*|(?<=^|\\W)_)(?!\\2) (?=\\S)", // $2 = opening _/* innermost as possible
            "(",                                                       // $3 = content
            "  (?:[:alnum:]{1}|[\\*_]{2})", // Do not apply to numbers (do not match 1*2*3=6), but bold syntax
            "  .*?(?!\\2)\\S",
            ")",
            "(\\2) (?:(?!\\2)|(?=\\2\\2))",                            // $4 = closing _/*
            ].joined()
    }

    static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    let innerBoldElement = BoldElement()

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        ItalicElement.strictItalicRegex.matches(paragraph) { result in
            let innerTextRange = result.rangeAt(3)

            // Do not make the syntax glyphs themselves italic
            styleApplier.italicize(range: innerTextRange)

            if hideSyntax {
                // Bold font was already applied, but if italics surround 
                // bold syntax, the previously hidden **/__ now have 
                // regular font size again.
                self.innerBoldElement.apply(
                    theme,
                    styleApplier: styleApplier,
                    hideSyntax: hideSyntax,
                    paragraph: Paragraph(string: paragraph.string, paragraphRange: innerTextRange))
            }

            [result.rangeAt(2),
             result.rangeAt(4)].forEach { syntaxRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: syntaxRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: syntaxRange) }
            }
        }
    }
}
