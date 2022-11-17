//
//  MediaLibrary.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 15.11.2022.
//

import Foundation

enum MediaData: Codable, Equatable {
    case photo(Data)
    case video(URL)
}

class MediaLibrary {

    static let shared = MediaLibrary()
    
    private(set) var mediaRepository: [MediaData]
    let mediaKey = "mediaData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: mediaKey) {
            if let decodedData = try? JSONDecoder().decode([MediaData].self, from: data) {
                mediaRepository = decodedData
                return
            }
        }
        
        //if no saved data
        mediaRepository = []
    }
    
}

extension MediaLibrary {
    private func save() {
        if let encodedData = try? JSONEncoder().encode(mediaRepository) {
            UserDefaults.standard.set(encodedData, forKey: mediaKey)
        }
    }
    
    func add(_ mediaData: MediaData) {
        mediaRepository.append(mediaData)
        save()
    }
}


