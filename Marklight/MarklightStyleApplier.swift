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
    func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange)

    func embolden(range: NSRange)
    func italicize(range: NSRange)
}

extension NSTextStorage: MarklightStyleApplier {
    public func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange) {
        self.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.addAttribute(NSFontAttributeName, value: MarklightFont.systemFont(ofSize: textSize), range: range)
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
