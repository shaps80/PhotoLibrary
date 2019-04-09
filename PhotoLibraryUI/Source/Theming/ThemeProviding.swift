import UIKit

final class MediaThemeProvider: ThemeProviding {

    static let shared: MediaThemeProvider = .init()
    private var theme: SubscribableValue<MediaPickerTheme>

    static let availableThemes: [MediaPickerTheme.Type] = [
        MediaPickerLightTheme.self,
        MediaPickerDarkTheme.self,
        MediaPickerBlackTheme.self
    ]

    static let defaultTheme = MediaPickerLightTheme.self

    var currentTheme: MediaPickerTheme {
        get { return theme.value }
        set {
            apply(newValue)
            UserDefaults.standard.set(type(of: newValue).id, forKey: "current-theme")
        }
    }

    init() {
        let id = UserDefaults.standard.value(forKey: "current-theme") as? String
        let current = type(of: self).availableThemes.first { $0.id == id } ?? MediaThemeProvider.defaultTheme
        theme = SubscribableValue<Theme>(value: current.init())
    }

    func apply(_ theme: MediaPickerTheme) {
        guard let view = MediaPickerViewController.current?.view else { return }
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.theme.dispatchQueue.sync {
                self?.theme.value = theme
            }
        }, completion: nil)
    }

    func subscribeToChanges(_ object: AnyObject, handler: @escaping (MediaPickerTheme) -> Void) {
        theme.subscribe(object, using: handler)
    }

}

extension Themed where Self: AnyObject {
    var themeProvider: MediaThemeProvider {
        return MediaThemeProvider.shared
    }
}
