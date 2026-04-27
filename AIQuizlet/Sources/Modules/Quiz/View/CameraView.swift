//
//  CameraView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 24.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class CameraView: UIView {
    
    // MARK: - UI Elements
    
    lazy var galleryButton: UIButton = {
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
    
    lazy var shutterButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "camera")
        button.tintColor = .black
        button.setImage(image, for: .normal)
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
    
    // MARK: - Public Methods
    
    func animateShutterTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.shutterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.shutterButton.transform = .identity
            }
        }
    }
}

// MARK: - Private Methods

private extension CameraView {
    
    func setupUI() {
        backgroundColor = .clear
        addSubview(galleryButton)
        addSubview(shutterOutterView)
        shutterOutterView.addSubview(shutterButton)
    }
    
    func setupConstraints() {
        shutterOutterView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        shutterButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(54)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.centerY.equalTo(shutterOutterView)
            make.leading.equalToSuperview().offset(40)
            make.size.equalTo(50)
        }
    }
}
