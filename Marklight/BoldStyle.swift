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
        return [
            "(^|[\\W_])",                       // $1
            "(",                                // $2 = all emphasized stuff
            "  ((\\*|_)\\4) (?=\\S)",           // $3 = opening __/**, $4 = single _/*
            "  (.*?\\S)",                       // $5 = content
            "  (\\4\\4) (?!\\4)",               // $6 = closing double __/**
            ")"
        ].joined()
    }

    static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.anchorsMatchLines, .allowCommentsAndWhitespace])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        BoldStyle.strictBoldRegex.matches(paragraph) { (result) -> Void in
            styleApplier.embolden(range: result.rangeAt(2))

            [result.rangeAt(3),
             result.rangeAt(6)].forEach { syntaxRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: syntaxRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: syntaxRange) }
            }
        }
    }
}
