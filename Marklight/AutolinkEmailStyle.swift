//
//  AutolinkEmailStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

struct AutolinkEmailStyle: InlineStyle {

    fileprivate static let autolinkEmailPattern = [
        "(?:mailto:)?",
        "(",
        "  [-.\\w]+",
        "  \\@",
        "  [-a-z0-9]+(\\.[-a-z0-9]+)*\\.[a-z]+",
        ")"
        ].joined(separator: "\n")

    fileprivate static let autolinkEmailRegex = Regex(pattern: autolinkEmailPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    fileprivate static let mailtoPattern = "mailto:"

    fileprivate static let mailtoRegex = Regex(pattern: mailtoPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])

    func apply(_ theme: MarklightTheme, styleApplier: MarklightStyleApplier, hideSyntax: Bool, paragraph: Paragraph) {
        AutolinkEmailStyle.autolinkEmailRegex.matches(paragraph) { (result) -> Void in
            let linkSubstring = (paragraph.string as NSString).substring(with: result.range)
            guard linkSubstring.lengthOfBytes(using: .utf8) > 0 else { return }
            styleApplier.addLinkAttribute(linkSubstring, range: result.range)

            if hideSyntax {
                AutolinkEmailStyle.mailtoRegex.matches(paragraph.string, range: result.range) { (innerResult) -> Void in
                    styleApplier.addHiddenAttributes(range: innerResult.range)
                }
            }
        }
    }
}
