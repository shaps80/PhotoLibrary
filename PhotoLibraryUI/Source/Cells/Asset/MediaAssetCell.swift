import UIKit
import Composed
import Photos
import CoreMedia

protocol AssetCellDelegate: class {
    func willPrepareForReuse(cell: MediaAssetCell, asset: PHAsset, maximumSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions)
}

final class MediaAssetCell: UICollectionViewCell, ReusableViewNibLoadable, DataSourceEditableView, UIGestureRecognizerDelegate {

    weak var delegate: AssetCellDelegate?

    @IBOutlet private(set) internal var imageView: MediaArtworkImageView!
    @IBOutlet private var titleLabel: MediaSecondaryLabel!
    @IBOutlet private var ratioConstraint: NSLayoutConstraint!

    private var progressView: PieProgressView?

    @IBOutlet private var selectionButton: MediaEditingButton!
    private(set) var isEditing: Bool = false

    private(set) var asset: PHAsset?

    var maximumSize: CGSize {
        let dimension: CGFloat = 200
        return CGSize(width: dimension, height: dimension)
    }

    var imageOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        return options
    }

    override var isSelected: Bool {
        didSet {
            selectionButton.isSelected = isEditing ? isSelected : false
            imageView.alpha = isEditing ? isSelected ? 0.5 : 1 : 1
        }
    }

    internal enum State {
        case normal
        case preparing
        case downloading(CGFloat)
    }

    internal override func awakeFromNib() {
        super.awakeFromNib()

        setState(.normal)
        selectionButton.isHidden = true

//        addGestureRecognizer(previewGesture)
    }

    func setEditing(_ editing: Bool, animated: Bool) {
        isEditing = editing
        selectionButton.isHidden = !isEditing
    }

    internal func setState(_ state: State) {
        switch state {
        case .normal:
            progressView?.progress = 0
            imageView.alpha = 1
            removeProgress()
        case .preparing:
            addProgress()
            progressView?.progress = 0.01
            imageView.alpha = 0.2
        case let .downloading(progress):
            addProgress()
            let progress = max(progress, 0.01)
            progressView?.progress = progress
            imageView.alpha = 0.2
        }
    }

    private func addProgress() {
        guard progressView == nil else { return }

        let view = PieProgressView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.strokeThickness = 1.5
        view.margin = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: view.bounds.width),
            view.heightAnchor.constraint(equalToConstant: view.bounds.height),
            view.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])

        progressView = view
    }

    private func removeProgress() {
        progressView?.removeFromSuperview()
        progressView = nil
    }

    internal func prepare(asset: PHAsset) {
        self.asset = asset

        let time = CMTime(seconds: asset.duration, preferredTimescale: CMTimeScale(600))
        titleLabel.text = TimecodeFormatter(time: time).shortFormat
        
        let mediaType = asset.mediaType

        let requiresConstraintUpdate =
            traitCollection.horizontalSizeClass == .regular
                && mediaType == .video
                && ratioConstraint.multiplier == 1

        if requiresConstraintUpdate {
            ratioConstraint.isActive = false
            imageView.removeConstraint(ratioConstraint)
        }
        
        switch mediaType {
        case .video:
            titleLabel.isHidden = false
            contentView.alpha = 1

            if requiresConstraintUpdate {
                ratioConstraint = NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 9 / 16, constant: 0)
            }
        default:
            titleLabel.isHidden = true
            ratioConstraint = NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0)
        }

        imageView.layoutIfNeeded()

        if requiresConstraintUpdate {
            ratioConstraint.isActive = true
        }

        guard accessibilityElements == nil else { return }
        let element = UIAccessibilityElement(accessibilityContainer: self)

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.collapsesLargestUnit = true
        formatter.unitsStyle = .abbreviated

        element.isAccessibilityElement = true
        element.accessibilityTraits = .button
        element.accessibilityLabel = NSLocalizedString("Video", comment: "Voiceover")
        element.accessibilityValue = formatter.string(from: asset.duration)

        accessibilityElements = [element]
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        if let asset = asset {
            delegate?.willPrepareForReuse(cell: self, asset: asset, maximumSize: maximumSize, contentMode: .aspectFill, options: imageOptions)
        }

        imageView.alpha = 1
        contentView.alpha = 1
        imageView.image = nil
        titleLabel.text = nil
        titleLabel.isHidden = true
        selectionButton.isHidden = true
        asset = nil

        accessibilityElements = nil
    }

//    private lazy var previewGesture: UILongPressGestureRecognizer = {
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showPreview(_:)))
//        gesture.delaysTouchesBegan = true
//        return gesture
//    }()
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }

//    private weak var playerView: PlayerView?
//    @objc func showPreview(_ gesture: UILongPressGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            guard let asset = asset else { return }
//
//            let view = PlayerView(frame: imageView.bounds)
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.playerLayer.videoGravity = .resizeAspectFill
//
//            imageView.addSubview(view)
//            playerView = view
//
//            NSLayoutConstraint.activate([
//                view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
//                view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
//                view.topAnchor.constraint(equalTo: imageView.topAnchor),
//                view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
//            ])
//
//            MediaImageManager.shared.request(preview: asset) { result in
//                switch result {
//                case let .success(item):
//                    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
//                    self.playerView?.player = AVPlayer(playerItem: item)
//                    self.playerView?.player?.playImmediately(atRate: 2)
//                case .failure:
//                    print("Failed to load preview for asset: \(asset)")
//                }
//            }
//        case .changed:
//            break
//        default:
//            imageView.layer.add(CATransition(), forKey: nil)
//            playerView?.pause()
//            playerView?.removeFromSuperview()
//        }
//    }

    private var _accessibilityElements: [Any]?
    override var accessibilityElements: [Any]? {
        set { _accessibilityElements = newValue }
        get {
            let elements = _accessibilityElements
            if let element = elements?.first as? UIAccessibilityElement {
                element.accessibilityFrameInContainerSpace = contentView.bounds
            }

            return elements
        }
    }

}
