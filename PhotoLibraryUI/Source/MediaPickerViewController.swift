import UIKit
import Photos

@objc public protocol MediaPickerDelegate: NSObjectProtocol {
    @objc optional func mediaPicker(_ controller: MediaPickerViewController, didPickMedia media: [PHAsset])
    @objc optional func mediaPickerWasCancelled(_ controller: MediaPickerViewController)
}

public final class MediaPickerViewController: UIViewController {

    // this is a little weird but it is marked weak. Its just so we can 'find' this controller from anywhere.
    static weak var current: MediaPickerViewController?

    private static let allMediaTypes: [PHAssetMediaType] = [.video, .image]
    private static let allMediaSubtypes: [PHAssetMediaSubtype] = [
        .photoDepthEffect, .photoHDR, .photoLive, .photoPanorama,
        .photoScreenshot, .videoHighFrameRate, .videoStreamed, .videoTimelapse
    ]

    public enum ImportMode: UInt {
        case copy
        case open

        public var title: String {
            switch self {
            case .copy: return NSLocalizedString("Copy", comment: "Copies photos to the app")
            case .open: return NSLocalizedString("Open", comment: "Opens photo in the app without copying")
            }
        }
    }

    public enum PickerInterfaceStyle: UInt {
        case light
        case dark
        case black
    }

    public var allowsPickingMultipleItems: Bool = false
    public var interfaceStyle: PickerInterfaceStyle = .dark {
        didSet {
            let theme: MediaPickerTheme

            switch interfaceStyle {
            case .light: theme = MediaPickerLightTheme()
            case .dark: theme = MediaPickerDarkTheme()
            case .black: theme = MediaPickerBlackTheme()
            }

            MediaThemeProvider.shared.apply(theme)
        }
    }

    private var child: UIViewController?
    private var assetOptions: PHFetchOptions? = nil
    private var mode: ImportMode = .copy

    public weak var delegate: MediaPickerDelegate?

    public required init(assetOptions: PHFetchOptions? = nil, in mode: ImportMode) {
        self.assetOptions = assetOptions
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        type(of: self).current = self
        modalPresentationStyle = .pageSheet
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        type(of: self).current = self
        modalPresentationStyle = .pageSheet
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        type(of: self).current = self
        modalPresentationStyle = .pageSheet
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let nav = MediaNavigationController(navigationBarClass: MediaNavigationBar.self, toolbarClass: nil)
        nav.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(nav)
        view.addSubview(nav.view)
        nav.didMove(toParent: self)

        NSLayoutConstraint.activate([
            nav.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nav.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nav.view.topAnchor.constraint(equalTo: view.topAnchor),
            nav.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.backgroundColor = .clear
        child = nav

        let content = MediaContentViewController(assetOptions: assetOptions, mode: mode, imageCache: PHCachingImageManager())
        content.title = NSLocalizedString("Albums", comment: "MediaPickerViewController title")
        content.navigationItem.largeTitleDisplayMode = .always
        nav.pushViewController(content, animated: false)
    }

    public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return child
    }

    public override var childForHomeIndicatorAutoHidden: UIViewController? {
        return child
    }

    public override var childForStatusBarHidden: UIViewController? {
        return child
    }

    public override var childForStatusBarStyle: UIViewController? {
        return child
    }

}
