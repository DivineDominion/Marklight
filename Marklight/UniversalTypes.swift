//
//  UniversalTypes.swift
//  Marklight
//
//  Created by Christian Tietze on 20.07.17.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit

    typealias MarklightColor = UIColor
    typealias MarklightFont = UIFont
    typealias MarklightFontDescriptor = UIFontDescriptor

    extension UIFont {
        fileprivate func withTraits(_ traits: UIFontDescriptorSymbolicTraits) -> UIFont {

            guard let fontDescriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
                assertionFailure("Could not apply traits: \(traits)")
                return self
            }

            return UIFont(descriptor: fontDescriptor, size: pointSize)
        }
    }

#elseif os(macOS)
    import AppKit


    typealias MarklightColor = NSColor
    typealias MarklightFont = NSFont
    typealias MarklightFontDescriptor = NSFontDescriptor

#endif

extension MarklightFont {

    func italicized() -> MarklightFont {
        #if os(iOS)
            return withTraits(.traitItalic)
        #elseif os(macOS)
            return NSFontManager().convert(self, toHaveTrait: .italicFontMask)
        #endif
    }

    func emboldened() -> MarklightFont {
        #if os(iOS)
            return withTraits(.traitBold)
        #elseif os(macOS)
            return NSFontManager().convert(self, toHaveTrait: .boldFontMask)
        #endif
    }
}
