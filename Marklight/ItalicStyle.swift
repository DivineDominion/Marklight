//
//  ItalicStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct ItalicStyle: InlineStyle {

    fileprivate static var strictItalicPattern: String {
        return [
            "(?:[\\*_]{0}|[\\*_]{2})(\\*|(?<=\\W)_)(?!\\1) (?=\\S)", // $1 = opening _/* innermost as possible
            "(.*?(?!\\1)\\S)",                                       // $2 = content
            "(\\1) (?:(?!\\1)|(?=\\1\\1))",                          // $3 = closing _/*
            ].joined()
    }

    static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    let innerBoldStyle = BoldStyle()

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        ItalicStyle.strictItalicRegex.matches(paragraph) { result in
            let innerTextRange = result.rangeAt(2)

            // Do not make the syntax glyphs themselves italic
            styleApplier.italicize(range: innerTextRange)

            if hideSyntax {
                // Bold font was already applied, but if italics surround 
                // bold syntax, the previously hidden **/__ now have 
                // regular font size again.
                self.innerBoldStyle.apply(
                    theme,
                    styleApplier: styleApplier,
                    hideSyntax: hideSyntax,
                    paragraph: Paragraph(string: paragraph.string, paragraphRange: innerTextRange))
            }

            [result.rangeAt(1),
             result.rangeAt(3)].forEach { syntaxRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: syntaxRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: syntaxRange) }
            }
        }
    }
}
