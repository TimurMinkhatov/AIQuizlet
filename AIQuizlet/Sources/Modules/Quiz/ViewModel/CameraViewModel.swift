//
//  CameraViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 27.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class CameraViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: QuizCoordinator?
    private let cameraService: CameraService
    
    var onErrorMessage: ((String) -> Void)?
    
    var previewLayer: CALayer {
        return cameraService.previewLayer
    }

    // MARK: - Init
    
    init(cameraService: CameraService) {
        self.cameraService = cameraService
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func capturePhoto() {
        cameraService.capturePhoto()
    }
    
    func startSession() {
        cameraService.start()
    }
    
    func stopSession() {
        cameraService.stop()
    }
    
    func setupPreview(on view: UIView) {
        cameraService.setupCamera(on: view)
    }
    
    func closeCamera() {
        coordinator?.navigationController.popViewController(animated: true)
    }
        
    func handleSelectedPhoto(_ image: UIImage) {
        coordinator?.didCapturePhoto(image)
    }
    
    func updatePreviewFrame(_ bounds: CGRect) {
        cameraService.updatePreviewFrame(bounds)
    }
}

// MARK: - Private Methods

private extension CameraViewModel {
    
    func setupBindings() {
        cameraService.onPhotoCaptured = { [weak self] image in
            DispatchQueue.main.async {
                self?.coordinator?.didCapturePhoto(image)
            }
        }
        
        cameraService.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.onErrorMessage?(message)
            }
        }
    }
}
