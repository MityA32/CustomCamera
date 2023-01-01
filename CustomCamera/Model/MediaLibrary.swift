//
//  MediaLibrary.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 15.11.2022.
//

import Foundation

enum MediaData: Codable, Equatable {
    case photo(URL)
    case video(URL)
}

enum MediaType: String {
    case photo
    case video
}

class MediaLibrary {

    static let shared = MediaLibrary()
    
    @Fetch<Media> var mediaRepository
    
}

extension MediaLibrary {

    
    func add(_ mediaData: MediaData) {
        CoreDataService.shared.write {
            CoreDataService.shared.create(Media.self) { media in
                if case .photo(let url) = mediaData {
                    media.mediaURL = url
                    media.type = MediaType.photo.rawValue
                } else if case .video(let url) = mediaData {
                    media.mediaURL = url
                    media.type = MediaType.video.rawValue
                }
            }
        }
    }
    
    func remove(_ media: Media) {
        CoreDataService.shared.write {
            CoreDataService.shared.delete(media)
        }
    }
}


