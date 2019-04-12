import UIKit
import Photos

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        test()
        return true
    }

    func test() {
        let cats = CatProvider().fetch()

        var options = ImageFetchOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        options.resizeMode = .none

        options.progressHandler = { result in
            switch result {
            case let .success(progress):
                print(progress)
            case let .failure(error):
                print(error)
            }
        }

        let assets = ImageAsset.fetchAssets(forUrls: cats.map { $0.url })

        let id = ImageManager.default.requestImage(for: assets.first!, targetSize: .zero, contentMode: .aspectFit, options: options) { result in
            switch result {
            case let .success(response):
                print(response.source)
            case let .failure(error):
                print(error)
            case let .cancelled(id):
                print(id == InvalidImageRequestId)
            }
        }

        ImageManager.default.cancelImageRequest(id)

    }
}

final class CatProvider {

    struct Cat: Codable {
        var id: String
        var url: URL
    }

    func fetch() -> [Cat] {
        do {
            let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=1")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Cat].self, from: data)
        } catch {
            return []
        }
    }

}
