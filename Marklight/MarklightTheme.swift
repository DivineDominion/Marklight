//
//  MarklightTheme.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-25.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

public protocol MarklightTheme {

    /// Style used to configure the text view itself.
    var editorStyle: EditorStyle { get }

    /// Style initially used for any text. Comparable to CSS selectors on 
    /// the `body` or `html` tags. Setting this affects all subsequent styles.
    var baseStyle: BlockStyle { get }

    /// Style used for reference definitions.
    var referenceDefinitionStyle: BlockStyle { get }

    /// Style used for unordered and ordered list blocks.
    var listStyle: BlockStyle { get }

    /// Style used for block code.
    var codeBlockStyle: BlockStyle { get }

    /// Style used for quotation blocks.
    var quoteStyle: BlockStyle { get }

    /// Style used for inline code.
    var inlineCodeStyle: SpanStyle { get }

    /// Style used for both inline and reference images.
    var imageStyle: SpanStyle { get }

    /// Style used for both inline and reference links.
    var linkStyle: SpanStyle { get }

    /// Style used to highlight markdown syntax.
    var syntaxStyle: SpanStyle { get }
}

public struct DefaultMarklightTheme: MarklightTheme {

    public var editorStyle: EditorStyle

    public var baseStyle: BlockStyle

    public var referenceDefinitionStyle: BlockStyle
    public var listStyle: BlockStyle
    public var codeBlockStyle: BlockStyle
    public var quoteStyle: BlockStyle

    public var inlineCodeStyle: SpanStyle
    public var imageStyle: SpanStyle
    public var linkStyle: SpanStyle
    public var syntaxStyle: SpanStyle

    /// - parameter editorStyle: Optional style for the text view itself.
    /// - parameter baseStyle: Required font setting for unstyled text. Like 
    ///   `body` or `html` in a CSS style sheet. Set to `.empty` to fall back to
    ///   system default font settings. Note this will not be `NSTextView.font`
    ///   or `UITextView.font`.
    /// - parameter referenceDefinitionStyle: Decoration for link or image reference definitions.
    /// - parameter listStyle: Decoration for unordered or ordered list blocks.
    /// - parameter codeBlockStyle: Decoration for code blocks.
    /// - parameter quoteStyle: Decoration for blockquotes.
    /// - parameter inlineCodeStyle: Decoration for inline code.
    /// - parameter imageStyle: Decoration for inline and reference style images tags.
    /// - parameter linkStyle: Decoration for inline or reference style link tags.
    /// - parameter syntaxStyle: Decoration for Markdown syntax elements.
    public init(
        editorStyle: EditorStyle = .default,
        baseStyle: BlockStyle,
        referenceDefinitionStyle: BlockStyle = .inherit,
        listStyle: BlockStyle = .inherit,
        codeBlockStyle: BlockStyle = .inherit,
        quoteStyle: BlockStyle = .inherit,

        inlineCodeStyle: SpanStyle = .inherit,
        imageStyle: SpanStyle = .inherit,
        linkStyle: SpanStyle = .inherit,
        syntaxStyle: SpanStyle = .inherit){

        self.editorStyle = editorStyle

        self.baseStyle = baseStyle

        self.referenceDefinitionStyle = referenceDefinitionStyle
        self.listStyle = listStyle
        self.codeBlockStyle = codeBlockStyle
        self.quoteStyle = quoteStyle

        self.inlineCodeStyle = inlineCodeStyle
        self.imageStyle = imageStyle
        self.linkStyle = linkStyle
        self.syntaxStyle = syntaxStyle
    }
}


#if os(iOS)
// MARK: - Dynamic Type

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
        listStyle.refreshFontSize()
        codeBlockStyle.refreshFontSize()
        quoteStyle.refreshFontSize()

        inlineCodeStyle.refreshFontSize()
        imageStyle.refreshFontSize()
        linkStyle.refreshFontSize()
        syntaxStyle.refreshFontSize()
    }
}
#endif
