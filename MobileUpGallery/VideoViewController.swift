import UIKit
import WebKit

final class VideoPlayerViewController: UIViewController {
    // MARK: - Properties
    private let video: Video
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .main
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private lazy var loadingBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .black
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // MARK: - Initializers
    init(video: Video) {
        self.video = video
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
        addObserverForLoadingProgress()
        loadVideo()
    }
    
    // MARK: - Interface Configuration
    private func configureInterface() {
        view.backgroundColor = .main
        
        configureNavigationBar()
        configureWebView()
        configureLoadingBar()
    }
    
    private func configureNavigationBar() {
        title = video.title
        
        navigationController?.navigationBar.tintColor = .accent
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
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
            loadingBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    
    // MARK: - Loading Video
    private func loadVideo() {
        guard let url = URL(string: video.player) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions
    @objc private func shareButtonTapped() {
        guard let url = URL(string: video.player) else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

