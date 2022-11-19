//
//  MediaLibraryViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 14.11.2022.
//

import UIKit

class MediaLibraryCollectionViewController: UICollectionViewController {

    let mediaRepository = MediaLibrary.shared.mediaRepository
    
    var columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 3,
        minimumLineSpacing: 3,
        sectionInset: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = columnLayout
        print(mediaRepository)
    }

}

extension MediaLibraryCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaRepository.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaDataCell", for: indexPath) as! MediaLibraryCollectionViewCell
        cell.config(of: mediaRepository[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(mediaRepository[indexPath.row])
        performSegue(withIdentifier: "show_media_details", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "show_media_details"),
           let destination = segue.destination as? MediaDetailsCollectionViewController,
           let mediaDataIndex = self.collectionView.indexPathsForSelectedItems?.first {
            destination.indexOfInitialMediaData = mediaDataIndex
        }
    }
    
    
}
