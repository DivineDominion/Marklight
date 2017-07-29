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
        return FontStyle(fontAdjustment: .inherit, color: nil)
    }

    public static var emboldened: FontStyle {
        return FontStyle(fontAdjustment: .embolden)
    }

    public static var italicized: FontStyle {
        return FontStyle(fontAdjustment: .italicize)
    }
    
    public var fontAdjustment: FontAdjustment
    public var color: MarklightColor?

    #if os(iOS)
    /// Used to recompute the text size. Trumps the
    /// `fontReplacement`'s own text size if set to non-nil.
    public var fontTextStyle: UIFontTextStyle?
    #endif

    public init(
        fontAdjustment: FontAdjustment = .inherit,
        color: MarklightColor? = nil) {

        self.fontAdjustment = fontAdjustment
        self.color = color

        #if os(iOS)
        self.fontTextStyle = nil
        #endif
    }

    public init(
        fontReplacement: MarklightFont,
        color: MarklightColor? = nil) {

        self.init(
            fontAdjustment: .replace(fontReplacement),
            color: color)
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

public enum FontAdjustment {
    case inherit
    case italicize
    case embolden
    case replace(MarklightFont)
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

        self.fontAdjustment.apply(styleApplier, range: range)
    }
}

extension FontAdjustment {
    internal func apply(_ styleApplier: MarklightStyleApplier, range: NSRange) {
        switch self {
        case .inherit: return
        case .embolden: styleApplier.embolden(range: range)
        case .italicize: styleApplier.italicize(range: range)
        case .replace(let font): styleApplier.addFontAttribute(font, range: range)
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
