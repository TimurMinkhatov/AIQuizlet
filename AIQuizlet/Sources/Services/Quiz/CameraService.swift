//
//  CameraService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import AVFoundation
import UIKit

final class CameraService: NSObject {
    
    // MARK: - Properties
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.aiquizlet.camera.sessionQueue")
    
    var onPhotoCaptured: ((UIImage) -> Void)?
    let prewiewLayer: AVCaptureVideoPreviewLayer
    
    // MARK: - Init
    
    override init() {
        self.prewiewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.prewiewLayer.videoGravity = .resizeAspectFill
        super.init()
    }
    
    // MARK: - Public Methods
    
    func setupCamera(on view: UIView) {
        self.prewiewLayer.frame = view.bounds
        
        sessionQueue.async {
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                self.captureSession.beginConfiguration()
                
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
                
                if self.captureSession.canAddOutput(self.photoOutput) {
                    self.captureSession.addOutput(self.photoOutput)
                }
                
                self.captureSession.commitConfiguration()
                self.captureSession.startRunning()
            } catch {
                print("Ошибка инициализации камеры: \(error)")
            }
        }
    }
    
    func start() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stop() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Ошибка захвата: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.onPhotoCaptured?(image)
        }
    }
}
