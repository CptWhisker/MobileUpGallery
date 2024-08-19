import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    private let configuration: AuthConfiguration = .standard
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private lazy var loadingBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .black
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
        addObserverForLoadingProgress()
        loadAuthView()
    }
    
    // MARK: - Interface Configuration
    private func configureInterface() {
        view.backgroundColor = .main
        
        configureWebView()
        configureLoadingBar()
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureLoadingBar() {
        view.addSubview(loadingBar)
        
        NSLayoutConstraint.activate([
            loadingBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - KVO
    private func addObserverForLoadingProgress() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
            guard let self else { return }
            
            self.updateLoadingProgress(self.webView.estimatedProgress)
        }
    }
    
    private func updateLoadingProgress(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        
        loadingBar.progress = newProgressValue
        
        if abs(newProgressValue - 1.0) <= 0.001 {
            loadingBar.isHidden = true
        }
    }
    
    // MARK: - Loading Auth View
    private func loadAuthView() {
        var urlComponents = URLComponents()
        urlComponents.scheme = configuration.scheme
        urlComponents.host = configuration.host
        urlComponents.path = configuration.path
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.clientID),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "display", value: configuration.display),
            URLQueryItem(name: "response_type", value: configuration.responseType),
            URLQueryItem(name: "scope", value: configuration.scope)
        ]
        
        guard let url = urlComponents.url else {
            showAlert(title: "InternalError", message: "An unexpected error occurred while preparing the login page. Please try again later.", actions: [.cancel])
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Extracting Access Token
    private func getAccessToken(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url,
              url.path == configuration.navigationActionPath,
              let fragment = url.fragment else {
            return nil
        }
        
        let parameters = Dictionary(uniqueKeysWithValues: fragment.split(separator: "&").map {
            let pair = $0.split(separator: "=")
            return (String(pair[0]), String(pair[1]))
        })
        
        if let token = parameters["access_token"] {
            return token
        }
        
        showAlert(title: "Authorization Failed", message: "Failed to retrieve access token. Please try again.", actions: [.reload, .cancel])
        return nil
    }
    
    // MARK: - Switching to Gallery
    private func switchToGallery() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let galleryViewController = GalleryViewController()
        let galleryNavigationController = UINavigationController(rootViewController: galleryViewController)
        window.rootViewController = galleryNavigationController
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionFlipFromRight,
            animations: nil,
            completion: nil
        )
    }
    
    // MARK: - Showing Alert
    private func showAlert(title: String, message: String, actions: [AlertActions]) {
        AlertPresenterService.shared.showAlert(on: self, title: title, message: message, actions: actions)
    }
    
    // MARK: - Public Methods
    func reloadTapped() {
        loadAuthView()
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let accessToken = getAccessToken(from: navigationAction) {
            AccessTokenStorage.shared.accessToken = accessToken
            
            decisionHandler(.cancel)
            
            switchToGallery()
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showAlert(title: "Error", message: "Failed to load the authentication page. Please check your connection and try again.", actions: [.reload, .cancel])
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showAlert(title: "Error", message: "An unexpected error occurred. Please try again.", actions: [.reload, .cancel])
    }
}
