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
    
    // MARK: - Constants
    
    private enum Constants {
        static let mainPadding: CGFloat = 20
        static let headerHeight: CGFloat = 50
        static let profileButtonSize: CGFloat = 44
        static let sectionHeaderHeight: CGFloat = 30
        static let mainStackSpacing: CGFloat = 20
        static let scrollViewTopOffset: CGFloat = 80
        static let headerStackViewOffset: CGFloat = 20
        
        enum Fonts {
            static let welcome = UIFont.systemFont(ofSize: 24, weight: .bold)
            static let sectionTitle = UIFont.systemFont(ofSize: 20, weight: .semibold)
            static let seeAllButton = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    private lazy var emptyStateView = EmptyStateView()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.welcome
        label.text = L10n.Home.greeting
        label.textColor = .white
        return label
    }()
    
    private lazy var recentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Home.RecentQuizzes.title
        label.font = Constants.Fonts.sectionTitle
        label.textColor = .white
        return label
    }()
    
    private lazy var recentTestsHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private lazy var seeAllTestsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Home.Quiz.watch, for: .normal)
        button.titleLabel?.font = Constants.Fonts.seeAllButton
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        return button
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
        stack.spacing = Constants.mainStackSpacing
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
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        let style = ThemeManager.shared.savedStyle == .unspecified
            ? traitCollection.userInterfaceStyle
            : ThemeManager.shared.savedStyle
            
        backgroundColor = (style == .dark) ? AppColors.historyCard : .white
        
        updateForTheme(traitCollection.userInterfaceStyle)
    }
    
    // MARK: - Public Methods
    
    func addTestResult(_ cardView: UIView) {
        mainStackView.addArrangedSubview(cardView)
    }
    
    func onProfileTap(target: Any, action: Selector) {
        profileButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func updateEmptyState(isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
    }
    
    func clearRecentTests() {
        mainStackView.arrangedSubviews
            .filter { $0 is RecentTestCardView }
            .forEach {
                mainStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
    }
    
    func onSeeAllTap(target: Any, action: Selector) {
        seeAllTestsButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func updateForTheme(_ style: UIUserInterfaceStyle) {
        let isDark = style == .dark
        self.backgroundColor = isDark ? AppColors.historyCard : .white
        let labelColor: UIColor = isDark ? .label : .white
        let secondaryColor: UIColor = isDark ? .secondaryLabel : .white.withAlphaComponent(0.7)
        let iconColor: UIColor = isDark ? .label : .white.withAlphaComponent(0.8)
    
        welcomeLabel.textColor = labelColor
        recentTitleLabel.textColor = labelColor
        seeAllTestsButton.setTitleColor(secondaryColor, for: .normal)
        profileButton.tintColor = iconColor
    }
}

// MARK: - Setup Logic

private extension HomeView {
    
    func setupUI() {
        let style = ThemeManager.shared.savedStyle == .unspecified
            ? traitCollection.userInterfaceStyle
            : ThemeManager.shared.savedStyle
        
        backgroundColor = (style == .dark) ? AppColors.historyCard : .white
        addSubview(scrollView)
        headerStackView.addArrangedSubviews(welcomeLabel, profileButton)
        scrollView.addSubviews(headerStackView, mainStackView)
        
        recentTestsHeaderStack.addArrangedSubviews(recentTitleLabel, seeAllTestsButton)
        mainStackView.addArrangedSubviews(photoCard, textCard, recentTestsHeaderStack, emptyStateView)
    }

    func setupConstraints() {
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.headerStackViewOffset)
            $0.leading.trailing.equalTo(self).inset(Constants.mainPadding)
            $0.height.equalTo(Constants.headerHeight)
        }
        
        recentTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        seeAllTestsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recentTestsHeaderStack.snp.makeConstraints {
            $0.height.equalTo(Constants.sectionHeaderHeight)
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.scrollViewTopOffset)
            $0.bottom.equalToSuperview().inset(Constants.mainPadding)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width).offset(-(Constants.mainPadding * 2))
        }
        
        profileButton.snp.makeConstraints {
            $0.size.equalTo(Constants.profileButtonSize)
        }
    }
}
