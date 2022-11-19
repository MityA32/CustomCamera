//
//  MediaDetailsCollectionViewCell.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 17.11.2022.
//

import UIKit

class MediaDetailsCollectionViewCell: UICollectionViewCell {
    
    var mediaController: MediaDetailsCollectionViewController?
    
    func config(photo media: MediaData) {
        let imageView = UIImageView()
        if case let .photo(data) = media {
            imageView.image = UIImage(data: data)
            imageView.frame = contentView.bounds
            imageView.center = contentView.center
            imageView.contentMode = .scaleAspectFit
            contentView.addSubview(imageView)
        }
    }
    
    func config(video media: MediaData) {
        if case let .video(url) = media {
            
            display(video: url, on: contentView)
        }
    }

    
    func display(video url: URL, on view: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerVC.urlOfSelectedVideo = url
        print(mediaController)
        mediaController?.addChild(playerVC)
        view.addSubview(playerVC.view)
        playerVC.view.frame = contentView.bounds
        playerVC.view.center = contentView.center
        playerVC.view.contentMode = .scaleAspectFit
        
        playerVC.didMove(toParent: mediaController)
    }
    
    
    
}
