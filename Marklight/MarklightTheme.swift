//
//  MarklightTheme.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

public protocol MarklightTheme {
    /// Style initially used for any text. Comparable to CSS selectors on 
    /// the `body` or `html` tags. Setting this affects all subsequent styles.
    var baseStyle: FontStyle { get }

    /// Style used for reference definitions.
    var referenceDefinitionStyle: FontStyle { get }

    /// Style used for block code.
    var codeBlockStyle: FontStyle { get }

    /// Style used for quotation blocks.
    var quoteStyle: FontStyle { get }

    /// Style used for inline code.
    var inlineCodeStyle: FontStyle { get }

    /// Style used for both inline and reference images.
    var imageStyle: FontStyle { get }

    /// Style used for both inline and reference links.
    var linkStyle: FontStyle { get }

    /// Style used to highlight markdown syntax.
    var syntaxStyle: FontStyle { get }
}

public struct DefaultMarklightTheme: MarklightTheme {

    public var baseStyle: FontStyle

    public var referenceDefinitionStyle: FontStyle
    public var codeBlockStyle: FontStyle
    public var quoteStyle: FontStyle

    public var inlineCodeStyle: FontStyle
    public var imageStyle: FontStyle
    public var linkStyle: FontStyle
    public var syntaxStyle: FontStyle

    /// - parameter baseStyle: Required font setting for unstyled text. Like 
    ///   `body` or `html` in a CSS style sheet. Set to `.empty` to fall back to
    ///   system default font settings. Note this will not be `NSTextView.font`
    ///   or `UITextView.font`.
    /// - parameter referenceDefinitionStyle: Decoration for link or image reference definitions.
    /// - parameter codeBlockStyle: Decoration for code blocks.
    /// - parameter quoteStyle: Decoration for blockquotes.
    /// - parameter inlineCodeStyle: Decoration for inline code.
    /// - parameter imageStyle: Decoration for inline and reference style images tags.
    /// - parameter linkStyle: Decoration for inline or reference style link tags.
    /// - parameter syntaxStyle: Decoration for Markdown syntax elements.
    public init(
        baseStyle: FontStyle,
        referenceDefinitionStyle: FontStyle = .empty,
        codeBlockStyle: FontStyle = .empty,
        quoteStyle: FontStyle = .empty,

        inlineCodeStyle: FontStyle = .empty,
        imageStyle: FontStyle = .empty,
        linkStyle: FontStyle = .empty,
        syntaxStyle: FontStyle = .empty){

        self.baseStyle = baseStyle
        self.referenceDefinitionStyle = referenceDefinitionStyle
        self.codeBlockStyle = codeBlockStyle
        self.quoteStyle = quoteStyle
        self.inlineCodeStyle = inlineCodeStyle
        self.imageStyle = imageStyle
        self.linkStyle = linkStyle
        self.syntaxStyle = syntaxStyle
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
        referenceDefinitionStyle.refreshFontSize()
        codeBlockStyle.refreshFontSize()
        quoteStyle.refreshFontSize()
        inlineCodeStyle.refreshFontSize()
        imageStyle.refreshFontSize()
        linkStyle.refreshFontSize()
        syntaxStyle.refreshFontSize()
    }
}
#endif
