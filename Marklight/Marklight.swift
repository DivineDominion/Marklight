//    Marklight
//    Copyright (c) 2016 Matteo Gavagnin
//
//    Permission is hereby granted, free of charge, to any person obtaining
//    a copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to
//    permit persons to whom the Software is furnished to do so, subject to
//    the following conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//    ------------------------------------------------------------------------------
//
//    Markdown.swift
//    Copyright (c) 2014 Kristopher Johnson
//
//    Permission is hereby granted, free of charge, to any person obtaining
//    a copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to
//    permit persons to whom the Software is furnished to do so, subject to
//    the following conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//    Markdown.swift is based on MarkdownSharp, whose licenses and history are
//    enumerated in the following sections.
//
//    ------------------------------------------------------------------------------
//
//    MarkdownSharp
//    -------------
//    a C# Markdown processor
//
//    Markdown is a text-to-HTML conversion tool for web writers
//    Copyright (c) 2004 John Gruber
//    http://daringfireball.net/projects/markdown/
//
//    Markdown.NET
//    Copyright (c) 2004-2009 Milan Negovan
//    http://www.aspnetresources.com
//    http://aspnetresources.com/blog/markdown_announced.aspx
//
//    MarkdownSharp
//    Copyright (c) 2009-2011 Jeff Atwood
//    http://stackoverflow.com
//    http://www.codinghorror.com/blog/
//    http://code.google.com/p/markdownsharp/
//
//    History: Milan ported the Markdown processor to C#. He granted license to me so I can open source it
//    and let the community contribute to and improve MarkdownSharp.
//
//    ------------------------------------------------------------------------------
//
//    Copyright (c) 2009 - 2010 Jeff Atwood
//
//    http://www.opensource.org/licenses/mit-license.php
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//    ------------------------------------------------------------------------------
//
//    Copyright (c) 2003-2004 John Gruber
//    <http://daringfireball.net/>
//    All rights reserved.
//
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are
//    met:
//
//    Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//    Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
//    Neither the name "Markdown" nor the names of its contributors may
//    be used to endorse or promote products derived from this software
//    without specific prior written permission.
//
//    This software is provided by the copyright holders and contributors "as
//    is" and any express or implied warranties, including, but not limited
//    to, the implied warranties of merchantability and fitness for a
//    particular purpose are disclaimed. In no event shall the copyright owner
//    or contributors be liable for any direct, indirect, incidental, special,
//    exemplary, or consequential damages (including, but not limited to,
//    procurement of substitute goods or services; loss of use, data, or
//    profits; or business interruption) however caused and on any theory of
//    liability, whether in contract, strict liability, or tort (including
//    negligence or otherwise) arising in any way out of the use of this
//    software, even if advised of the possibility of such damage.

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

/**
    Marklight struct that parses a `String` inside a `NSTextStorage`
 subclass, looking for markdown syntax to be highlighted. Internally many 
 regular expressions are used to detect the syntax. The highlights will be 
 applied as attributes to the `NSTextStorage`'s `NSAttributedString`. You should 
 create your our `NSTextStorage` subclass or use the readily available 
 `MarklightTextStorage` class.

 - see: `MarklightTextStorage`
*/
public struct Marklight {
    /**
    Color used to highlight markdown syntax. Default value is light grey.
     */
    public static var syntaxColor = MarklightColor.lightGray
    
    /**
    Font used for blocks and inline code. Default value is *Menlo*.
     */
    public static var codeFontName = "Menlo"
    
    /**
     Color used for blocks and inline code. Default value is dark grey.
     */
    public static var codeColor = MarklightColor.darkGray
    
    /**
    Font used for quote blocks. Default value is *Menlo*.
     */
    public static var quoteFontName = "Menlo"
    
    /**
    Color used for quote blocks. Default value is dark grey.
     */
    public static var quoteColor = MarklightColor.darkGray
    
    /**
    Quote indentation in points. Default 20.
     */
    public static var quoteIndendation : CGFloat = 20
    
    /**
     If the markdown syntax should be hidden or visible
     */
    public static var hideSyntax = false

    /**
     Text size measured in points.
     */
    #if os(iOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize
    #elseif os(macOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize()
    #endif

    // We transform the user provided `codeFontName` `String` to a `NSFont`
    internal static func codeFont(_ size: CGFloat) -> MarklightFont {
        if let font = MarklightFont(name: Marklight.codeFontName, size: size) {
            return font
        } else {
            return MarklightFont.systemFont(ofSize: size)
        }
    }

    // We transform the user provided `quoteFontName` `String` to a `NSFont`
    fileprivate static func quoteFont(_ size: CGFloat) -> MarklightFont {
        if let font = MarklightFont(name: Marklight.quoteFontName, size: size) {
            return font
        } else {
            return MarklightFont.systemFont(ofSize: size)
        }
    }
    
