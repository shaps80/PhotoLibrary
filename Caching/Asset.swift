import Foundation
import CoreGraphics

/// Use this to signal that the original image should be returned
public let AssetMaximumSize: CGSize = .zero

public protocol Asset {
    var localIdentifier: String { get }
    var originalUrl: URL { get }
}

internal struct PlaceholderAsset: Asset {
    let localIdentifier: String
    let originalUrl: URL

    init(originalUrl: URL) {
        let uuid = UUID(uuidString: "8106768B-BAA7-48A4-A338-5165FF27E7F4")!
        localIdentifier = uuid.uuidString
        self.originalUrl = originalUrl
    }
}

/// A representation of an image
///
/// You fetch assets to begin working with them. Use the class methods listed in Fetching Assets to retrieve one or more PHAsset instances representing the assets you want to display or edit.
///
/// Assets contain only metadata. The underlying image or video data for any given asset might not be stored on the local device.
public struct ImageAsset: Asset, Codable {

    /// Returns an identifier which persistently identifies the asset
    public let localIdentifier: String
    /// The width, in pixels, of the asset’s image. Returns to AssetUnknownDimension
    public let pixelWidth: Int
    /// The height, in pixels, of the asset’s image. Defaults to AssetUnknownDimension
    public let pixelHeight: Int
    /// The date and time at which the asset was originally created.
    public let creationDate: Date
    /// The date and time at which the asset was last modified.
    public private(set) var modificationDate: Date
    /// The original url used top download the asset's image
    public let originalUrl: URL

    internal init(localIdentifier: String, url: URL, pixelWidth: Int, pixelHeight: Int) {
        self.localIdentifier = localIdentifier
        self.originalUrl = url
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.creationDate = Date()
        self.modificationDate = Date()
    }

    internal mutating func prepareForUpdate() {
        modificationDate = Date()
    }

    public static func fetchAssets(forUrls urls: [URL]) -> [Asset] {
        let decoder = JSONDecoder()

        return urls.map {
            do {
                let data = try Data(contentsOf: assetUrl(for: $0))
                return try decoder.decode(ImageAsset.self, from: data)
            } catch {
                return PlaceholderAsset(originalUrl: $0)
            }
        }
    }

    private static func assetUrl(for remoteUrl: URL) -> URL {
        let assetFilename = remoteUrl.absoluteString.hashed(using: .md5).hashValue(output: .hex)
        return assetsUrl.appendingPathComponent(assetFilename)
    }

    private static var assetsUrl: URL = {
        let manager = FileManager.default
        let cachesUrl = try! manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let assetsUrl = cachesUrl.appendingPathComponent("Assets", isDirectory: true)
        let path = assetsUrl.path

        if !manager.fileExists(atPath: path) {
            try? manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }

        return cachesUrl
    }()

}

extension ImageAsset {

    /// Options for fitting an image’s aspect ratio to a requested size, used by the requestImage(for:targetSize:contentMode:options:resultHandler:) method.
    ///
    /// With either option, the resulting image may not exactly match the target size, depending on the deliveryMode and resizeMode properties of the image request. To serve your request more quickly, Photos may provide a slightly larger image—one that it can generate more easily or one that is already cached.
    public enum ContentMode: String {
        /// Scales the image so that its larger dimension fits the target size.
        ///
        /// Use this option when you want the entire image to be visible, such as when presenting it in a view with the UIView.ContentMode.scaleAspectFit content mode.
        case aspectFit = "aspectFit"
        /// Scales the image so that it completely fills the target size.
        ///
        /// Use this option when you want the image to completely fill an area, such as when presenting it in a view with the UIView.ContentMode.scaleAspectFill content mode.
        case aspectFill = "aspectFill"

        /// Fits the image to the requested size using the default option, .aspectFit
        ///
        /// Use this content mode when requesting a full-sized image using the .maximumSize value for the target size. In this case, the image manager does not scale or crop the image.
        public static let `default` = ContentMode.aspectFit
    }

}

internal extension Asset {

    func requestId(targetSize: CGSize?, contentMode: ImageAsset.ContentMode?) -> ImageRequestId {
        var components = URLComponents(string: "")!
        components.scheme = "asset"
        components.host = localIdentifier
        components.queryItems = []

        if let size = targetSize {
            components.queryItems?.append(
                URLQueryItem(name: "width", value: "\(Int(size.width))")
            )

            components.queryItems?.append(
                URLQueryItem(name: "height", value: "\(Int(size.height))")
            )
        }

        if let mode = contentMode {
            components.queryItems?.append(
                URLQueryItem(name: "mode", value: "\(mode.rawValue)")
            )
        }

        components.queryItems?.sort { $0.name < $1.name }

        let string = components.url!.absoluteString
            .hashed(using: .md5).hashValue(output: .hex)
        let id = BigInt<ImageRequestId>(string, radix: 16)!
        return ImageRequestId(truncatingIfNeeded: id)
    }

}
