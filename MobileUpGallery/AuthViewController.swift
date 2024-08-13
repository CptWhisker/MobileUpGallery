import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Layout Constraints
    private struct Layout {
        static let titleTopMargin: CGFloat = 170
        static let titleSideMargin: CGFloat = 24
        static let titleFontSize: CGFloat = 44
        
        static let buttonBottomMargin: CGFloat = 8
        static let buttonSideMargin: CGFloat = 16
        static let buttonHeight: CGFloat = 52
        static let buttonCornerRadius: CGFloat = 12
        static let buttonFontSize: CGFloat = 15
    }
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Mobile Up\nGallery"
        label.textColor = .black
        label.font = .systemFont(ofSize: Layout.titleFontSize, weight: .bold)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход через VK", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Layout.buttonFontSize)
        button.layer.cornerRadius = Layout.buttonCornerRadius
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
    }
    
    // MARK: - Interface Configuration
    private func configureInterface() {
        view.backgroundColor = .white
        
        configureTitleLabel()
        configureLoginButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.titleSideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.titleSideMargin),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.titleFontSize)
        ])
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.buttonBottomMargin),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.buttonSideMargin),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.buttonSideMargin),
            loginButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        let webViewViewController = WebViewViewController()
        present(webViewViewController, animated: true, completion: nil)
    }
}

