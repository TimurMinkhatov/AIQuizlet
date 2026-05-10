//
//  CameraView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

protocol CameraViewDelegate: AnyObject {
    func cameraViewDidTapShutter(_ view: CameraView)
    func cameraViewDidTapGallery(_ view: CameraView)
}

private enum Constants {
    static let sidePadding: CGFloat = 24
    static let bottomPadding: CGFloat = 40
    static let shutterSize: CGFloat = 70
    static let galleryButtonRadius: CGFloat = 25
    static let galleryButtonSize: CGFloat = 50
    static let galleryButtonLeading: CGFloat = 40
}

final class CameraView: UIView {
    weak var delegate: CameraViewDelegate?
    
    // MARK: - UI Elements
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private lazy var shutterOutterView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var shutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "camera",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        ),
        for: .normal
        )
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension CameraView {
    
    func setupUI() {
        backgroundColor = .clear
        addSubviews(galleryButton, shutterOutterView)
        shutterOutterView.addSubview(shutterButton)
        
        shutterButton.addTarget(self, action: #selector(shutterTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        shutterOutterView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Constants.bottomPadding)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.shutterSize)
        }
        
        shutterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.shutterSize)
        }
        
        galleryButton.snp.makeConstraints {
            $0.centerY.equalTo(shutterOutterView)
            $0.leading.equalToSuperview().offset(Constants.galleryButtonLeading)
            $0.size.equalTo(Constants.galleryButtonSize)
        }
    }
    
    func animateShutterTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.shutterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.shutterButton.transform = .identity
            }
        })
    }
    
    @objc func shutterTapped() {
        animateShutterTap()
        delegate?.cameraViewDidTapShutter(self)
    }
    
    @objc func galleryTapped() {
        delegate?.cameraViewDidTapGallery(self)
    }
}
