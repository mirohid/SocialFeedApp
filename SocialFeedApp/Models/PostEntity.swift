//
//  PostEntity.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//


import Foundation
import CoreData
import UIKit

@objc(PostEntity)
class PostEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var imageData: Data?
    @NSManaged var descText: String?
    @NSManaged var locationText: String?
    @NSManaged var timestamp: Date?
    @NSManaged var isLiked: Bool
    @NSManaged var commentsData: Data?
}

extension PostEntity {
    var comments: [String] {
        get {
            guard let data = commentsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            commentsData = try? JSONEncoder().encode(newValue)
        }
    }

    var uiImage: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

// Make PostEntity Identifiable for use in SwiftUI list/sheets
extension PostEntity: Identifiable { }
