//
//  MediaDetailsCollectionViewCell.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 17.11.2022.
//

import UIKit

class MediaDetailsCollectionViewCell: UICollectionViewCell {
    
    var mediaController: MediaDetailsCollectionViewController?
    weak var delegate: MediaLibraryDelegate?
    var indexPath: IndexPath?
    
    func config(photo media: Media) {
        if media.type == MediaType.photo.rawValue {
            display(photo: media, on: contentView)
        }
    }
    
    func config(video media: Media) {
        if media.type == MediaType.video.rawValue {
            display(video: media, on: contentView)
        }
    }

    
    func display(video media: Media, on view: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerVC.activeMedia = media
        playerVC.delegate = delegate
        playerVC.indexPath = indexPath
        displayMedia(on: playerVC, media: media, on: view)
    }
    
    func display(photo media: Media, on view: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoVC.activeMedia = media
        photoVC.delegate = delegate
        photoVC.indexPath = indexPath
        displayMedia(on: photoVC, media: media, on: view)
        
    }

    func displayMedia<T: UIViewController>(on vc: T, media: Media, on view: UIView) {
        mediaController?.addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = contentView.bounds
        vc.view.center = contentView.center
        vc.view.contentMode = .scaleAspectFit
        vc.didMove(toParent: mediaController)
    }
    
    
    
}
