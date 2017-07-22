//
//  Regex
//  Marklight
//
//  Created by Christian Tietze on 2017-07-21.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

internal struct Regex {
    internal let regularExpression: NSRegularExpression!

    internal init(
        pattern: String,
        options: NSRegularExpression.Options = NSRegularExpression.Options(rawValue: 0)) {

        var error: NSError?
        let re: NSRegularExpression?
        do {
            re = try NSRegularExpression(pattern: pattern,
                                         options: options)
        } catch let error1 as NSError {
            error = error1
            re = nil
        }

        // If re is nil, it means NSRegularExpression didn't like
        // the pattern we gave it.  All regex patterns used by Markdown
        // should be valid, so this probably means that a pattern
        // valid for .NET Regex is not valid for NSRegularExpression.
        if re == nil {
            if let error = error {
                print("Regular expression error: \(error.userInfo)")
            }
            assert(re != nil)
        }

        self.regularExpression = re
    }

    internal func matches(_ input: String, range: NSRange,
                             completion: @escaping (_ result: NSTextCheckingResult?) -> Void) {
        let s = input as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        regularExpression.enumerateMatches(in: s as String,
                                           options: options,
                                           range: range,
                                           using: { (result, flags, stop) -> Void in
                                            completion(result)
        })
    }
}
