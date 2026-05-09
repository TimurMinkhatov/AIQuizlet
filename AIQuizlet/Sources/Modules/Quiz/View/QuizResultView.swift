//
//  QuizResultView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class QuizResultView: UIView {
    
    // MARK: - ViewState
        
    struct ViewState {
        let scoreText: String
        let statusText: String
        let descriptionText: String
        let percentage: Double
        let questionsCount: Int
    }
    
    // MARK: - Constants
    
    private enum Constants {
        enum Layout {
            static let headerHeight: CGFloat = 400
            static let footerHeight: CGFloat = 120
            static let percentageLabelTopOffset: CGFloat = 16
            static let statusLabelTopOffset: CGFloat = 8
            static let scoreDescriptionTopOffset: CGFloat = 4
            static let progressContainerTopOffset: CGFloat = 30
            static let progressContainerSize: CGFloat = 180
            static let buttonStackTopOffset: CGFloat = 16
            static let buttonStackHorizontalInset: CGFloat = 24
            
            static let trackLineWidth: CGFloat = 12
            static let buttonHeight: CGFloat = 52
            static let buttonCornerRadius: CGFloat = 12
            
            static let percentageFontSize: CGFloat = 56
            static let statusFontSize: CGFloat = 20
            static let descriptionFontSize: CGFloat = 14
            static let buttonFontSize: CGFloat = 15
            static let buttonImagePadding: CGFloat = 8
            
            static let haloRadiusOffset: CGFloat = 20
            static let circularRadiusOffset: CGFloat = 10
            static let progressGap: CGFloat = 0.12
            static let startAngle: CGFloat = -.pi / 2
            static let borderWidth: CGFloat = 4.0
            static let lineWidthMultiplier: CGFloat = 1.5
        }
        
        enum Colors {
            static let retryButtonBg = [
                UIColor(red: 52/255, green: 64/255, blue: 84/255, alpha: 1)
                ]
            static let gradientColors = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
                UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
            ]
            static let homeGradient = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
            ]
            static let redProgress = UIColor(red: 235/255, green: 77/255, blue: 75/255, alpha: 1)
            static let greenProgress = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            
            static let haloAlpha: CGFloat = 0.08
            static let descriptionAlpha: CGFloat = 0.8
        }
        
        enum Logic {
            static let passPercentageThreshold: Double = 50.0
            static let maxPercentage: Double = 100.0
        }
    }
    
    // MARK: - UI Elements
        
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = .leastNormalMagnitude
        table.register(QuestionAnalysisCell.self, forCellReuseIdentifier: "AnalysisCell")
        return table
    }()
    
    // MARK: - Header Elements
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.Layout.headerHeight))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Layout.percentageFontSize, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Layout.statusFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var scoreDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Layout.descriptionFontSize, weight: .regular)
        label.textColor = .white.withAlphaComponent(Constants.Colors.descriptionAlpha)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Footer Elements
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.Layout.footerHeight))
        view.backgroundColor = AppColors.historyCard
        return view
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.Layout.buttonStackTopOffset
        stack.distribution = .fillEqually
        stack.backgroundColor = AppColors.historyCard
        return stack
    }()

    lazy var retryButton: UIButton = {
        makeButton(
            title: L10n.Result.TryAgain.button,
            systemImage: "arrow.clockwise",
            backgroundColor: Constants.Colors.retryButtonBg
        )
    }()

    lazy var homeButton: UIButton = {
        makeButton(
            title: L10n.Result.Home.button,
            systemImage: "house",
            backgroundColor: Constants.Colors.homeGradient
        )
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
            super.layoutSubviews()
            applyGradient(
                colors: Constants.Colors.gradientColors,
                startPoint: CGPoint(x: 0.5, y: 0),
                endPoint: CGPoint(x: 0.5, y: 1)
            )
            homeButton.layoutIfNeeded()
            homeButton.applyGradient(
                colors: Constants.Colors.homeGradient,
                startPoint: CGPoint(x: 0, y: 0.5),
                endPoint: CGPoint(x: 1, y: 0.5),
                cornerRadius: Constants.Layout.buttonCornerRadius
            )
        }

    // MARK: - Public Methods
    
    func configure(with viewState: ViewState) {
        percentageLabel.text = viewState.scoreText
        statusLabel.text = viewState.statusText
        scoreDescriptionLabel.text = viewState.descriptionText
        percentageLabel.textColor = (viewState.percentage < Constants.Logic.passPercentageThreshold) ? .systemRed : .systemGreen
    }
    
    func drawCircularProgress(percentage: Double) {
        progressContainer.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }

        let center = CGPoint(x: progressContainer.bounds.midX, y: progressContainer.bounds.midY)
        let maxAvailableRadius = min(progressContainer.bounds.width, progressContainer.bounds.height) / 2

        let dynamicHaloRadius = maxAvailableRadius + Constants.Layout.haloRadiusOffset
        let dynamicCircularRadius = maxAvailableRadius - Constants.Layout.trackLineWidth - Constants.Layout.circularRadiusOffset
        
        let haloPath = UIBezierPath(arcCenter: center, radius: dynamicHaloRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let haloLayer = CAShapeLayer()
        haloLayer.path = haloPath.cgPath
        haloLayer.fillColor = UIColor.white.withAlphaComponent(Constants.Colors.haloAlpha).cgColor
        progressContainer.layer.addSublayer(haloLayer)

        let perc = CGFloat(percentage / Constants.Logic.maxPercentage)
        
        let addSegment = { (start: CGFloat, end: CGFloat, color: CGColor) in
            let angleOffset = (Constants.Layout.borderWidth / 2) / dynamicCircularRadius
            let borderPath = UIBezierPath(arcCenter: center, radius: dynamicCircularRadius, startAngle: start - angleOffset, endAngle: end + angleOffset, clockwise: true)
            
            let borderLayer = CAShapeLayer()
            borderLayer.path = borderPath.cgPath
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.lineWidth = (Constants.Layout.trackLineWidth * Constants.Layout.lineWidthMultiplier) + Constants.Layout.borderWidth
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineCap = .butt
            self.progressContainer.layer.addSublayer(borderLayer)
            
            let path = UIBezierPath(arcCenter: center, radius: dynamicCircularRadius, startAngle: start, endAngle: end, clockwise: true)
            
            let colorLayer = CAShapeLayer()
            colorLayer.path = path.cgPath
            colorLayer.strokeColor = color
            colorLayer.lineWidth = Constants.Layout.trackLineWidth * Constants.Layout.lineWidthMultiplier
            colorLayer.fillColor = UIColor.clear.cgColor
            colorLayer.lineCap = .butt
            self.progressContainer.layer.addSublayer(colorLayer)
        }

        if perc <= 0.0 {
            addSegment(0, 2 * .pi, Constants.Colors.redProgress.cgColor)
        } else if perc >= 1.0 {
            addSegment(0, 2 * .pi, Constants.Colors.greenProgress.cgColor)
        } else {
            let greenStart = Constants.Layout.startAngle + (Constants.Layout.progressGap / 2)
            let greenEnd = Constants.Layout.startAngle + (2 * .pi * perc) - (Constants.Layout.progressGap / 2)
            addSegment(greenStart, greenEnd, Constants.Colors.greenProgress.cgColor)
            
            let redStart = Constants.Layout.startAngle + (2 * .pi * perc) + (Constants.Layout.progressGap / 2)
            let redEnd = Constants.Layout.startAngle + 2 * .pi - (Constants.Layout.progressGap / 2)
            addSegment(redStart, redEnd, Constants.Colors.redProgress.cgColor)
        }
    }
}

