//
//  MediaLibraryCollectionViewCell.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 15.11.2022.
//

import UIKit
import AVFoundation

class MediaLibraryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func config(of media: MediaData) {
        imageView.clipsToBounds = true
        if case let .photo(data) = media {
            imageView.image = UIImage(data: data)
        } else if case let .video(url) = media {
            self.imageView.image = createVideoThumbnail(from: url)
            let videoIcon = UIImageView(image: UIImage(systemName: "video.fill"))
            videoIcon.tintColor = .white
            self.imageView.addSubview(videoIcon)
        }
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print("fgsjksfjk")
            print(error.localizedDescription)
            return nil
        }
    }
}
