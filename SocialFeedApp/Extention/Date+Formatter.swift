//
//  Date+Formatter.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation

extension DateFormatter {
    static let shortDateTime: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()
}
