import UIKit

class HomeViewController: UIViewController {
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
        view.backgroundColor = .white
    }
}
