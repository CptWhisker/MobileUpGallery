import UIKit

final class VideoTitleLabel: UILabel {
    let textInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    
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
