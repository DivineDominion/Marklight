//
//  EditorStyle.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-29.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

public struct EditorStyle {
    public static var `default`: EditorStyle { return EditorStyle() }

    public var backgroundColor: MarklightColor?
    public var caretColor: MarklightColor?

    public init(
        backgroundColor: MarklightColor? = nil,
        caretColor: MarklightColor? = nil) {

        self.backgroundColor = backgroundColor
        self.caretColor = caretColor
    }
}

#if os(iOS)
    import UIKit
    extension UITextView {
        public func apply(editorStyle: EditorStyle) {
            if let backgroundColor = editorStyle.backgroundColor {
                self.backgroundColor = backgroundColor
            }

            if let caretColor = editorStyle.caretColor {
                self.tintColor = caretColor
            }
        }
    }
#elseif os(macOS)
    import AppKit
    extension NSTextView {
        public func apply(editorStyle: EditorStyle) {
            if let backgroundColor = editorStyle.backgroundColor {
                self.backgroundColor = backgroundColor
            }

            if let caretColor = editorStyle.caretColor {
                self.insertionPointColor = caretColor
            }
        }
    }
#endif
