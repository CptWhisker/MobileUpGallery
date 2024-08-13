import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
    }
    
    private func configureInterface() {
        view.backgroundColor = .white
        
        configureWebView()
        loadPage()
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
    
    private func loadPage() {
        let url = URL(string: "https://google.com")!
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
}
