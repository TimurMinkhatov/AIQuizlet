import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    var viewModel: HomeViewModel!

    init(viewModel: HomeViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        view.backgroundColor = .white
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background")

        view.addSubview(welcomeLabel)
        view.addSubview(mainStackView)
    }

    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
