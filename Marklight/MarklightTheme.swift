//
//  MarklightTheme.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import struct Foundation.CGFloat

public protocol MarklightTheme {
    /// Style initially used for any text.
    var baseStyle: FontStyle { get }

    /// Style used to highlight markdown syntax.
    var syntaxStyle: FontStyle { get }

    /// Style used for code blocks and inline code.
    var codeStyle: FontStyle { get }

    /// Style used for quotation blocks.
    var quoteStyle: FontStyle { get }

    /// Style used for reference definitions.
    var referenceDefinitionStyle: FontStyle { get }

    /// Style used for both inline and reference images.
    var imageStyle: FontStyle { get }

    /// Style used for both inline and reference links.
    var linkStyle: FontStyle { get }
}

public struct DefaultMarklightTheme: MarklightTheme {

    public let baseStyle: FontStyle
    public let syntaxStyle: FontStyle
    public let codeStyle: FontStyle
    public let quoteStyle: FontStyle
    public let referenceDefinitionStyle: FontStyle
    public let imageStyle: FontStyle
    public let linkStyle: FontStyle

    public init(
        baseStyle: FontStyle = .empty,
        syntaxStyle: FontStyle = .empty,
        codeStyle: FontStyle = .empty,
        quoteStyle: FontStyle = .empty,
        referenceDefinitionStyle: FontStyle = .empty,
        imageStyle: FontStyle = .empty,
        linkStyle: FontStyle = .empty) {

        self.baseStyle = baseStyle
        self.syntaxStyle = syntaxStyle
        self.codeStyle = codeStyle
        self.quoteStyle = quoteStyle
        self.referenceDefinitionStyle = referenceDefinitionStyle
        self.imageStyle = imageStyle
        self.linkStyle = linkStyle
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
