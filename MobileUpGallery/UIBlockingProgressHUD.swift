import UIKit
import ProgressHUD

final class LoadingHUD {
    static func showAnimation() {
        DispatchQueue.main.async {
            ProgressHUD.animate()
        }
    }
    
    static func dismissAnimation() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
}
