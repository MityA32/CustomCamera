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
    
    func config(of media: Media) {
        imageView.clipsToBounds = true
        if media.type == MediaType.photo.rawValue {
            if let dataFromURL = try? Data(contentsOf: media.mediaURL ?? URL(filePath: "")) {
                imageView.image = UIImage(data: dataFromURL)
            }
        } else if media.type == MediaType.video.rawValue {
            self.imageView.image = createVideoThumbnail(from: media.mediaURL ?? URL(filePath: ""))
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
        // why it catches
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return UIImage(systemName: "apple.logo")
        }
    }
}
