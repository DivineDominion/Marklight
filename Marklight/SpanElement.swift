//
//  SpanElement.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

internal struct Paragraph {
    let string: String
    let paragraphRange: NSRange
}

internal protocol SpanElement {
    func apply(
        _ theme: MarklightTheme,
        styleApplier: MarklightStyleApplier,
        hideSyntax: Bool,
        paragraph: Paragraph)
}

extension Regex {
    /// Applies this compiled regular expression to the
    /// `Paragraph` only, used for inline styles.
    ///
    /// - parameter paragraph: Part of the document to match.
    /// - parameter completion: Callback for each match in the `paragraph`.
    internal func matches(_ paragraph: Paragraph, completion: @escaping (NSTextCheckingResult) -> Void) {

        matches(
            paragraph.string,
            range: paragraph.paragraphRange,
            completion: completion)
    }
}
