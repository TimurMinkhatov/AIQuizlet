//
//  PhotoPreviewViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 27.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class PhotoPreviewViewController: UIViewController {

    // MARK: - Properties

    var onContinue: ((Int) -> Void)?
    var onRetake: (() -> Void)?
    private let previewView: PhotoPreviewView

    // MARK: - Init

    init(image: UIImage) {
        self.previewView = PhotoPreviewView(image: image)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainUI()
        setupActions()
    }

    // MARK: - Public Methods

    func stopLoading() {
        previewView.showLoading(false)
    }
}

// MARK: - Actions

private extension PhotoPreviewViewController {

    @objc func didTapContinue() {
        previewView.showLoading(true)
        onContinue?(previewView.selectedQuestionCount)
    }

    @objc func didTapRetake() {
        onRetake?()
    }
}

// MARK: - Setup Logic

private extension PhotoPreviewViewController {

    func setupMainUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(previewView)
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.layoutIfNeeded()
    }

    func setupActions() {
        previewView.continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        previewView.retakeButton.addTarget(self, action: #selector(didTapRetake), for: .touchUpInside)
    }
}
