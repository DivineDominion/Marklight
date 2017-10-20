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
    func addAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange)
    func addAttributes(_ attrs: [NSAttributedStringKey : Any], range: NSRange)
    func removeAttribute(_ name: NSAttributedStringKey, range: NSRange)
    func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange)

    func embolden(range: NSRange)
    func italicize(range: NSRange)
}

extension MarklightStyleApplier {
    internal func addColorAttribute(_ color: MarklightColor, range: NSRange) {
        addAttribute(.foregroundColor, value: color, range: range)
    }

    internal func addFontAttribute(_ font: MarklightFont, range: NSRange) {
        addAttribute(.font, value: font, range: range)
    }

    internal func addLinkAttribute(_ link: String, range: NSRange) {
        addAttribute(.link, value: link, range: range)
    }

    internal func addParagraphIndentation(indent: CGFloat, range: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = indent
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }

    internal func addHiddenAttributes(range: NSRange) {
        let hiddenFont = MarklightFont.systemFont(ofSize: 0.1)
        let hiddenColor = MarklightColor.clear
        let hiddenAttributes: [NSAttributedStringKey : Any] = [
            .font : hiddenFont,
            .foregroundColor : hiddenColor
        ]
        self.addAttributes(hiddenAttributes, range: range)
    }
}

extension NSTextStorage: MarklightStyleApplier {
    @objc public func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange) {
        self.removeAttribute(.foregroundColor, range: range)
        self.addAttribute(.font, value: MarklightFont.systemFont(ofSize: textSize), range: range)
        self.addAttribute(.paragraphStyle, value: NSParagraphStyle(), range: range)
    }

    public func embolden(range: NSRange) {

        guard let font = self.attribute(.font, at: range.location, effectiveRange: nil) as? MarklightFont
            else { assertionFailure(); return }

        self.addAttribute(.font, value: font.emboldened(), range: range)
    }

    public func italicize(range: NSRange) {

        guard let font = self.attribute(.font, at: range.location, effectiveRange: nil) as? MarklightFont
            else { assertionFailure(); return }

        self.addAttribute(.font, value: font.italicized(), range: range)
    }
}
