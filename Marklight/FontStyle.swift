//
//  FontStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import struct Foundation.NSRange

/// Cascading style, i.e. you don't need to set any value
/// if you do not want to change the parent style of the
/// affected range.
public struct FontStyle {
    public static var empty: FontStyle {
        return FontStyle()
    }
    
    public let fontReplacement: MarklightFont?
    public let color: MarklightColor?

    public init(
        fontReplacement: MarklightFont? = nil,
        color: MarklightColor? = nil) {
        self.fontReplacement = fontReplacement
        self.color = color
    }

    public init(
        fontName: String,
        textSize: CGFloat,
        color: MarklightColor? = nil) {
        self.fontReplacement = namedFont(fontName, size: textSize)
        self.color = color
    }
}

extension FontStyle {
    internal func apply(_ styleApplier: MarklightStyleApplier, range: NSRange) {
        if let color = self.color {
            styleApplier.addColorAttribute(color, range: range)
        }

        if let font = self.fontReplacement {
            styleApplier.addFontAttribute(font, range: range)
        }
    }
}
