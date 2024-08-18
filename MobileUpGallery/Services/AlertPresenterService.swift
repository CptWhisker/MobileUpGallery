import UIKit

// MARK: - AlertActions Enum
enum AlertActions {
    case reload, cancel, dismiss, relogin
}

final class AlertPresenterService {
    // MARK: - Properties
    static let shared = AlertPresenterService()
    
    // MARK: - Public Methods
    func showAlert(on viewController: UIViewController, title: String, message: String, actions: [AlertActions]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            switch action {
                
            case .reload:
                alert.addAction(UIAlertAction(title: "Reload", style: .default) { _ in
                    if let webViewVC = viewController as? WebViewViewController {
                        webViewVC.reloadTapped()
                    } else if let galleryVC = viewController as? GalleryViewController {
                        galleryVC.reloadTapped()
                    } else if let photoVC = viewController as? PhotoViewController {
                        photoVC.reloadTapped()
                    } else if let videoVC = viewController as? VideoViewController {
                        videoVC.reloadTapped()
                    }
                })
                
            case .cancel:
                alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                    if let webViewVC = viewController as? WebViewViewController {
                        webViewVC.dismiss(animated: true, completion: nil)
                    } else if let viewController = viewController.navigationController {
                        viewController.popViewController(animated: true)
                    }
                })
                
            case .dismiss:
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                
            case .relogin:
                alert.addAction(UIAlertAction(title: "Relogin", style: .destructive) { _ in
                    if let galleryVC = viewController as? GalleryViewController {
                        galleryVC.logoutTapped()
                    }
                })
            }
        }
        
        viewController.present(alert, animated: true)
    }
}

