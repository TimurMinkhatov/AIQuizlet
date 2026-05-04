//
//  HomeView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import UIKit
import SnapKit

final class HomeView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    private lazy var emptyStateView = EmptyStateView()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = L10n.Home.greeting
        label.textColor = .label
        return label
    }()
    
    private lazy var recentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Home.RecentQuizzes.title
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemBackground
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.8)
        return button
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    lazy var photoCard = ActionCardView(
        title: L10n.Home.CreateFromPhoto.title,
        subtitle: L10n.Home.CreateFromPhoto.subtitle,
        iconName: "camera",
        gradientColors: [
            UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1),
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
        ]
    )
    
    lazy var textCard = ActionCardView(
        title: L10n.Home.CreateFromText.title,
        subtitle: L10n.Home.CreateFromText.subtitle,
        iconName: "text.document",
        gradientColors: [
            UIColor(red: 173/255, green: 70/255, blue: 255/255, alpha: 1),
            UIColor(red: 230/255, green: 0/255, blue: 118/255, alpha: 1)
        ]
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        updateCardBackground()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (view: HomeView, _) in
            self?.updateCardBackground()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
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
    
    func updateForTheme(_ style: UIUserInterfaceStyle) {
        if style == .dark {
            backgroundColor = .systemGroupedBackground
            welcomeLabel.textColor = .label
            recentTitleLabel.textColor = .label
            profileButton.tintColor = .label
        } else {
            backgroundColor = .clear
            welcomeLabel.textColor = .white
            recentTitleLabel.textColor = .white
            profileButton.tintColor = .white.withAlphaComponent(0.8)
        }
    }
}

// MARK: - Setup Logic

private extension HomeView {
    
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(scrollView)
        addSubview(headerStackView)
        
        scrollView.addSubview(mainStackView)
        
        headerStackView.addArrangedSubview(welcomeLabel)
        headerStackView.addArrangedSubview(profileButton)
        
        mainStackView.addArrangedSubview(photoCard)
        mainStackView.addArrangedSubview(textCard)
        mainStackView.addArrangedSubview(recentTitleLabel)
        mainStackView.addArrangedSubview(emptyStateView)
    }

    func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(-5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(scrollView.snp.width).offset(-40)
        }
        
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
    
    func updateCardBackground() {
        photoCard.backgroundColor = traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "1e2939")
            : .secondarySystemGroupedBackground
        
        textCard.backgroundColor = traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "1e2939")
            : .secondarySystemGroupedBackground
        
    }
}
