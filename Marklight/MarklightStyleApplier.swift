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
    func resetMarklightTextAttributes(range: NSRange)

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

extension NSTextStorage: MarklightStyleApplier {
    public func resetMarklightTextAttributes(range: NSRange) {
        self.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.addAttribute(NSParagraphStyleAttributeName, value: NSParagraphStyle(), range: range)
    }

    public func embolden(range: NSRange) {

        guard let font = self.attribute(NSFontAttributeName, at: range.location, effectiveRange: nil) as? MarklightFont
            else { assertionFailure(); return }

        self.addAttribute(NSFontAttributeName, value: font.emboldened(), range: range)
    }

    public func italicize(range: NSRange) {

        guard let font = self.attribute(NSFontAttributeName, at: range.location, effectiveRange: nil) as? MarklightFont
            else { assertionFailure(); return }

        self.addAttribute(NSFontAttributeName, value: font.italicized(), range: range)
    }
}
