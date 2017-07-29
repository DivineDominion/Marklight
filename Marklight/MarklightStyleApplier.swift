//
//  MarklightStyleApplier
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

public protocol MarklightStyleApplier {
    func addAttribute(_ name: String, value: Any, range: NSRange)
    func addAttributes(_ attrs: [String : Any], range: NSRange)
    func removeAttribute(_ name: String, range: NSRange)

    /// Resets all Marklight-relevant settings, like font, link, and color.
    /// Also resets the paragraph style.
    func resetMarklightTextAttributes(range: NSRange)

    func font(at location: Int) -> MarklightFont

    func embolden(range: NSRange)
    func italicize(range: NSRange)
}

extension MarklightStyleApplier {
    internal func addColorAttribute(_ color: MarklightColor, range: NSRange) {
        addAttribute(NSForegroundColorAttributeName, value: color, range: range)
    }

    internal func addFontAttribute(_ font: MarklightFont, range: NSRange) {
        addAttribute(NSFontAttributeName, value: font, range: range)
    }

    internal func addLinkAttribute(_ link: String, range: NSRange) {
        addAttribute(NSLinkAttributeName, value: link, range: range)
    }

    internal func addParagraphIndentation(indent: CGFloat, range: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = indent
        addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
    }

    internal func addHiddenAttributes(range: NSRange) {
        let hiddenFont = MarklightFont.systemFont(ofSize: 0.1)
        let hiddenColor = MarklightColor.clear
        let hiddenAttributes: [String : Any] = [
            NSFontAttributeName : hiddenFont,
            NSForegroundColorAttributeName : hiddenColor
        ]
        self.addAttributes(hiddenAttributes, range: range)
    }
}

/// Provide conformance to most of `MarklightStyleApplier`'s protocol.
extension NSTextStorage {
    open func embolden(range: NSRange) {

        let font = self.font(at: range.location + range.length / 2)
        self.addAttribute(NSFontAttributeName, value: font.emboldened(), range: range)
    }

    open func italicize(range: NSRange) {

        let font = self.font(at: range.location + range.length / 2)
        self.addAttribute(NSFontAttributeName, value: font.italicized(), range: range)
    }

    open func font(at location: Int) -> MarklightFont {
        return self.attribute(NSFontAttributeName, at: location, effectiveRange: nil) as? MarklightFont
            ?? MarklightFont.systemFontOfDefaultSize
    }
}
