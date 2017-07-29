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

        let theme = DefaultMarklightTheme(url: Bundle.main.url(forResource: "Themes/solarized-light", withExtension: "json")!)!
        Marklight.theme = theme
        Marklight.hideSyntax = false

        textView.apply(editorStyle: theme.editorStyle)
        textView.layoutManager?.replaceTextStorage(textStorage)

        textView.textContainerInset = NSSize(width: 10, height: 8)

        if let samplePath = Bundle.main.path(forResource: "Sample", ofType: "md"),
            let string = try? String(contentsOfFile: samplePath) {
            let attributedString = NSAttributedString(string: string)
            textStorage.append(attributedString)
        }
    }
}
