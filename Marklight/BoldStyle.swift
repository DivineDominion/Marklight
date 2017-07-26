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
            "(",                                // $1 = all emphasized stuff
            "  ((\\*|(?<=\\W)_)\\3) (?=\\S)",   // $2 = opening __/**, $3 = single _/*
            "  (.*?\\S)",                       // $4 = content
            "  (\\3\\3) (?!\\3)",               // $5 = closing double __/**
            ")"
        ].joined()
    }

    static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.anchorsMatchLines, .allowCommentsAndWhitespace])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        BoldStyle.strictBoldRegex.matches(paragraph) { (result) -> Void in
            styleApplier.embolden(range: result.rangeAt(1))

            [result.rangeAt(2),
             result.rangeAt(5)].forEach { syntaxRange in
                if hideSyntax { styleApplier.addHiddenAttributes(range: syntaxRange) }
                else { theme.syntaxStyle.apply(styleApplier, range: syntaxRange) }
            }
        }
    }
}
