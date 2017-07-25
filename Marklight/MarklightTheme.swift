//
//  MarklightTheme.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

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

    public var baseStyle: FontStyle
    public var syntaxStyle: FontStyle
    public var codeStyle: FontStyle
    public var quoteStyle: FontStyle
    public var referenceDefinitionStyle: FontStyle
    public var imageStyle: FontStyle
    public var linkStyle: FontStyle

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

#if os(iOS)
/// Optional `MarkdownTheme` trait that will be picked up by
/// `MarklightTextStorage` to update font sizes on dynamic text
/// setting changes. 
/// 
/// If you do not use `MarklightTextStorage`, there's no need to adopt this
/// in your themes.
public protocol DynamicMarklightTheme: MarklightTheme {
    mutating func refreshFontSizes()
}

extension DefaultMarklightTheme: DynamicMarklightTheme {
    public mutating func refreshFontSizes() {
        baseStyle.refreshFontSize()
        syntaxStyle.refreshFontSize()
        codeStyle.refreshFontSize()
        quoteStyle.refreshFontSize()
        referenceDefinitionStyle.refreshFontSize()
        imageStyle.refreshFontSize()
        linkStyle.refreshFontSize()
    }
}
#endif
