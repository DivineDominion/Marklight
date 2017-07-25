//
//  MarklightTextProcessor
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

open class MarklightTextProcessor {

    public init() { }

    open var hideSyntax: Bool {
        get { return Marklight.hideSyntax }
        set { Marklight.hideSyntax = newValue }
    }

    open func processEditing(
        styleApplier: MarklightStyleApplier,
        string: String,
        editedRange: NSRange
        ) -> MarklightProcessingResult {

        let editedAndAdjacentParagraphRange = self.editedAndAdjacentParagraphRange(in: string, editedRange: editedRange)

        resetMarklightAttributes(
            styleApplier: styleApplier,
            range: editedAndAdjacentParagraphRange)
        Marklight.applyBlockMarkdownStyle(
            styleApplier,
            string: string)
        Marklight.applySpanMarkdownStyle(
            styleApplier,
            string: string,
            affectedRange: editedAndAdjacentParagraphRange)

        return MarklightProcessingResult(
            editedRange: editedRange,
            affectedRange: editedAndAdjacentParagraphRange)
    }

    fileprivate func editedAndAdjacentParagraphRange(in string: String, editedRange: NSRange) -> NSRange {
        let nsString = string as NSString
        let editedParagraphRange = nsString.paragraphRange(for: editedRange)

        let previousParagraphRange: NSRange
        if editedParagraphRange.location > 0 {
            previousParagraphRange = nsString.lineRange(at: editedParagraphRange.location - 1)
        } else {
            previousParagraphRange = NSRange(location: editedParagraphRange.location, length: 0)
        }

        let nextParagraphRange: NSRange
        let locationAfterEditedParagraph = editedParagraphRange.location + editedParagraphRange.length
        if locationAfterEditedParagraph < nsString.length {
            nextParagraphRange = nsString.lineRange(at: locationAfterEditedParagraph)
        } else {
            nextParagraphRange = NSRange.init(location: 0, length: 0)
        }

        return NSRange(
            location: previousParagraphRange.location,
            length: [previousParagraphRange, editedParagraphRange, nextParagraphRange].map { $0.length }.reduce(0, +))
    }

    fileprivate func resetMarklightAttributes(styleApplier: MarklightStyleApplier, range: NSRange) {

        styleApplier.resetMarklightTextAttributes(range: range)
        Marklight.theme.baseStyle.apply(styleApplier, range: range)
    }
}
