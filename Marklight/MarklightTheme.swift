//
//  MarklightTheme.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

public protocol MarklightTheme {
    var codeFont: MarklightFont { get }
    var quoteFont: MarklightFont { get }
}

public struct DefaultMarklightTheme: MarklightTheme {

    public let codeFont: MarklightFont
    public let quoteFont: MarklightFont

    init(codeFontName: String, quoteFontName: String, textSize: CGFloat) {
        self.codeFont = namedFont(codeFontName, size: textSize)
        self.quoteFont = namedFont(quoteFontName, size: textSize)
    }
}

/// Loads a font named `name` or falls back to the system font of the same
/// size if that fails
internal func namedFont(_ name: String, size: CGFloat) -> MarklightFont {
    if let font = MarklightFont(name: name, size: size) {
        return font
    } else {
        NSLog("Could not load font named '\(name)'.")
        return MarklightFont.systemFont(ofSize: size)
    }
}
