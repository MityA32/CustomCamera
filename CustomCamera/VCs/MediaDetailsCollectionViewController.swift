//
//  MediaDetailsCollectionViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 17.11.2022.
//

import UIKit

class MediaDetailsCollectionViewController: UICollectionViewController {

    let modelOf = MediaLibrary.shared
    var indexOfInitialMediaData: IndexPath?
    weak var delegate: MediaLibraryDelegate?
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    private let reuseIdentifier = "MediaDetailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc
    func back(_ sender: UIBarButtonItem) {
        delegate?.reloadMediaLibrary()
        navigationController?.popViewController(animated: true)
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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
}

extension MediaDetailsCollectionViewController {
    
    func createCompositonalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            if self.modelOf.mediaRepository != [] {
                let mediaData = self.modelOf.mediaRepository[sectionIndex]
                
                switch mediaData.self {
                default:
                    return self.createMediaDataSection(using: mediaData)
                }
            }
//            guard let placeholder = UIImage(systemName: "camera.macro")?.pngData() else { return nil }
//            return self.createMediaDataSection(using: .photo(placeholder))
            return nil
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
        return modelOf.mediaRepository.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaDetailsCollectionViewCell
        cell.mediaController = self
        cell.delegate = self
        cell.indexPath = indexPath
        let media = modelOf.mediaRepository[indexPath.row]
        if case .photo(_) = media {
            cell.config(photo: media)
        } else if case .video(_) = media {
            cell.config(video: media)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tut nado shob bylo")
    }
    
}

extension MediaDetailsCollectionViewController: MediaLibraryDelegate {
    func delete(_ media: MediaData, of indexPath: IndexPath) {
        
        delegate?.delete(media, of: indexPath)
        
        DispatchQueue.main.async { [collectionView, modelOf, navigationController] in
            collectionView?.deleteItems(at: [indexPath])
            if indexPath.row == modelOf.mediaRepository.count {
                if modelOf.mediaRepository.isEmpty {
                    navigationController?.popViewController(animated: true)
                }
                let currentIndexPath = IndexPath(item: indexPath.row - 1, section: indexPath.section)
                collectionView?.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}




