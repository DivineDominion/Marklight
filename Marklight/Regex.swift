//
//  Regex
//  Marklight
//
//  Created by Christian Tietze on 2017-07-21.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

internal struct Regex {
    internal let regularExpression: NSRegularExpression

    internal init(
        pattern: String,
        options: NSRegularExpression.Options = NSRegularExpression.Options(rawValue: 0)) {

        let re: NSRegularExpression

        do {
            re = try NSRegularExpression(pattern: pattern,
                                         options: options)
        } catch let error as NSError {
            // Throwing an error means NSRegularExpression didn't like
            // the pattern we gave it.  All regex patterns used by Markdown
            // should be valid.
            preconditionFailure("Regular expression error: \(error.userInfo)")
        }

        self.regularExpression = re
    }

    internal func matches(_ input: String, range: NSRange,
                             completion: @escaping (_ result: NSTextCheckingResult?) -> Void) {
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        regularExpression.enumerateMatches(in: input,
                                           options: options,
                                           range: range,
                                           using: { (result, flags, stop) -> Void in
                                            completion(result)
        })
    }
}
