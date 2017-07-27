//
//  SpanStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-27.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import struct Foundation.NSRange

public struct SpanStyle {
    public static var inherit: SpanStyle {
        return SpanStyle(fontStyle: .inherit)
    }

    public var fontStyle: FontStyle

    public init(fontStyle: FontStyle) {
        self.fontStyle = fontStyle
    }
}

extension SpanStyle {
    internal func apply(_ styleApplier: MarklightStyleApplier, range: NSRange) {
        fontStyle.apply(styleApplier, range: range)
    }
}

#if os(iOS)
// MARK: - Dynamic Type

extension SpanStyle {
    public mutating func refreshFontSize() {
        self.fontStyle.refreshFontSize()
    }
}
#endif
