//
//  Camera.swift
//  CustomCamera
//
//  Created by Dmytro Hetman on 08.11.2022.
//

import AVFoundation
import UIKit

protocol CameraDelegate: AnyObject {
    
    func camera(_ camera: Camera, didCapture: Data)
    func camera(_ camera: Camera, didFinishrecordingVideo: URL)
    
}

final class Camera: NSObject {
    
    enum CameraError: Error {
        
        case deviceUnavailable
        case cantAddInput
        case cantAddOutput
        case cantCreateLayerNow
        case cantAddAudioInput
        
    }
    
    private var captureSession: AVCaptureSession!
    
    private var currentCamera: AVCaptureDevice!
    private var currentCameraInput: AVCaptureDeviceInput!
    
    private var photoOutput: AVCapturePhotoOutput!
    private var videoOutput: AVCaptureMovieFileOutput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var cameraPosition: AVCaptureDevice.Position = .back
    
//    private var audioDevice: AVAudioDe
    
    private(set) var isCameraReady = false
    weak var delegate: CameraDelegate?
    
}

//MARK: - Public API
extension Camera {
    
    func add(to view: UIView) throws {
        guard isCameraReady else { throw CameraError.cantCreateLayerNow }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    func prepare() throws {
        try setupCaptureSession()
    }
    
    func switchCamera() throws {
        cameraPosition = cameraPosition == .back ? .front : .back
        captureSession.removeInput(currentCameraInput)
        
        try setupDevices()
        try setupInputs()
        try setupAudio()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .on
        settings.isAutoRedEyeReductionEnabled = true
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func startVideoRecording() {
        guard captureSession.isRunning else { return }
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "\(stringOfCurrentDate()).mov") else { return }
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }
    
    private func stringOfCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MMM-d-HH-mm-ss"
        return dateFormatter.string(from: date)
    }
    
    func stopVideoRecording() {
        videoOutput.stopRecording()
    }
}

//MARK: - Private API
private extension Camera {
    
    func setupCaptureSession() throws {
        
        guard !isCameraReady else { return }
        
        captureSession = AVCaptureSession()
        
        //devices
        try setupDevices()
        //inputs
        try setupInputs()
        //outputs
        try setupOutputs()
        //audio
        try setupAudio()
        
        //start session
        
        
        DispatchQueue(label: "camera.queue").async {
            
            self.captureSession.startRunning()
        }
        isCameraReady = true
    }
    
    func setupDevices() throws {

//        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: cameraPosition == .back ? [.builtInDualCamera] : [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInMicrophone], mediaType: .video, position: .unspecified)
        
        let cameras = discoverySession.devices
        
        guard let camera = cameras.first(where: { $0.position == cameraPosition }) else { throw CameraError.deviceUnavailable }
        
        currentCamera = camera
        
        
        try camera.lockForConfiguration()
        if camera.isFocusModeSupported(.continuousAutoFocus) {
            camera.focusMode = .continuousAutoFocus
        }
        camera.unlockForConfiguration()
    }
    
    func setupInputs() throws {
        currentCameraInput = try AVCaptureDeviceInput(device: currentCamera!)
        
        if captureSession.canAddInput(currentCameraInput) {
            captureSession.addInput(currentCameraInput)
        } else {
            throw CameraError.cantAddInput
        }
    }
    
    func setupOutputs() throws {
        photoOutput = AVCapturePhotoOutput()
        videoOutput = AVCaptureMovieFileOutput()
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CameraError.cantAddOutput
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            throw CameraError.cantAddOutput
        }
    }
    
    func setupAudio() throws {
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }
        let currentAudioInput = try AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(currentAudioInput) {
            captureSession.addInput(currentAudioInput)
        } else {
            throw CameraError.cantAddAudioInput
        }
       
        
    }
    
}

extension Camera: AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        delegate?.camera(self, didFinishrecordingVideo: outputFileURL)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        delegate?.camera(self, didCapture: data)
    }
}
