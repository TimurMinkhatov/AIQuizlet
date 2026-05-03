//
//  CameraViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import PhotosUI
import SnapKit

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
        cameraView.delegate = self
        setupMainUI()
        setupConstraints()
        viewModel.setupPreview(on: view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updatePreviewFrame(view.bounds)
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
        viewModel.handlePickerResults(results)
    }
}

// MARK: - Actions

private extension CameraViewController {
    
    @objc func didTapCapture() {
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
}

// MARK: Delegate

extension CameraViewController: CameraViewDelegate {
    
    func cameraViewDidTapShutter(_ view: CameraView) {
        viewModel.capturePhoto()
    }
    
    func cameraViewDidTapGallery(_ view: CameraView) {
        didTapGallery()
    }
}
