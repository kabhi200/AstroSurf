//
//  AstronomerPhotoModel.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import Foundation

public struct AstronomerPhotoVideoModel: Decodable {

    // MARK: - Properties

    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let service_version: String
    let title: String
    let url: String
    let copyright: String?

    public var mediaType: MediaType {
        (media_type == "image") ? .image : .video
    }
}

public enum MediaType: String {
    case image
    case video
}

public class AstronomerPhotoVideoCacheModel {
    
    let date: String
    let description: String
    let imageData: Data?
    let title: String
    let mediaUrl: String
    let mediaType: MediaType

    public init(publishedDate: String, photoDescription: String, imageData: Data?, photoTitle: String, mediaUrl: String, mediaType: MediaType) {
        self.date = publishedDate
        self.description = photoDescription
        self.imageData = imageData
        self.title = photoTitle
        self.mediaUrl = mediaUrl
        self.mediaType = mediaType
    }
}
