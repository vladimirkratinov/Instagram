//
//  GPTCameraViewController.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-03-01.
//

import UIKit
import AVFoundation

class GPTCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    private var captureSession = AVCaptureSession()
    private var output: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUpCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Unable to access front camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Error setting up input: \(error.localizedDescription)")
        }
        
        
        if captureSession.canAddOutput(output!) {
            captureSession.addOutput(output!)
        }
    }
    
    func startCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isHighResolutionPhotoEnabled = true
        //        settings.isAutoStillImageStabilizationEnabled = true
        
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        
        settings.previewPhotoFormat = previewFormat
        
        output?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Unable to get image data.")
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            print("Unable to create UIImage from image data.")
            return
        }
        
        // Do something with the captured image
        // For example, display it in a UIImageView
//        imageView.image = image
    }
}
    
