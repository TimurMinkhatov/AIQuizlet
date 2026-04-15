//
//  HomeView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 12.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    
    private let scrollView = UIScrollView()
    private let emptyStateView = EmptyStateView()
    
    lazy var photoCard = ActionCardView(title: "Создать тест по конспекту", subtitle: "Сфотографируйте конспект и получите готовый тест", iconName: "camera", gradientColors: [
        UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1),
        UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
    ])
    
    lazy var textCard = ActionCardView(title: "Создать из текста", subtitle: "Вставьте или введите текст лекции", iconName: "text.document", gradientColors: [
        UIColor(red: 173/255, green: 70/255, blue: 255/255, alpha: 1),
        UIColor(red: 230/255, green: 0/255, blue: 118/255, alpha: 1)
    ])
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Привет!"
        label.textColor = .white
        return label
    }()
    
    private let recentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Недавние тесты"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.8)
        return button
    }()
    
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTestResult(_ test: RecentTest) {
        let card = RecentTestCardView(test: test)
        mainStackView.addArrangedSubview(card)
        
    }
    
    func onProfileTap(target: Any, action: Selector) {
        profileButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func updateEmptyState(isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
    }
    

    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        addSubview(headerStackView)
        
        headerStackView.addArrangedSubview(welcomeLabel)
        headerStackView.addArrangedSubview(profileButton)
        
        mainStackView.addArrangedSubview(headerStackView)
//        mainStackView.setCustomSpacing(60, after: headerStackView)
        
        mainStackView.addArrangedSubview(photoCard)
        mainStackView.addArrangedSubview(textCard)
        mainStackView.addArrangedSubview(recentTitleLabel)
        mainStackView.addArrangedSubview(emptyStateView)
        
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(safeAreaLayoutGuide)\
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(scrollView.snp.width).offset(-40)
            make.centerX.equalToSuperview()
        }
    }
}
