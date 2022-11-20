//
//  PlayerViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 14.11.2022.
//

import UIKit
import AVFoundation
import Photos

final class PlayerViewController: UIViewController {

    var player: AVPlayer?
    var urlOfSelectedVideo: URL?
    weak var mediaController: MediaDetailsCollectionViewController?
    weak var delegate: MediaLibraryDelegate?
    var indexPath: IndexPath?

    private var isPlayed = true
    private var isMuted = true
    
    
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var isMutedButton: UIButton!
    
    @IBAction func saveVideo(_ sender: Any) {
        saveVideoWithAlert()
    }
    
    @IBAction func togglePlay(_ sender: Any) {
        isPlayed.toggle()
        isPlayed ? player?.play() : player?.pause()
        playPauseButtonSwitch()
    }
    
    @IBAction func toggleSound(_ sender: Any) {
        isMuted.toggle()
        player?.isMuted = isMuted ? true : false
        isMutedButtonSwitch()
    }
    
    
    @IBAction func deleteVideo(_ sender: Any) {
        if let url = urlOfSelectedVideo, let indexPath {
            delegate?.delete(.video(url), of: indexPath)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        guard let urlOfSelectedVideo = urlOfSelectedVideo else { return }
        setURL(urlOfSelectedVideo)
    }
    
    @objc
    func videoDidEnded(note: NSNotification) {
        player?.seek(to: .zero)
        isPlayed = false
        playPauseButtonSwitch()
    }
    
    func setURL(_ ofVideo: URL) {
        player = .init(url: ofVideo)
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspect
        layer.frame = playerView.bounds
        playerView.layer.masksToBounds = true
        playerView.layer.addSublayer(layer)
        player?.play()
        player?.isMuted = true
        playPauseButtonSwitch()
    }

    func playPauseButtonSwitch() {
        DispatchQueue.main.async {
            self.playPauseButton.setImage(UIImage(systemName: self.isPlayed ? "pause.fill" : "play.fill"), for: .normal)
        }
    }
    
    func isMutedButtonSwitch() {
        DispatchQueue.main.async {
            self.isMutedButton.setImage(UIImage(systemName: self.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill"), for: .normal)
        }
    }
    
    func saveVideoWithAlert() {
        let saveAlert = UIAlertController(title: "Alert", message: "Video is saved", preferredStyle: UIAlertController.Style.alert)
        saveAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            guard let url = self.urlOfSelectedVideo else { return }
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetCreationRequest.forAsset().addResource(with: .video, fileURL: url, options: nil)
            }
        }))
        present(saveAlert, animated: true, completion: nil)
    }
    

}
