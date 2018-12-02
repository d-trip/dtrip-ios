import UIKit

final class GradientView: UIView {

    enum GradientDirection {
        case top
        case bottom
    }

    private var layerColors: [UIColor] = []

    func configure(_ direction: GradientDirection) {
        layerColors = makeColors(direction)
        setNeedsLayout()
    }

    private func makeColors(_ direction: GradientDirection) -> [UIColor] {
        let layerColors: [UIColor]
        switch direction {
        case .top:
            layerColors = [
                UIColor.black.withAlphaComponent(0.150),
                UIColor.black.withAlphaComponent(0.005),
            ]
        case .bottom:
            layerColors = [
                UIColor.black.withAlphaComponent(0.005),
                UIColor.black.withAlphaComponent(0.150),
            ]
        }
        return layerColors
    }

    // MARK: - Laying out Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }

        let gradient = CAGradientLayer()
        gradient.colors = layerColors.map { $0.cgColor }
        gradient.frame = bounds

        layer.addSublayer(gradient)
    }
}
