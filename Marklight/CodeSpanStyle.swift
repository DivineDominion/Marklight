//
//  CodeSpanStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct CodeSpanStyle: InlineStyle {

    fileprivate static var codeSpanPattern: String { return [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `",
        "(?!`)          # and no more backticks -- match the full run",
        "(.+?)          # $2 = The code block",
        "(?<!`)",
        "\\1",
        "(?!`)"
        ].joined(separator: "\n")
    }

    fileprivate static let codeSpanRegex = Regex(pattern: codeSpanPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    fileprivate static var codeSpanOpeningPattern: String { return [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    }

    fileprivate static let codeSpanOpeningRegex = Regex(pattern: codeSpanOpeningPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    fileprivate static var codeSpanClosingPattern: String { return [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    }

    fileprivate static let codeSpanClosingRegex = Regex(pattern: codeSpanClosingPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])


    func apply(_ styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {


        let codeFont = Marklight.codeFont
        let codeColor = Marklight.codeColor
        
        CodeSpanStyle.codeSpanRegex.matches(paragraph) { (result) -> Void in
            styleApplier.addFontAttribute(codeFont, range: result.range)
            styleApplier.addColorAttribute(codeColor, range: result.range)

            CodeSpanStyle.codeSpanOpeningRegex.matches(paragraph) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range) }
            }
            CodeSpanStyle.codeSpanClosingRegex.matches(paragraph) { (innerResult) -> Void in
                if hideSyntax { styleApplier.addHiddenAttributes(range: innerResult.range) }
                else { styleApplier.addColorAttribute(Marklight.syntaxColor, range: innerResult.range) }
            }
        }
    }
}
