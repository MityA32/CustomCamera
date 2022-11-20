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
    weak var delegate: UpdateMediaLibrary?
    
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
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        
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
            guard let placeholder = UIImage(systemName: "camera.macro")?.pngData() else { return nil }
            return self.createMediaDataSection(using: .photo(placeholder))
            
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
        if modelOf.mediaRepository.isEmpty {
            self.navigationController?.popViewController(animated: true)
            
        }
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
    
}

extension MediaDetailsCollectionViewController: DeleteDataDelegate {
    func delete(_ media: MediaData, of indexPath: IndexPath) {
        MediaLibrary.shared.remove(media)
        
        DispatchQueue.main.async {
            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadData()
        }
        
        
        
    }
    
}

protocol UpdateMediaLibrary: AnyObject {
    func reloadMediaLibrary()
}
