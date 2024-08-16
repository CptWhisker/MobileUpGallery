import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    private let configuration: AuthConfiguration = .standard
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
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
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(loadingBar)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            URLQueryItem(name: "scope", value: "video")
        ]
        
        guard let url = urlComponents.url else {
            print("ERROR")
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
        
        return parameters["access_token"]
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let accessToken = getAccessToken(from: navigationAction) {
            AccessTokenStorage.shared.accessToken = accessToken
            
            let galleryViewController = GalleryViewController()
            let galleryNavigationController = UINavigationController(rootViewController: galleryViewController)
            galleryNavigationController.modalPresentationStyle = .fullScreen
            
            present(galleryNavigationController, animated: true) {
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
