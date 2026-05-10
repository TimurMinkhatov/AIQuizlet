//
//  CameraService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import AVFoundation
import UIKit

protocol CameraServiceProtocol: AnyObject {
    var onPhotoCaptured: ((UIImage) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    
    func setupCamera(on view: UIView)
    func start()
    func stop()
    func capturePhoto()
    func updatePreviewFrame(_ bounds: CGRect)
}

final class CameraService: NSObject, CameraServiceProtocol {
    
    // MARK: - Properties
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.aiquizlet.camera.sessionQueue")
    
    var onPhotoCaptured: ((UIImage) -> Void)?
    var onError: ((String) -> Void)?
    let previewLayer: AVCaptureVideoPreviewLayer
    
    // MARK: - Init
    
    override init() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.videoGravity = .resizeAspectFill
        super.init()
    }
    
    // MARK: - Public Methods
    
    func setupCamera(on view: UIView) {
        self.previewLayer.frame = view.bounds
        checkPermission()
        
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
    
    func updatePreviewFrame(_ bounds: CGRect) {
        previewLayer.frame = bounds
    }
}

// MARK: - Private Methods

private extension CameraService {
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self]  granted  in
                if granted {
                    self?.configureSession()
                } else {
                    self?.onError?("Доступ к камере отклонен")
                }
            }
        case .denied, .restricted:
            onError?("Камера недоступна. Пожалуйста, разрешите доступ в настройках устройства.")
        @unknown default:
            break
        }
    }
    
    func configureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.onError?("Не удалось найти камеру")
                }
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                self.captureSession.beginConfiguration()
                
                self.captureSession.inputs.forEach { self.captureSession.removeInput($0) }
                self.captureSession.outputs.forEach { self.captureSession.removeOutput($0) }
                
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
                
                if self.captureSession.canAddOutput(self.photoOutput) {
                    self.captureSession.addOutput(self.photoOutput)
                }
                
                self.captureSession.commitConfiguration()
                self.captureSession.startRunning()
            } catch {
                DispatchQueue.main.async {
                    self.onError?("Ошибка инициализации камеры: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
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
