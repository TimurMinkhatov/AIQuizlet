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
    
    // MARK: - UI Elements
    
    private let gradientLayer = CAGradientLayer()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = .leastNormalMagnitude
        table.register(QuestionAnalysisCell.self, forCellReuseIdentifier: "AnalysisCell")
        return table
    }()
    
    // MARK: - Header Elements (Progress)
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 380))
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
    
    // MARK: - Footer Elements (Buttons)
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
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
        title: "Пройти заново",
        systemImage: "arrow.clockwise",
        backgroundColor: UIColor(red: 52/255, green: 64/255, blue: 84/255, alpha: 1)
        )
    }()

    lazy var homeButton: UIButton = {
        makeButton(
        title: "На главную",
        systemImage: "house",
        backgroundColor: UIColor(red: 108/255, green: 71/255, blue: 255/255, alpha: 1)
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
            colors: [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
                UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
            ],
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint: CGPoint(x: 0.5, y: 1)
        )
        homeButton.applyGradient(
            colors: [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
            ],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5),
            cornerRadius: 12
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
        
        let haloPath = UIBezierPath(arcCenter: center, radius: 80, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let haloLayer = CAShapeLayer()
        haloLayer.path = haloPath.cgPath
        haloLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        progressContainer.layer.addSublayer(haloLayer)

        let circularPath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemRed.cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(percentage / 100)
        
        progressContainer.layer.addSublayer(trackLayer)
        progressContainer.layer.addSublayer(progressLayer)
    }
}

// MARK: - Private Methods

private extension QuizResultView {
    
    private func makeButton(
        title: String,
        systemImage: String,
        backgroundColor: UIColor
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = AttributedString(title, attributes: container)
        
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 8
        
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = .white
        config.background.cornerRadius = 12
        
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
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(percentageLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        scoreDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        progressContainer.snp.makeConstraints {
            $0.top.equalTo(scoreDescriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(180)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
}