    // Transform the quote indentation in the `NSParagraphStyle` required to set
    //  the attribute on the `NSAttributedString`.
    fileprivate static var quoteIndendationStyle : NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = Marklight.quoteIndendation
        return paragraphStyle
    }
    
    // MARK: Processing
    
    /**
     This function should be called by the `-processEditing` method in your
     `NSTextStorage` subclass and this is the function that is being called
      for every change in the text view's text.

     - parameter styleApplier: `MarklightStyleApplier`, for example
         your `NSTextStorage` subclass.
     - parameter string: The text that should be scanned for styling.
     - parameter affectedRange: The range to apply styling to.
    */
    public static func applyMarkdownStyle(_ styleApplier: MarklightStyleApplier, string: String, affectedRange paragraphRange: NSRange) {

        let textStorageNSString = string as NSString
        let wholeRange = NSMakeRange(0, textStorageNSString.length)
        let document = Document(string: string, wholeRange: wholeRange)
        let paragraph = Paragraph(string: string, paragraphRange: paragraphRange)

        let codeFont = Marklight.codeFont(textSize)
        let quoteFont = Marklight.quoteFont(textSize)

        // We detect and process underlined headers
        Marklight.headersSetextRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.embolden(range: result.range)

            Marklight.headersSetextUnderlineRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
        }

        // We detect and process dashed headers
        Marklight.headersAtxRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.embolden(range: result.range)

            Marklight.headersAtxOpeningRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
                hideSyntaxIfNecessary(styleApplier, range: NSMakeRange(innerResult.range.location, innerResult.range.length + 1))
            }
            Marklight.headersAtxClosingRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
                hideSyntaxIfNecessary(styleApplier, range: innerResult.range)
            }
        }
        
        ReferenceDefinitionStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        ListStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        
        ReferenceLinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        InlineLinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        
        Marklight.imageRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result.range)
            
            // TODO: add image attachment
            Marklight.imageOpeningSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.imageClosingSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
            if Marklight.hideSyntax { styleApplier.addHiddenAttributes(range: result.range) }
        }
        
        // We detect and process inline images
        Marklight.imageInlineRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result.range)

            // TODO: add image attachment

            hideSyntaxIfNecessary(styleApplier, range: result.range)

            Marklight.imageOpeningSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.imageClosingSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
            Marklight.parenRegex.matches(string, range: result.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
            }
        }
        
        // We detect and process inline code
        Marklight.codeSpanRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result.range)
            
            Marklight.codeSpanOpeningRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
                hideSyntaxIfNecessary(styleApplier, range: innerResult.range)
            }
            Marklight.codeSpanClosingRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
                hideSyntaxIfNecessary(styleApplier, range: innerResult.range)
            }
        }
        
        // We detect and process code blocks
        Marklight.codeBlockRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result.range)
        }
        
        // We detect and process quotes
        Marklight.blockQuoteRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: quoteFont, range: result.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: result.range)
            styleApplier.addAttribute(NSParagraphStyleAttributeName, value: quoteIndendationStyle, range: result.range)
            Marklight.blockQuoteOpeningRegex.matches(string, range: result.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult.range)
                hideSyntaxIfNecessary(styleApplier, range: innerResult.range)
            }
        }

        // Apply bold before italic to support nested bold/italic styles.
        BoldStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        ItalicStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)

        AutolinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        AutolinkEmailStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
    }
    
    /// Tabs are automatically converted to spaces as part of the transform
    /// this constant determines how "wide" those tabs become in spaces
    fileprivate static let _tabWidth = 4
    
    // MARK: Headers

    /*
        Head
        ======
    
        Subhead
        -------
    */

    fileprivate static let headerSetextPattern = [
        "^(.+?)",
        "\\p{Z}*",
        "\\n",
        "(=+|-+)",  // $1 = string of ='s or -'s
        "\\p{Z}*",
        "\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersSetextRegex = Regex(pattern: headerSetextPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let setextUnderlinePattern = [
        "(==+|--+)     # $1 = string of ='s or -'s",
        "\\p{Z}*$"
        ].joined(separator: "\n")
    
    fileprivate static let headersSetextUnderlineRegex = Regex(pattern: setextUnderlinePattern, options: [.allowCommentsAndWhitespace])
    
    /*
        # Head
    
        ## Subhead ##
    */
    
    fileprivate static let headerAtxPattern = [
        "^(\\#{1,6})  # $1 = string of #'s",
        "\\p{Z}*",
        "(.+?)        # $2 = Header text",
        "\\p{Z}*",
        "\\#*         # optional closing #'s (not counted)",
        "\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static let headersAtxOpeningPattern = [
        "^(\\#{1,6})"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxOpeningRegex = Regex(pattern: headersAtxOpeningPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let headersAtxClosingPattern = [
        "\\#{1,6}\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxClosingRegex = Regex(pattern: headersAtxClosingPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    
    
    
    // MARK: Anchors

    internal static let openingSquareRegex = Regex(pattern: "(\\[)", options: [])
    internal static let closingSquareRegex = Regex(pattern: "\\]", options: [])
    internal static let coupleSquareRegex  = Regex(pattern: "\\[(.*?)\\]", options: [])
    internal static let coupleRoundRegex   = Regex(pattern: "\\((.*?)\\)", options: [])
    
    fileprivate static let parenPattern = [
        "(",
        "\\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])         # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joined(separator: "\n")
    
    internal static let parenRegex = Regex(pattern: parenPattern, options: [.allowCommentsAndWhitespace])
    

    
    // Mark: Images
    
    /*
        ![Title](http://example.com/image.png)
    */
    
    fileprivate static let imagePattern = [
        "(               # wrap whole match in $1",
        "!\\[",
        "    (.*?)       # alt text = $2",
        "\\]",
        "",
        "\\p{Z}?            # one optional space",
        "(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
        "",
        "\\[",
        "    (.*?)       # id = $3",
        "\\]",
        "",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let imageRegex = Regex(pattern: imagePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let imageOpeningSquarePattern = [
        "(!\\[)"
        ].joined(separator: "\n")
    
    fileprivate static let imageOpeningSquareRegex = Regex(pattern: imageOpeningSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let imageClosingSquarePattern = [
        "(\\])"
        ].joined(separator: "\n")
    
    fileprivate static let imageClosingSquareRegex = Regex(pattern: imageClosingSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let imageInlinePattern = [
        "(                     # wrap whole match in $1",
        "  !\\[",
        "      (.*?)           # alt text = $2",
        "  \\]",
        "  \\s?                # one optional whitespace character",
        "  \\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])       # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    // MARK: Code
    
    /*
        ```
        Code
        ```
    
            Code
    */
    
    fileprivate static let codeBlockPattern = [
        "(?:\\n\\n|\\A\\n?)",
        "(                        # $1 = the code block -- one or more lines, starting with a space",
        "(?:",
        "    (?:\\p{Z}{\(_tabWidth)})       # Lines must start with a tab-width of spaces",
        "    .*\\n+",
        ")+",
        ")",
        "((?=^\\p{Z}{0,\(_tabWidth)}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
        ].joined(separator: "\n")
    
    fileprivate static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let codeSpanPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `",
        "(?!`)          # and no more backticks -- match the full run",
        "(.+?)          # $2 = The code block",
        "(?<!`)",
        "\\1",
        "(?!`)"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanRegex = Regex(pattern: codeSpanPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let codeSpanOpeningPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanOpeningRegex = Regex(pattern: codeSpanOpeningPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let codeSpanClosingPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanClosingRegex = Regex(pattern: codeSpanClosingPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    // MARK: Block quotes
    
    /*
        > Quoted text
    */
    
    fileprivate static let blockQuotePattern = [
        "(                           # Wrap whole match in $1",
        "    (",
        "    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
        "        .+\\n               # rest of the first line",
        "    (.+\\n)*                # subsequent consecutive lines",
        "    \\n*                    # blanks",
        "    )+",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let blockQuoteRegex = Regex(pattern: blockQuotePattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static let blockQuoteOpeningPattern = [
        "(^\\p{Z}*>\\p{Z})"
        ].joined(separator: "\n")

    fileprivate static let blockQuoteOpeningRegex = Regex(pattern: blockQuoteOpeningPattern, options: [.anchorsMatchLines])

    /// maximum nested depth of [] and () supported by the transform; 
    /// implementation detail
    fileprivate static let _nestDepth = 6
    
    fileprivate static var _nestedBracketsPattern = ""
    fileprivate static var _nestedParensPattern = ""
    
    /// Reusable pattern to match balanced [brackets]. See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    internal static func getNestedBracketsPattern() -> String {
        // in other words [this] and [this[also]] and [this[also[too]]]
        // up to _nestDepth
        if (_nestedBracketsPattern.isEmpty) {
            _nestedBracketsPattern = repeatString([
                "(?>             # Atomic matching",
                "[^\\[\\]]+      # Anything other than brackets",
                "|",
                "\\["
                ].joined(separator: "\n"), _nestDepth) +
                repeatString(" \\])*", _nestDepth)
        }
        return _nestedBracketsPattern
    }
    
    /// Reusable pattern to match balanced (parens). See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    internal static func getNestedParensPattern() -> String {
        // in other words (this) and (this(also)) and (this(also(too)))
        // up to _nestDepth
        if (_nestedParensPattern.isEmpty) {
            _nestedParensPattern = repeatString([
                "(?>            # Atomic matching",
                "[^()\\s]+      # Anything other than parens or whitespace",
                "|",
                "\\("
                ].joined(separator: "\n"), _nestDepth) +
                repeatString(" \\))*", _nestDepth)
        }
        return _nestedParensPattern
    }

    /// this is to emulate what's available in PHP
    fileprivate static func repeatString(_ text: String, _ count: Int) -> String {
        return Array(repeating: text, count: count).reduce("", +)
    }

}

func hideSyntaxIfNecessary(
    _ styleApplier: MarklightStyleApplier,
    range: @autoclosure () -> NSRange) {
    guard Marklight.hideSyntax else { return }
    styleApplier.addHiddenAttributes(range: range())
}
