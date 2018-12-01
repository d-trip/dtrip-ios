import UIKit

extension UIImage {

    // MARK: - Images

    enum EmptyState {
        static let post = UIImage(named: "noPostImage")
        static let avatar = UIImage(named: "noAvatar")
    }
    
    enum TabBar {
        static let map = UIImage(named: "map")
        static let mapSelected = UIImage(named: "map_selected")
        static let feed = UIImage(named: "feed")
        static let feedSelected = UIImage(named: "feed_selected")
    }

    enum Feed {
        enum Post {
            static let likeButton = UIImage(named: "heart")
            static let shareButton = UIImage(named: "share")
        }
    }

    enum Common {
        static let whiteRoundCross = UIImage(named: "white-round-cross-24px")?.withRenderingMode(.alwaysTemplate)
    }

    // MARK: - Tools

    static func makeColoredImage(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
