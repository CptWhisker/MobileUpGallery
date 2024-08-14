import UIKit

final class GalleryViewController: UIViewController {
    private var photos = [Photo]()
    private let photosNetworkService = PhotosNetworkService()
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    private lazy var videosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
        loadPhotos()
    }
    
    private func configureInterface() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureSegmentedControl()
        configureCollectionViews()
    }
    
    private func configureNavigationBar(){
        title = "MobileUp Gallery"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logoutTapped))
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
    
    private func loadPhotos() {
        photosNetworkService.fetchPhotos() { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.photosCollectionView.reloadData()
                case .failure(let error):
                    print("ERROR", error)
                }
            }
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        photosCollectionView.isHidden = sender.selectedSegmentIndex != 0
        videosCollectionView.isHidden = sender.selectedSegmentIndex != 1
    }
    
    @objc private func logoutTapped() {
        if view.backgroundColor != .red {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .white
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = collectionView == photosCollectionView ? "PhotoCell" : "VideoCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = reuseIdentifier == "PhotoCell" ? .yellow : .blue
        return cell
    }
}

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
