import UIKit
import Kingfisher

final class VideoCell: UICollectionViewCell {
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cellBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.layer.cornerRadius = 16
        label.backgroundColor = .titleBackground
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface Configuration
    private func configureCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66)
        ])
    }
    
    // MARK: - Private Methods
    private func setThumbnail(for video: Video) {
        guard let urlString = video.previewURL,
              let url = URL(string: urlString)
        else { return }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    private func setTitle(for title: Video) {
        titleLabel.text = title.title
    }
    
    // MARK: - Public Methods
    func setPhotoAndTitle(from video: Video) {
        setThumbnail(for: video)
        setTitle(for: video)
    }
}
