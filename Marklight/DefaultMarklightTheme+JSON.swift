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

        self.init(json: json["styles"] as? JSON ?? [:])
    }

    public init(json: JSON) {

        let baseStyle = BlockStyle(json: json["base"] as? JSON ?? [:])
        let referenceDefinitionStyle = BlockStyle(json: json["referenceDefinition"] as? JSON ?? [:])
        let listStyle = BlockStyle(json: json["list"] as? JSON ?? [:])
        let codeBlockStyle = BlockStyle(json: json["codeBlock"] as? JSON ?? [:])
        let quoteStyle = BlockStyle(json: json["blockquote"] as? JSON ?? [:])

        let inlineCodeStyle = SpanStyle(json: json["inlineCode"] as? JSON ?? [:])
        let imageStyle = SpanStyle(json: json["image"] as? JSON ?? [:])
        let linkStyle = SpanStyle(json: json["link"] as? JSON ?? [:])
        let syntaxStyle = SpanStyle(json: json["syntax"] as? JSON ?? [:])

        self.init(
            baseStyle: baseStyle,
            referenceDefinitionStyle: referenceDefinitionStyle,
            listStyle: listStyle,
            codeBlockStyle: codeBlockStyle,
            quoteStyle: quoteStyle,

            inlineCodeStyle: inlineCodeStyle,
            imageStyle: imageStyle,
            linkStyle: linkStyle,
            syntaxStyle: syntaxStyle)
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
        let font = MarklightFont(json: json["font"] as? JSON ?? [:])
        let color = MarklightColor(hexString: json["color"] as? String ?? "")
        self.init(
            fontReplacement: font,
            color: color)
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
