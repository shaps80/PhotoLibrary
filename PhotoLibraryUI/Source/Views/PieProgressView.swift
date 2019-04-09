import UIKit
public typealias View = UIView

extension UIView {
    internal var nonOptionalLayer: CALayer {
        return layer
    }
}

@IBDesignable
public final class PieProgressView: View, Themed {

    @IBInspectable
    public var hidesWhenMax: Bool = true {
        didSet { invalidate() }
    }

    @IBInspectable
    public var hidesWhenMin: Bool = true {
        didSet { invalidate() }
    }

    private var _progress: CGFloat = 0 {
        didSet { invalidate() }
    }

    @IBInspectable
    public var progress: CGFloat {
        get { return _progress }
        set { _progress = min(1, max( 0, newValue)) }
    }

    @IBInspectable
    public var strokeThickness: CGFloat = 2 {
        didSet { invalidate() }
    }

    @IBInspectable
    public var margin: CGFloat = 2 {
        didSet { invalidate() }
    }

    private var progressLayer: PieProgressLayer!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        invalidate()
    }

}

extension PieProgressView {

    private func commonInit() {
        progressLayer = PieProgressLayer()
        nonOptionalLayer.addSublayer(progressLayer)

        invalidate()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        tintColor = theme.tintColor
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        invalidate()
    }

    private func invalidate() {
        nonOptionalLayer.borderColor = tintColor.cgColor
        nonOptionalLayer.borderWidth = strokeThickness
        nonOptionalLayer.cornerRadius = bounds.width / 2
        progressLayer.color = tintColor.cgColor
        progressLayer.progress = progress
        progressLayer.margin = margin

        if hidesWhenMin, progress == 0 {
            isHidden = progress == 0
        } else if hidesWhenMax, progress == 1 {
            isHidden = progress == 1
        } else {
            isHidden = false
        }
    }

}
