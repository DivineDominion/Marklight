//
//  ViewController.swift
//  Marklight Sample macOS
//
//  Created by Christian Tietze on 2017-07-19.
//  Copyright © 2017 MacTeo. All rights reserved.
//

import Cocoa
import Marklight

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    let textStorage = MarklightTextStorage()

    override func viewDidLoad() {
        super.viewDidLoad()

        let textSize: CGFloat = 18.0
        let theme = DefaultMarklightTheme(
            baseStyle: FontStyle(fontReplacement: NSFont.systemFont(ofSize: textSize)),
            syntaxStyle: FontStyle(color: MarklightColor.blue),
            inlineCodeStyle: FontStyle(fontName: "Courier", textSize: textSize, color: MarklightColor.orange),
            codeBlockStyle: FontStyle(fontName: "Courier", textSize: textSize, color: MarklightColor.orange),
            quoteStyle: FontStyle(fontName: "Menlo", textSize: textSize, color: MarklightColor.darkGray),
            referenceDefinitionStyle: FontStyle(color: MarklightColor.lightGray),
            imageStyle: FontStyle(fontName: "Menlo", textSize: textSize),
            linkStyle: FontStyle(fontName: "Menlo", textSize: textSize))
        Marklight.theme = theme
        Marklight.hideSyntax = false

        textView.layoutManager?.replaceTextStorage(textStorage)

        textView.textContainerInset = NSSize(width: 10, height: 8)

        if let samplePath = Bundle.main.path(forResource: "Sample", ofType: "md"),
            let string = try? String(contentsOfFile: samplePath) {
            let attributedString = NSAttributedString(string: string)
            textStorage.append(attributedString)
        }
    }
}
