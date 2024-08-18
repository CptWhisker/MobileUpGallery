import UIKit

final class VideoTitleLabel: UILabel {
    // MARK: - Properties
    let textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    
    // MARK: - Methods
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}
