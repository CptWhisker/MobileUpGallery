import UIKit

final class GalleryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(AccessTokenStorage.shared.accessToken)
        view.backgroundColor = .green
    }
}
