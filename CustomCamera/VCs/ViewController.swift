//
//  ViewController.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 08.11.2022.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let camera = Camera()
    
    private var pressTimer: Timer?
    private var isVideoRecorded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? camera.prepare()
        try? camera.add(to: view)
        
        camera.delegate = self
    }

    @IBAction func switchCamera() {
        try? camera.switchCamera()
    }
    
    @IBAction func capture() {
        restartTimer()
    }
    
    @IBAction func stopCapturing() {
        pressTimer?.invalidate()
        isVideoRecorded ? camera.stopVideoRecording() : camera.capturePhoto()
        isVideoRecorded = false
    }
    
    func restartTimer() {
        pressTimer?.invalidate()
        pressTimer = .scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            self?.camera.startVideoRecording()
            self?.isVideoRecorded = true
            
            timer.invalidate()
        }
    }

}

extension ViewController: CameraDelegate {
    func camera(_ camera: Camera, didCapture imageData: Data) {
        MediaLibrary.shared.add(MediaData.photo(imageData))
    }
    
    func camera(_ camera: Camera, didFinishrecordingVideo url: URL) {
        print(MediaData.video(url))
        MediaLibrary.shared.add(MediaData.video(url))
    }
}


