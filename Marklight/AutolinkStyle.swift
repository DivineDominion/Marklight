//
//  AutolinkStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct AutolinkStyle: InlineStyle {

    fileprivate static var autolinkPattern: String { return "((https?|ftp):[^'\">\\s]+)" }
    fileprivate static let autolinkRegex = Regex(pattern: autolinkPattern, options: [.dotMatchesLineSeparators])

    fileprivate static var autolinkPrefixPattern: String { return "((https?|ftp)://)" }
    fileprivate static let autolinkPrefixRegex = Regex(pattern: autolinkPrefixPattern, options: [.dotMatchesLineSeparators])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {

        AutolinkStyle.autolinkRegex.matches(paragraph) { (result) -> Void in
            let linkSubstring = (paragraph.string as NSString).substring(with: result.range)
            guard linkSubstring.lengthOfBytes(using: .utf8) > 0 else { return }
            styleApplier.addLinkAttribute(linkSubstring, range: result.range)

            if hideSyntax {
                AutolinkStyle.autolinkPrefixRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                    styleApplier.addHiddenAttributes(range: innerResult.range)
                }
            }
        }
    }
}
