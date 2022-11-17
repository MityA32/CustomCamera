//
//  MediaLibraryViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 14.11.2022.
//

import UIKit

class MediaLibraryCollectionViewController: UICollectionViewController {

    let mediaRepository = MediaLibrary.shared.mediaRepository
    
    @IBOutlet private weak var mediaRepositoryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("111")
    }

}

extension MediaLibraryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaRepository.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaLibraryCollectionViewCell
        if case .photo = mediaRepository[indexPath.row] {
            print("555")
        } else {
            
        }
        return cell
    }
    
    
}
