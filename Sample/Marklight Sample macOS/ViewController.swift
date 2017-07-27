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
            baseStyle: BlockStyle(fontStyle: FontStyle(fontReplacement: NSFont.systemFont(ofSize: textSize))),
            referenceDefinitionStyle: BlockStyle(fontStyle: FontStyle(color: MarklightColor.lightGray)),
            listStyle: BlockStyle(indentation: .points(13)),
            codeBlockStyle: BlockStyle(fontStyle: FontStyle(fontName: "Courier", textSize: textSize, color: MarklightColor.orange)),
            quoteStyle: BlockStyle(fontStyle: FontStyle(fontName: "Menlo", textSize: textSize, color: MarklightColor.darkGray), indentation: .characters(2)),
            inlineCodeStyle: SpanStyle(fontStyle: FontStyle(fontName: "Courier", textSize: textSize, color: MarklightColor.orange)),
            imageStyle: SpanStyle(fontStyle: FontStyle(fontName: "Menlo", textSize: textSize)),
            linkStyle: SpanStyle(fontStyle: FontStyle(fontName: "Menlo", textSize: textSize)),
            syntaxStyle: SpanStyle(fontStyle: FontStyle(color: MarklightColor.blue)))
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
