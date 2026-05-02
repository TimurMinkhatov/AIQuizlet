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
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 320)
        return view
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var scoreDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(QuestionAnalysisCell.self, forCellReuseIdentifier: "AnalysisCell")
        return table
    }()

    lazy var retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Пройти заново", for: .normal)
        btn.backgroundColor = .white.withAlphaComponent(0.2)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()

    lazy var homeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("На главную", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: - Public Methods
    func configure(with percent: String, description: String) {
        percentageLabel.text = percent
        scoreDescriptionLabel.text = description
    }
    
    func drawCircularProgress(percentage: Double) {
        headerView.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }

        let center = CGPoint(x: headerView.bounds.midX, y: 150)
        let circularPath = UIBezierPath(arcCenter: center, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = (percentage < 50) ? UIColor.systemRed.cgColor : UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(percentage / 100)
        
        headerView.layer.addSublayer(trackLayer)
        headerView.layer.addSublayer(progressLayer)
    }
}

private extension QuizResultView {
    func setupUI() {
        gradientLayer.colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1).cgColor
        ]
        layer.addSublayer(gradientLayer)
        
        headerView.addSubview(percentageLabel)
        headerView.addSubview(scoreDescriptionLabel)
        
        tableView.tableHeaderView = headerView
        
        addSubview(tableView)
        addSubview(retryButton)
        addSubview(homeButton)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(retryButton.snp.top).offset(-10)
        }

        percentageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }

        scoreDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(percentageLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }

        retryButton.snp.makeConstraints {
            $0.bottom.equalTo(homeButton.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
}
