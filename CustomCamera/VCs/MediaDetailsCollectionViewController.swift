//
//  MediaDetailsCollectionViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 17.11.2022.
//

import UIKit



class MediaDetailsCollectionViewController: UICollectionViewController {

    let mediaRepository = MediaLibrary.shared.mediaRepository
    var indexOfInitialMediaData: IndexPath?
    
    private let reuseIdentifier = "MediaDetailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositonalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(MediaDetailsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.gestureRecognizers = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = indexOfInitialMediaData else { return }
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        
    }
    
    
    
}

extension MediaDetailsCollectionViewController {
    func createCompositonalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            let mediaData = self.mediaRepository[sectionIndex]
            
            switch mediaData.self {
            default:
                return self.createMediaDataSection(using: mediaData)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
        
    }
    
    func createMediaDataSection(using section: MediaData) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(view.bounds.height*0.85))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
    
        return layoutSection
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaRepository.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaDetailsCollectionViewCell
        let media = mediaRepository[indexPath.row]
        if case .photo(_) = media {
            cell.config(photo: media)
        } else if case .video(_) = media {
            cell.mediaController = self
            cell.config(video: media)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //For entire screen size
//        let screenSize = UIScreen.main.bounds.size
//        return screenSize
        //If you want to fit the size with the size of ViewController use bellow
        let viewControllerSize = self.view.frame.size
        return viewControllerSize

        // Even you can set the cell to uicollectionview size
//        let cvRect = collectionView.frame
//        return CGSize(width: cvRect.width, height: cvRect.height)


    }

}
