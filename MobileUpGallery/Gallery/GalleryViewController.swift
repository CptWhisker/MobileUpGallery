import UIKit

final class GalleryViewController: UIViewController {
    // MARK: - Mock Video
    let mockVideo = Video(
        title: "Анимированные vmoji в VK Звонках",
        player: "https://vk.com/video_ext.php?oid=-22822305&id=456242110&hash=e037414127166efe&__ref=vk.api&api_hash=1677682946870d1f6fa590a9b323_HAZDCNJWG42DA",
        image: [PreviewImage(url: "https://i.mycdn.me/getVideoPreview?id=3376734079543&idx=0&type=39&tkn=WK9Wdwpqr6z6g9umM95aW3Ch3QM&fn=vid_w")]
    )
    
    // MARK: - Properties
    private var photos = [Photo]()
    private var videos = [Video]()
    private let photosNetworkService: NetworkService<Photo>
    private let videosNetworkService: NetworkService<Video>
    private var isLoadingPhotos = false
    private var isLoadingVideos = false
    
    // MARK: - UI Elements
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Фото", "Видео"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    private lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .main
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collectionView
    }()
    private lazy var videosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .main
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        return collectionView
    }()
    
    // MARK: - Initializers
    init() {
        let photosConfiguration: PhotosRequestConfiguration = .mobileUpOffice
        let videosConfiguration: VideoRequestConfiguration = .standard
        
        self.photosNetworkService = NetworkService(configuration: photosConfiguration)
        self.videosNetworkService = NetworkService(configuration: videosConfiguration)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
        loadPhotos()
//        loadVideos()
//        loadMockVideos()
    }
    
    // MARK: - Interface Configuration
    private func configureInterface() {
        view.backgroundColor = .main
        
        configureNavigationBar()
        configureSegmentedControl()
        configureCollectionViews()
    }
    
    private func configureNavigationBar(){
        title = "MobileUp Gallery"
        
        navigationController?.navigationBar.tintColor = .accent
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.backButtonTitle = ""
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCollectionViews() {
        view.addSubview(photosCollectionView)
        view.addSubview(videosCollectionView)
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            videosCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            videosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        videosCollectionView.isHidden = true
    }
    
    // MARK: - Loading Data
    private func loadPhotos() {
        guard !isLoadingPhotos else { return }
                        
        isLoadingPhotos = true
        
        photosNetworkService.fetchItems() { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoadingPhotos = false
                switch result {
                case .success(let newPhotos):
                    self.photos.append(contentsOf: newPhotos)
                    self.photosCollectionView.reloadData()
                    self.photosNetworkService.increaseOffset()
                case .failure(let error):
                    self.handleNetworkError(error)
                    print("photosNetworkService ERROR", error)
                }
            }
        }
    }
    
    private func loadVideos() {
        guard !isLoadingVideos else { return }
        
        isLoadingVideos = true
        
        videosNetworkService.fetchItems() { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoadingVideos = false
                switch result {
                case .success(let newVideos):
                    self.videos.append(contentsOf: newVideos)
                    self.videosCollectionView.reloadData()
                    self.videosNetworkService.increaseOffset()
                case .failure(let error):
                    self.handleNetworkError(error)
                    print("videosNetworkService ERROR", error)
                }
            }
        }
    }
    
    private func loadMockVideos() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            for _ in 0...5 {
                self.videos.append(self.mockVideo)
            }
            
            self.videosCollectionView.reloadData()
        }
    }
    
    // MARK: - NetworkError Handling
    private func handleNetworkError(_ error: Error) {
        let title = "Error"
        var message: String
        
        let actions: [AlertActions]
        
        guard let networkError = error as? NetworkServiceError  else {
            message = "Unexpected error while fetching data from server"
            actions = [.reload, .relogin]
            showAlert(title: title, message: message, actions: actions)
            return
        }
        
            switch networkError {
            case .dataTaskError:
                message = "Failed to load data. Please check your internet connection and try again."
                actions = [.reload]
            case .responseError:
                message = "Received an invalid response from the server. Please try again later."
                actions = [.reload]
            case .dataFetchError:
                message = "Failed to fetch the data. Please try again."
                actions = [.reload]
            case .decodingError:
                message = "Authorization token invalid or expired. Please relogin"
                actions = [.relogin, .reload]
            }
        
        showAlert(title: title, message: message, actions: actions)
    }
    
    // MARK: - Showing Alert
    private func showAlert(title: String, message: String, actions: [AlertActions]) {
        AlertPresenterService.shared.showAlert(on: self, title: title, message: message, actions: actions)
    }
    
    // MARK: - Logging Out
    private func logout() {
        AccessTokenStorage.shared.accessToken = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let authViewController = AuthViewController()
        window.rootViewController = authViewController
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionFlipFromRight,
            animations: nil,
            completion: nil
        )
}
    
    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        photosCollectionView.isHidden = sender.selectedSegmentIndex != 0
        videosCollectionView.isHidden = sender.selectedSegmentIndex != 1
        
        if sender.selectedSegmentIndex == 1 && videos.isEmpty {
//            loadVideos()
            loadMockVideos()
        }
    }
    
    @objc private func logoutButtonTapped() {
        logout()
    }
    
    // MARK: - Public Methods
    func reloadTapped() {
        if segmentedControl.selectedSegmentIndex == 0 {
            loadPhotos()
        } else {
//            loadVideos()
            loadMockVideos()
        }
    }
    
    func logoutTapped() {
        logout()
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photosCollectionView {
            return photos.count
        } else {
            return videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = collectionView == photosCollectionView ? "PhotoCell" : "VideoCell"
        
        if reuseIdentifier == "PhotoCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell else {
                print("ERROR")
                return UICollectionViewCell()
            }
            
            let photo = photos[indexPath.item]
            cell.setPhoto(photo)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VideoCell else {
            print("ERROR")
            return UICollectionViewCell()
        }
        
        let video = videos[indexPath.item]
        cell.setPhotoAndTitle(from: video)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photosCollectionView {
            let side = (collectionView.frame.width / 2) - 2
            return CGSize(width: side, height: side)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: width * 0.56)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == photosCollectionView {
            if indexPath.item == photos.count - 6 {
                loadPhotos()
            }
        } else {
            if indexPath.item == videos.count - 5 {
//                loadVideos()
                loadMockVideos()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photosCollectionView {
            let photo = photos[indexPath.item]
            let photoViewController = PhotoViewController(photo: photo)
            navigationController?.pushViewController(photoViewController, animated: true)
        } else {
            let video = videos[indexPath.item]
            let videoViewController = VideoViewController(video: video)
            navigationController?.pushViewController(videoViewController, animated: true)
        }
    }
}
