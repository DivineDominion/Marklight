//
//  BoldStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct BoldStyle: InlineStyle {

    fileprivate static var strictBoldPattern: String {
        return "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"
    }

    static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.anchorsMatchLines])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        BoldStyle.strictBoldRegex.matches(paragraph) { (result) -> Void in
            styleApplier.embolden(range: result.range)

            let substring = (paragraph.string as NSString).substring(with: NSMakeRange(result.range.location, 1))
            var start = 0
            if substring == " " {
                start = 1
            }

            let preRange = NSMakeRange(result.range.location + start, 2)
            if hideSyntax { styleApplier.addHiddenAttributes(range: preRange) }
            else { theme.syntaxStyle.apply(styleApplier, range: preRange) }

            let postRange = NSMakeRange(result.range.location + result.range.length - 2, 2)
            if hideSyntax { styleApplier.addHiddenAttributes(range: postRange) }
            else { theme.syntaxStyle.apply(styleApplier, range: postRange) }
        }
    }
}
