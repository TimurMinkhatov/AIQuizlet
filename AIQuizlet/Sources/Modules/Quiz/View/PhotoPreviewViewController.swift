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
    
    private let viewModel: PhotoPreviewViewModel
    private let previewView: PhotoPreviewView

    // MARK: - Init

    init(viewModel: PhotoPreviewViewModel) {
        self.viewModel = viewModel
        self.previewView = PhotoPreviewView(image: viewModel.image)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Public Methods

    func stopLoading() {
        previewView.showLoading(false)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - Actions

private extension PhotoPreviewViewController {

    @objc func didTapContinue() {
        viewModel.generateQuiz(questionsCount: previewView.selectedQuestionCount)
    }

    @objc func didTapRetake() {
        viewModel.didRequestRetake()
    }
}

// MARK: - Setup Logic

private extension PhotoPreviewViewController {

    func bindViewModel() {
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.previewView.showLoading(isLoading)
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error)
            }
        }
    }
    
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(previewView)
        previewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.layoutIfNeeded() 
    }

    func setupActions() {
        previewView.continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        previewView.retakeButton.addTarget(self, action: #selector(didTapRetake), for: .touchUpInside)
    }
}
