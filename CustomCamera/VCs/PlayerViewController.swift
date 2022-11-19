//
//  PlayerViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 14.11.2022.
//

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {

    var player: AVPlayer?
    var urlOfSelectedVideo: URL?
    weak var mediaController: MediaDetailsCollectionViewController?

    private var isPlayed = true
    
    
    @IBOutlet private weak var playerView: UIView!
    
    @IBOutlet private weak var playPauseButton: UIButton!
    
    @IBAction func togglePlay(_ sender: Any) {
        isPlayed.toggle()
        isPlayed ? player?.play() : player?.pause()
        playPauseButtonSwitch()
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
        playPauseButtonSwitch()
    }

    func playPauseButtonSwitch() {
        DispatchQueue.main.async {
            self.playPauseButton.setImage(UIImage(systemName: self.isPlayed ? "pause.fill" : "play.fill"), for: .normal)
        }
    }
    

}
