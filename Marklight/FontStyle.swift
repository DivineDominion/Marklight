//
//  FontStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import struct Foundation.NSRange
#if os(macOS)
import struct Foundation.CGFloat
#endif

/// Cascading style, i.e. you don't need to set any value
/// if you do not want to change the parent style of the
/// affected range.
public struct FontStyle {
    public static var inherit: FontStyle {
        return FontStyle()
    }
    
    public var fontReplacement: MarklightFont?
    public var color: MarklightColor?

    #if os(iOS)
    /// Used to recompute the text size. Trumps the
    /// `fontReplacement`'s own text size if set to non-nil.
    public var fontTextStyle: UIFontTextStyle?
    #endif

    public init(
        fontReplacement: MarklightFont? = nil,
        color: MarklightColor? = nil) {
        self.fontReplacement = fontReplacement
        self.color = color

        #if os(iOS)
        self.fontTextStyle = nil
        #endif
    }

    public init(
        fontName: String,
        textSize: CGFloat,
        color: MarklightColor? = nil) {
        let font = namedFont(fontName, size: textSize)
        self.init(
            fontReplacement: font,
            color: color)
    }
}

#if os(iOS)
extension FontStyle {
    public init(
        preferredFontForTextStyle fontTextStyle: UIFontTextStyle,
        color: MarklightColor? = nil) {

        self.fontReplacement = UIFont.preferredFont(forTextStyle: fontTextStyle)
        self.color = color
        self.fontTextStyle = fontTextStyle
    }

    public init(
        fontName: String,
        fontTextStyle: UIFontTextStyle,
        color: MarklightColor? = nil) {

        let textSize = UIFont.preferredFont(forTextStyle: fontTextStyle).pointSize
        self.fontReplacement = namedFont(fontName, size: textSize)
        self.color = color
        self.fontTextStyle = fontTextStyle
    }

    /// Updates the `fontReplacement`, if set, to a value
    /// with a point size matching `fontTextStyle`.
    ///
    /// Does nothing if `fontTextStyle` or `fontReplacement`
    /// are not set.
    public mutating func refreshFontSize() {

        guard let font = self.fontReplacement,
            let fontTextStyle = self.fontTextStyle
            else { return }

        let textSize = UIFont.preferredFont(forTextStyle: fontTextStyle).pointSize
        self.fontReplacement = font.withSize(textSize)
    }
}
#endif

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

/// Loads a font named `name` or falls back to the system font of the same
/// size if that fails
internal func namedFont(_ name: String, size: CGFloat) -> MarklightFont {
    if let font = MarklightFont(name: name, size: size) {
        return font
    } else {
        Swift.print("Could not load font named '\(name)'.")
        return MarklightFont.systemFont(ofSize: size)
    }
}
