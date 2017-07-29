//
//  DefaultMarklightTheme+JSON.swift
//  Marklight
//
//  Created by Christian Tietze on 2017-07-29.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

public typealias JSON = [String: Any]

extension DefaultMarklightTheme {
    public init?(url: URL) {

        guard let jsonData = try? Data(contentsOf: url),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let json = jsonObject as? [String: Any]
            else { return nil }

        self.init(json: json)
    }

    public init(json: JSON) {
        self.init(
            editorStyleJSON: json["editor"] as? JSON ?? [:],
            markdownStyleJSON: json["styles"] as? JSON ?? [:])
    }

    public init(editorStyleJSON: JSON, markdownStyleJSON: JSON) {

        let editorStyle = EditorStyle(json: editorStyleJSON)

        let baseStyle = BlockStyle(json: markdownStyleJSON["base"] as? JSON ?? [:])
        let referenceDefinitionStyle = BlockStyle(json: markdownStyleJSON["referenceDefinition"] as? JSON ?? [:])
        let listStyle = BlockStyle(json: markdownStyleJSON["list"] as? JSON ?? [:])
        let codeBlockStyle = BlockStyle(json: markdownStyleJSON["codeBlock"] as? JSON ?? [:])
        let quoteStyle = BlockStyle(json: markdownStyleJSON["blockquote"] as? JSON ?? [:])

        let emphasisStyle = SpanStyle(json: markdownStyleJSON["emphasis"] as? JSON ?? [:])
        let strongEmphasisStyle = SpanStyle(json: markdownStyleJSON["strong"] as? JSON ?? [:])
        let inlineCodeStyle = SpanStyle(json: markdownStyleJSON["inlineCode"] as? JSON ?? [:])
        let imageStyle = SpanStyle(json: markdownStyleJSON["image"] as? JSON ?? [:])
        let linkStyle = SpanStyle(json: markdownStyleJSON["link"] as? JSON ?? [:])
        let syntaxStyle = SpanStyle(json: markdownStyleJSON["syntax"] as? JSON ?? [:])

        self.init(
            editorStyle: editorStyle,

            baseStyle: baseStyle,
            referenceDefinitionStyle: referenceDefinitionStyle,
            listStyle: listStyle,
            codeBlockStyle: codeBlockStyle,
            quoteStyle: quoteStyle,

            emphasisStyle: emphasisStyle,
            strongEmphasisStyle: strongEmphasisStyle,
            inlineCodeStyle: inlineCodeStyle,
            imageStyle: imageStyle,
            linkStyle: linkStyle,
            syntaxStyle: syntaxStyle)
    }
}

extension EditorStyle {
    public init(json: JSON) {
        let backgroundColor = MarklightColor(hexString: json["backgroundColor"] as? String ?? "")
        let caretColor = MarklightColor(hexString: json["caretColor"] as? String ?? "")
        self.init(backgroundColor: backgroundColor, caretColor: caretColor)
    }
}

extension BlockStyle {
    public init(json: JSON) {
        self.init(
            fontStyle: FontStyle(json: json) ?? .inherit,
            indentation: BlockIndentation(json: json) ?? .inherit)
    }
}

extension FontStyle {
    public init?(json: JSON) {
        let fontAdjustment = FontAdjustment(json: json["font"] as? JSON ?? [:])
        let color = MarklightColor(hexString: json["color"] as? String ?? "")
        self.init(
            fontAdjustment: fontAdjustment,
            color: color)
    }
}

extension FontAdjustment {
    /// Example for bold font settings:
    ///
    ///     {font: {name: "Menlo-Bold", size: 20}}
    ///
    /// Or:
    ///
    ///     {font: {style: "bold"}
    public init(json: JSON) {
        if let font = MarklightFont(json: json) {
            self = .replace(font)
            return
        }

        switch json["style"] as? String {
        case .some("italic"): self = .italicize
        case .some("bold"): self = .embolden
        default: self = .inherit
        }
    }
}

extension MarklightFont {
    public convenience init?(json: JSON) {
        guard let name = json["name"] as? String else { return nil }
        guard let size = json["size"] as? CGFloat else { return nil }
        self.init(name: name, size: size)
    }
}

extension BlockIndentation {
    public init?(json: JSON) {
        guard let indentation = json["indent"] else { return nil }

        switch indentation {
        case let string as String
            where string == "none":
            self = .none

        case let string as String
            where string == "inherit":
            self = .inherit

        case let json as JSON:
            if let points = json["points"] as? CGFloat {
                self = .points(points)
            } else if let characters = json["characters"] as? UInt {
                self = .characters(characters)
            } else {
                return nil
            }

        default:
            return nil
        }
    }
}

extension SpanStyle {
    public init(json: JSON) {
        self.init(fontStyle: FontStyle(json: json) ?? .inherit)
    }
}
