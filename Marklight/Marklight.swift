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
    public static var quoteIndentation : CGFloat = 20
    
    /**
     If the markdown syntax should be hidden or visible
     */
    public static var hideSyntax = false

    /**
     Text size measured in points.
     */
    #if os(iOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize  {
        didSet { Marklight.reloadFonts() }
    }
    #elseif os(macOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize() {
        didSet { Marklight.reloadFonts() }
    }
    #endif

    fileprivate static func reloadFonts() {
        Marklight.codeFont = namedFont(Marklight.codeFontName, size: Marklight.textSize)
        Marklight.quoteFont = namedFont(Marklight.quoteFontName, size: Marklight.textSize)
    }

    internal fileprivate(set) static var codeFont: MarklightFont = namedFont(Marklight.codeFontName, size: Marklight.textSize)

    internal fileprivate(set) static var quoteFont: MarklightFont = namedFont(Marklight.quoteFontName, size: Marklight.textSize)

    /// Loads a font named `name` or falls back to the system font of the same
    /// size if that fails
    internal static func namedFont(_ name: String, size: CGFloat) -> MarklightFont {
        if let font = MarklightFont(name: name, size: size) {
            return font
        } else {
            NSLog("Could not load font named '\(name)'.")
            return MarklightFont.systemFont(ofSize: size)
        }
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

        AtxHeadingStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        SetextHeadingStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)

        ReferenceDefinitionStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        BlockquoteStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        ListStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)
        CodeBlockStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, document: document)

        ReferenceLinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        InlineLinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)

        ReferenceImageStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        InlineImageStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)

        // Apply bold before italic to support nested bold/italic styles.
        BoldStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        ItalicStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)

        // Apply code last to remove bold/italic from matched text again
        CodeSpanStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)

        AutolinkStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
        AutolinkEmailStyle().apply(styleApplier, hideSyntax: Marklight.hideSyntax, paragraph: paragraph)
    }

    /// maximum nested depth of [] and () supported by the transform; 
    /// implementation detail
    fileprivate static var nestDepth: Int { return  6 }

    /// Reusable pattern to match balanced (parens). See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    ///
    /// In other words [this] and [this[also]] and [this[also[too]]]
    /// up to `nestDepth`.
    internal static let nestedBracketsPattern: String = {
        return repeatString([
            "(?>             # Atomic matching",
            "[^\\[\\]]+      # Anything other than brackets",
            "|",
            "\\["
            ].joined(separator: "\n"), nestDepth) +
            repeatString(" \\])*", nestDepth)
    }()

    /// Reusable pattern to match balanced (parens). See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    ///
    /// In other words (this) and (this(also)) and (this(also(too)))
    /// up to `nestDepth`.
    internal static let nestedParensPattern: String = {
        return repeatString([
            "(?>            # Atomic matching",
            "[^()\\s]+      # Anything other than parens or whitespace",
            "|",
            "\\("
            ].joined(separator: "\n"), nestDepth) +
            repeatString(" \\))*", nestDepth)
    }()
}

internal func repeatString(_ text: String, _ count: Int) -> String {
    return Array(repeating: text, count: count).reduce("", +)
}
