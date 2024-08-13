import UIKit
import WebKit

final class WebViewViewController: UIViewController {
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
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
        addObserverForLoadingBar()
        loadPage()
    }
    
    private func configureInterface() {
        view.backgroundColor = .white
        
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
    
    private func addObserverForLoadingBar() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
            guard let self else { return }
            
            updateLoadingProgress(webView.estimatedProgress)
        }
    }
    
    private func loadPage() {
        let url = URL(string: "https://google.com")!
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    private func updateLoadingProgress(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        
        loadingBar.progress = newProgressValue
        
        if abs(newProgressValue - 1.0) <= 0.001 {
            loadingBar.isHidden = true
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
}
