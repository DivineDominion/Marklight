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
            "(^|[\\W_]) (?:(?!\\1)|(?=^))",
            "(\\*|_)(?:(?!\\2)|(?=\\2\\2)) (?=\\S)", // opening
            "(.*?(?!\\2)\\S)",                  // content
            "\\2(?:(?!\\2)|(?=\\2\\2))",            // closing
            "(?=[\\W_]|$)"
            ].joined(separator: "")
    }

    static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    let innerBoldStyle = BoldStyle()

    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        ItalicStyle.strictItalicRegex.matches(paragraph) { result in

            styleApplier.italicize(range: result.range)

            // Previously applied inner bold text would have been overwritten by now
            let innerTextRange = result.range(at: 3)
            self.innerBoldStyle.apply(
                styleApplier,
                hideSyntax: hideSyntax,
                paragraph: Paragraph(string: paragraph.string, paragraphRange: innerTextRange))

            let substring = (paragraph.string as NSString).substring(with: NSMakeRange(result.range.location, 1))
            var start = 0
            if substring == " " {
                start = 1
            }

            let preRange = NSMakeRange(result.range.location + start, 1)
            styleApplier.addColorAttribute(Marklight.syntaxColor, range: preRange)
            if hideSyntax { styleApplier.addHiddenAttributes(range: preRange) }

            let postRange = NSMakeRange(result.range.location + result.range.length - 1, 1)
            styleApplier.addColorAttribute(Marklight.syntaxColor, range: postRange)
            if hideSyntax { styleApplier.addHiddenAttributes(range: postRange) }
        }
    }
}
