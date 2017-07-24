//
//  BlockStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-24.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

internal struct Document {
    let string: String
    let wholeRange: NSRange
}

internal protocol BlockStyle {
    func apply(
        _ styleApplier: MarklightStyleApplier,
        hideSyntax: Bool,
        document: Document)
}

extension Regex {
    /// Applies this compiled regular expression to the
    /// whole `Document`, used for block style definitions.
    ///
    /// - parameter document: Part of the document to match.
    /// - parameter completion: Callback for each match in the `document`.
    internal func matches(_ document: Document, completion: @escaping (NSTextCheckingResult) -> Void) {

        matches(
            document.string,
            range: document.wholeRange,
            completion: completion)
    }
}
