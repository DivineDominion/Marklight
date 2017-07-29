//
//  UniversalTypes.swift
//  Marklight
//
//  Created by Christian Tietze on 20.07.17.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit

    public typealias MarklightColor = UIColor
    public typealias MarklightFont = UIFont
    public typealias MarklightFontDescriptor = UIFontDescriptor

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

    public typealias MarklightColor = NSColor
    public typealias MarklightFont = NSFont
    public typealias MarklightFontDescriptor = NSFontDescriptor
#endif

extension MarklightFont {

    func italicized() -> MarklightFont {
        #if os(iOS)
            return withTraits(.traitItalic)
        #elseif os(macOS)
            return NSFontManager.shared().convert(self, toHaveTrait: .italicFontMask)
        #endif
    }

    func emboldened() -> MarklightFont {
        #if os(iOS)
            return withTraits(.traitBold)
        #elseif os(macOS)
            return NSFontManager.shared().convert(self, toHaveTrait: .boldFontMask)
        #endif
    }

    static var systemFontOfDefaultSize: MarklightFont {
        #if os(iOS)
            return MarklightFont.systemFont(ofSize: MarklightFont.systemFontSize)
        #elseif os(macOS)
            return MarklightFont.systemFont(ofSize: MarklightFont.systemFontSize())
        #endif
    }
}

extension MarklightColor {
    /// Converts a hex color code to UIColor.
    /// http://stackoverflow.com/a/33397427/6669540
    ///
    /// - parameter hexString: The hex code.
    public convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32

        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
