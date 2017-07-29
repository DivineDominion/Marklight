//
//  BlockStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-27.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

public struct BlockStyle {
    public static var inherit: BlockStyle {
        return BlockStyle(fontStyle: .inherit, indentation: .inherit)
    }
    
    /// Override for the base font style, applying to the
    /// whole block.
    public var fontStyle: FontStyle

    /// Indentation of the block's paragraph lines, exluding the first.
    public var indentation: BlockIndentation

    /// - parameter fontStyle: Font override for the whole block. Defaults to `.empty.`
    /// - parameter indentation: Indentation of all but the first line of text.
    public init(
        fontStyle: FontStyle = .inherit,
        indentation: BlockIndentation = .inherit
        ){
        self.fontStyle = fontStyle
        self.indentation = indentation
    }
}

extension BlockStyle {
    internal func apply(_ styleApplier: MarklightStyleApplier, range: NSRange) {
        fontStyle.apply(styleApplier, range: range)
        indentation.apply(styleApplier, range: range)
    }
}

/// Indentation of a recognized block of text, excluding markup syntax.
/// So this will not affect the list item marker (e.g. `*`) 
/// or blockquote marker (`>`), but the remaining text
public enum BlockIndentation {
    /// Keeps already applied settings to the block.
    case inherit

    /// Overrides previous settings with zero indentation.
    case none

    case points(CGFloat)
    case characters(UInt)
}

extension BlockIndentation {
    internal func apply(_ styleApplier: MarklightStyleApplier, range: NSRange) {
        switch self {
        case .inherit:
            break

        case .none:
            styleApplier.addParagraphIndentation(
                indent: 0,
                range: range)

        case .points(let indent):
            styleApplier.addParagraphIndentation(
                indent: indent,
                range: range)

        case .characters(let amount):
            let font = styleApplier.font(at: range.location)
            let indent = widthOfCharacters(amount, font: font)
            styleApplier.addParagraphIndentation(
                indent: indent,
                range: range)
        }
    }
}

#if os(iOS)
// MARK: - Dynamic Type

extension BlockStyle {
    public mutating func refreshFontSize() {
        self.fontStyle.refreshFontSize()
    }
}
#endif
