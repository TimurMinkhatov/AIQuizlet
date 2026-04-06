import UIKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}
