//
//  LayoutHelpers.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-27.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

internal func widthOfCharacters(_ amount: UInt, font: MarklightFont) -> CGFloat {
    let line = (0..<amount).map { _ in "m" }.joined()
    let attributedString = NSAttributedString(
        string: line,
        attributes: [NSFontAttributeName : font])
    return attributedString.size().width
}
