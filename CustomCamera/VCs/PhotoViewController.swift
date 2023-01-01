//
//  PhotoViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 19.11.2022.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {

    var activeMedia: Media?
    weak var mediaController: MediaDetailsCollectionViewController?
    weak var delegate: MediaLibraryDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet private weak var photoView: UIView!
    
    @IBAction func savePhotoToPhotos(_ sender: Any) {
        savePhotoWithAlert()
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        
        if let activeMedia, let indexPath {
            delegate?.delete(activeMedia, of: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let photoData = try? Data(contentsOf: activeMedia?.mediaURL ?? URL(filePath: "")) else { return }
        config(of: photoData)

    }
    
    func config(of data: Data) {
        photoView.clipsToBounds = true
        let imageView = UIImageView()
        imageView.image = UIImage(data: data)
        imageView.frame = photoView.bounds
        imageView.center = photoView.center
        photoView.addSubview(imageView)
        
    }
    
    func savePhotoWithAlert() {
        let saveAlert = UIAlertController(title: "Alert", message: "Photo is saved", preferredStyle: UIAlertController.Style.alert)
        saveAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            try? PHPhotoLibrary.shared().performChangesAndWait {
                if let data = try? Data(contentsOf: self?.activeMedia?.mediaURL ?? URL(filePath: "")) {
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
                }
            }
        }))
        present(saveAlert, animated: true, completion: nil)
    }

}