// MARK: - Private Methods

private extension QuizResultView {
    
    func makeButton(title: String, systemImage: String, backgroundColor: [UIColor]) -> UIButton {
            var config = UIButton.Configuration.filled()
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: Constants.Layout.buttonFontSize, weight: .semibold)
            config.attributedTitle = AttributedString(title, attributes: container)
            config.image = UIImage(systemName: systemImage)
            config.imagePadding = Constants.Layout.buttonImagePadding
            if backgroundColor.count > 1 {
                config.baseBackgroundColor = .clear
            } else {
                config.baseBackgroundColor = backgroundColor.first ?? .clear
            }
            
            config.baseForegroundColor = .white
            config.background.cornerRadius = Constants.Layout.buttonCornerRadius
            return UIButton(configuration: config)
        }
    
    func setupUI() {
        addSubview(tableView)
        headerView.addSubviews(percentageLabel, statusLabel, scoreDescriptionLabel, progressContainer)
        tableView.tableHeaderView = headerView
        footerView.addSubview(buttonStack)
        buttonStack.addArrangedSubviews(retryButton, homeButton)
        tableView.tableFooterView = footerView
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        percentageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.percentageLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(percentageLabel.snp.bottom).offset(Constants.Layout.statusLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
        
        scoreDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(Constants.Layout.scoreDescriptionTopOffset)
            $0.centerX.equalToSuperview()
        }
        
        progressContainer.snp.makeConstraints {
            $0.top.equalTo(scoreDescriptionLabel.snp.bottom).offset(Constants.Layout.progressContainerTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.Layout.progressContainerSize)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.buttonStackTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.buttonStackHorizontalInset).priority(999)
            $0.height.equalTo(Constants.Layout.buttonHeight)
        }
    }
    
    func updateTheme() {
        if traitCollection.userInterfaceStyle != .dark {
            applyGradient(
                colors: Constants.Colors.gradientColors,
                startPoint: CGPoint(x: 0.5, y: 0),
                endPoint: CGPoint(x: 0.5, y: 1)
            )
        } else {
            layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            backgroundColor = AppColors.background
        }
    }
}
