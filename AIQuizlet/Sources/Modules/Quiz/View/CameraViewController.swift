//
//  CameraViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import PhotosUI

final class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CameraViewModel
    private let cameraView = CameraView()
    
    // MARK: - Init
    
    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainUI()
        setupConstraints()
        setupActions()
        viewModel.setupPreview(on: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopSession()
    }
}

// MARK: - PHPickerViewControllerDelegate

extension CameraViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            if let selectedImage = image as? UIImage {
                DispatchQueue.main.async {
                    self?.viewModel.handleSelectedPhoto(selectedImage)
                }
            }
        }
    }
}

// MARK: - Actions

private extension CameraViewController {
    
    @objc func didTabCapture() {
        cameraView.animateShutterTap()
        viewModel.capturePhoto()
    }
    
    @objc func didTapGallery() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Setup Logic

private extension CameraViewController {
    
    func setupMainUI() {
        view.backgroundColor = .black
        view.addSubview(cameraView)
        view.layer.insertSublayer(viewModel.previewLayer, at: 0)
    }
    
    func setupConstraints() {
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        cameraView.shutterButton.addTarget(self, action: #selector(didTabCapture), for: .touchUpInside)
        cameraView.galleryButton.addTarget(self, action: #selector(didTapGallery), for: .touchUpInside)
    }
}
