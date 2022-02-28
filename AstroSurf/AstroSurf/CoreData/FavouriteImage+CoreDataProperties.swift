//
//  FavouriteImage+CoreDataProperties.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//
//

import Foundation
import CoreData


extension FavouriteImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteImage> {
        return NSFetchRequest<FavouriteImage>(entityName: "FavouriteImage")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var publishedDate: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var mediaUrl: String?
    @NSManaged public var media_type: String?

    public var mediaType: MediaType {
        (media_type == "image") ? .image : .video
    }
}

extension FavouriteImage : Identifiable {

}
