import UIKit
import Kingfisher

final class PhotoViewController: UIViewController {
    //  MARK: - Properties
    let photo: Photo
    private var shareButton: UIBarButtonItem?
    
    // MARK: - UI Elements
    private lazy var photoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    init(photo: Photo) {
        self.photo = photo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureInterface()
        loadAndDisplayImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        LoadingHUD.dismissAnimation()
    }
    
    deinit {
        cleanCache()
    }
    
    // MARK: - Interface Configuration
    private func configureInterface() {
        view.backgroundColor = .main
                
        configureNavigationBar()
        configurePhotoScrollView()
        configurePhotoView()
    }
    
    private func configureNavigationBar() {
        title = photo.formattedDate
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .accent
        
        let shareButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = shareButtonItem
        self.shareButton = shareButtonItem
    }
    
    private func configurePhotoScrollView() {
        view.addSubview(photoScrollView)
                
        NSLayoutConstraint.activate([
            photoScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configurePhotoView() {
        photoScrollView.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: photoScrollView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: photoScrollView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: photoScrollView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: photoScrollView.trailingAnchor)
        ])
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = photoScrollView.minimumZoomScale
        let maxZoomScale = photoScrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = photoScrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        photoScrollView.setZoomScale(scale, animated: false)
        photoScrollView.layoutIfNeeded()
        let newContentSize = photoScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        photoScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func centerImageView() {
        let scrollViewSize = photoScrollView.bounds.size
        let imageViewSize = photoView.frame.size
        
        let verticalPadding = max((scrollViewSize.height - imageViewSize.height) / 2, 0)
        let horizontalPadding = max((scrollViewSize.width - imageViewSize.width) / 2, 0)
        
        photoScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    // MARK: - Loading Photo
    private func loadAndDisplayImage() {
        guard let photoString = photo.largeURL,
              let imageURL = URL(string: photoString) else {
            showAlert(title: "Error", message: "The image URL is invalid", actions: [.cancel])
            return
        }
        
        setShareButtonState(false)
        LoadingHUD.showAnimation()
        
        photoView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self else { return }
            
            LoadingHUD.dismissAnimation()
            self.setShareButtonState(true)
            
            switch result {
            case .success(let imageResult):
                photoView.frame.size = imageResult.image.size
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                showAlert(title: "Error", message: "Error while loading image", actions: [.reload, .cancel])
            }
        }
    }
    
    // MARK: - Showing Alert
    private func showAlert(title: String, message: String, actions: [AlertActions]) {
        AlertPresenterService.shared.showAlert(on: self, title: title, message: message, actions: actions)
    }
    
    // MARK: - Private Methods
    private func setShareButtonState(_ enabled: Bool) {
        shareButton?.isEnabled = enabled
    }
    
    private func cleanCache() {
        guard let photoString = photo.largeURL,
              let imageURL = URL(string: photoString) else {
            return
        }
        
        ImageCache.default.removeImage(forKey: imageURL.absoluteString)
    }
    
    // MARK: - Actions
    @objc private func shareTapped() {
        guard let image = photoView.image else { 
            showAlert(title: "Error", message: "There is no image available to share", actions: [.dismiss])
            return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, activityError in
            guard let self else { return }
            
            if completed {
                if activityType == .saveToCameraRoll {
                    self.showAlert(title: "Success", message: "Photo saved to your gallery", actions: [.dismiss])
                }
            } else if let error = activityError {
                self.showAlert(title: "Error", message: error.localizedDescription, actions: [.dismiss])
            }
        }
    }
    
    // MARK: - Public Methods
    func reloadTapped() {
        loadAndDisplayImage()
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImageView()
    }
}
