//
//  MediaDetailsCollectionViewCell.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 17.11.2022.
//

import UIKit

class MediaDetailsCollectionViewCell: UICollectionViewCell {
    
    var mediaController: MediaDetailsCollectionViewController?
    weak var delegate: DeleteDataDelegate?
    var indexPath: IndexPath?
    
    func config(photo media: MediaData) {
        if case let .photo(data) = media {
            display(photo: data, on: contentView)
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
        playerVC.delegate = delegate
        playerVC.indexPath = indexPath
        mediaController?.addChild(playerVC)
        view.addSubview(playerVC.view)
        playerVC.view.frame = contentView.bounds
        playerVC.view.center = contentView.center
        playerVC.view.contentMode = .scaleAspectFit
        playerVC.didMove(toParent: mediaController)
    }
    
    func display(photo media: Data, on view: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoVC.photoData = media
        photoVC.delegate = delegate
        photoVC.indexPath = indexPath
        mediaController?.addChild(photoVC)
        view.addSubview(photoVC.view)
        photoVC.view.frame = contentView.bounds
        photoVC.view.center = contentView.center
        photoVC.view.contentMode = .scaleAspectFit
        photoVC.didMove(toParent: mediaController)
    }

    
    
    
}
