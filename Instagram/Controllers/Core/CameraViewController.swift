//
//  CameraViewController.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // Capture session:
    private var captureSession: AVCaptureSession?
    // Photo Output:
    private var output = AVCapturePhotoOutput()
    // Video preview:
    private let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter button:
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Take Photo"
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        setUpNavBar()
        checkCameraPermission()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        previewLayer.frame = CGRect(
//            x: 0,
//            y: view.safeAreaInsets.top,
//            width: view.width,
//            height: view.width
//        )
        
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 100)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    
    @objc private func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    // Check camera permission:
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            
        case .notDetermined:
            // Request a permission:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                // Call Set Up Camera (UI) in the Main Thread:
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        // Add Device:
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                // Create input from the device:
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    // Add Input:
                    captureSession.addInput(input)
                }
            }
            catch {
                print(error)
            }
            
            // Add output:
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }
            
            // Layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            
            // Background Thread UI Issue:
            DispatchQueue.global().async {
                captureSession.startRunning()
                self.captureSession = captureSession
            }
        }
    }
    
    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // Convert photo to data:
        guard let data = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: data)
        
        captureSession?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
