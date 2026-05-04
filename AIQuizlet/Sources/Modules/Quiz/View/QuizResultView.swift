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
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonHeight: CGFloat = 52
        static let buttonCornerRadius: CGFloat = 12
        static let circularRadius: CGFloat = 60
        static let haloRadius: CGFloat = 80
        static let trackLineWidth: CGFloat = 12
        
        enum Layout {
            static let headerHeight: CGFloat = 380
            static let footerHeight: CGFloat = 120
            static let percentageLabelTopOffset: CGFloat = 40
            static let statusLabelTopOffset: CGFloat = 8
            static let scoreDescriptionTopOffset: CGFloat = 4
            static let progressContainerTopOffset: CGFloat = 30
            static let progressContainerSize: CGFloat = 180
            static let buttonStackTopOffset: CGFloat = 16
            static let buttonStackHorizontalInset: CGFloat = 24
        }
        
        enum Colors {
            static let retryButtonBg = UIColor(red: 52/255, green: 64/255, blue: 84/255, alpha: 1)
            static let homeButtonBg = UIColor(red: 108/255, green: 71/255, blue: 255/255, alpha: 1)
            static let gradientColors = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
                UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
            ]
            static let homeGradient = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
            ]
        }
        
        enum Strings {
            static let retryTitle = "Пройти заново"
            static let homeTitle = "На главную"
            static let cellIdentifier = "AnalysisCell"
        }
    }
    
    // MARK: - UI Elements
        
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = .leastNormalMagnitude
        table.register(QuestionAnalysisCell.self, forCellReuseIdentifier: Constants.Strings.cellIdentifier)
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
        label.font = .systemFont(ofSize: 56, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var scoreDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
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
        view.backgroundColor = .white
        return view
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    lazy var retryButton: UIButton = {
        makeButton(
            title: Constants.Strings.retryTitle,
            systemImage: "arrow.clockwise",
            backgroundColor: Constants.Colors.retryButtonBg
        )
    }()

    lazy var homeButton: UIButton = {
        makeButton(
            title: Constants.Strings.homeTitle,
            systemImage: "house",
            backgroundColor: Constants.Colors.homeButtonBg
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
        homeButton.applyGradient(
            colors: Constants.Colors.homeGradient,
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5),
            cornerRadius: Constants.buttonCornerRadius
        )
    }

    // MARK: - Public Methods
    
    func configure(percentageText: String, statusText: String, description: String, percentage: Double) {
        percentageLabel.text = percentageText
        statusLabel.text = statusText
        scoreDescriptionLabel.text = description
        percentageLabel.textColor = (percentage < 50) ? .systemRed : .systemGreen
    }
    
    func drawCircularProgress(percentage: Double) {
        progressContainer.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }

        let center = CGPoint(x: progressContainer.bounds.midX, y: progressContainer.bounds.midY)
        
        let haloPath = UIBezierPath(arcCenter: center, radius: Constants.haloRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let haloLayer = CAShapeLayer()
        haloLayer.path = haloPath.cgPath
        haloLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        progressContainer.layer.addSublayer(haloLayer)

        let circularPath = UIBezierPath(arcCenter: center, radius: Constants.circularRadius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemRed.cgColor
        trackLayer.lineWidth = Constants.trackLineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = Constants.trackLineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(percentage / 100)
        
        progressContainer.layer.addSublayer(trackLayer)
        progressContainer.layer.addSublayer(progressLayer)
    }
}

// MARK: - Private Methods

private extension QuizResultView {
    
    func makeButton(title: String, systemImage: String, backgroundColor: UIColor) -> UIButton {
        var config = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = AttributedString(title, attributes: container)
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 8
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.buttonCornerRadius
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
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.buttonStackHorizontalInset)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
}
