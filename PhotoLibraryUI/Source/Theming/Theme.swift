import UIKit

protocol Theme {
    var primaryTextColor: UIColor { get }
    var primaryTextColorInverted: UIColor { get }
    var secondaryTextColor: UIColor { get }
    var placeholderTextColor: UIColor { get }
    var placeholderBackgroundColor: UIColor { get }
    var tintColor: UIColor? { get }
    var progressTintColor: UIColor? { get }
    var editingTintColor: UIColor { get }
    var accentColor: UIColor? { get }
    var imageTintColor: UIColor? { get }
    var separatorColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var popoverBackgroundColor: UIColor { get }
    var popoverTintColor: UIColor? { get }
    var selectedBackgroundColor: UIColor { get }
    var navigationBarStyle: UIBarStyle { get }
    var isNavigationTranslucent: Bool { get }
    var barTintColor: UIColor { get }
    var scrollIndicatorStyle: UIScrollView.IndicatorStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var editingStatusBarStyle: UIStatusBarStyle { get }
    var preferredVisualEffect: UIVisualEffect { get }

    static var id: String { get }
    init()
}

struct DarkTheme: Theme {
    var navigationBarStyle: UIBarStyle { return .black }
    var isNavigationTranslucent: Bool { return false }
    var barTintColor: UIColor { return UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1) }

    var backgroundColor: UIColor { return UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1) }
    var popoverBackgroundColor: UIColor { return UIColor(red: 46 / 255, green: 46 / 255, blue: 55 / 255, alpha: 1) }
    var popoverTintColor: UIColor? { return accentColor }
    var placeholderBackgroundColor: UIColor { return UIColor(white: 0.1, alpha: 1) }
    var selectedBackgroundColor: UIColor { return UIColor(white: 1, alpha: 0.1) }
    var separatorColor: UIColor { return UIColor(white: 1, alpha: 0.15) }

    var primaryTextColor: UIColor { return .white }
    var primaryTextColorInverted: UIColor { return .black }
    var secondaryTextColor: UIColor { return UIColor(white: 1, alpha: 0.5) }
    var placeholderTextColor: UIColor { return UIColor(white: 1, alpha: 0.4) }

    var tintColor: UIColor? { return UIColor(red: 234 / 255, green: 1 / 255, blue: 0 / 255, alpha: 1) }
    var progressTintColor: UIColor? { return .white }
    var editingTintColor: UIColor { return .white }
    var accentColor: UIColor? { return UIColor(red: 228 / 255, green: 138 / 255, blue: 24 / 255, alpha: 1) }
    var imageTintColor: UIColor? { return UIColor(white: 1, alpha: 0.7) }

    var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .white }
    var statusBarStyle: UIStatusBarStyle { return .lightContent }
    var editingStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var preferredVisualEffect: UIVisualEffect { return UIBlurEffect(style: .dark) }

    static var id: String { return "com.152percent.pluto.theme.black" }
    init() { }
}

struct BlackTheme: Theme {
    var navigationBarStyle: UIBarStyle { return .black }
    var isNavigationTranslucent: Bool { return false }
    var barTintColor: UIColor { return .black }
    var progressTintColor: UIColor? { return .white }

    var backgroundColor: UIColor { return .black }
    var popoverBackgroundColor: UIColor { return UIColor(red: 46 / 255, green: 46 / 255, blue: 55 / 255, alpha: 1) }
    var popoverTintColor: UIColor? { return accentColor }
    var selectedBackgroundColor: UIColor { return UIColor(white: 1, alpha: 0.1) }

    var primaryTextColor: UIColor { return .white }
    var primaryTextColorInverted: UIColor { return .black }
    var secondaryTextColor: UIColor { return UIColor(white: 1, alpha: 0.5) }
    var placeholderTextColor: UIColor { return UIColor(white: 1, alpha: 0.4) }
    var placeholderBackgroundColor: UIColor { return UIColor(white: 0.1, alpha: 1) }
    var tintColor: UIColor? { return UIColor(red: 234 / 255, green: 1 / 255, blue: 0 / 255, alpha: 1) }
    var editingTintColor: UIColor { return .white }
    var accentColor: UIColor? { return UIColor(red: 201 / 255, green: 116 / 255, blue: 8 / 255, alpha: 1) }
    var imageTintColor: UIColor? { return UIColor(white: 1, alpha: 0.7) }
    var separatorColor: UIColor { return UIColor(white: 1, alpha: 0.2) }
    var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .white }
    var statusBarStyle: UIStatusBarStyle { return .lightContent }
    var editingStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var preferredVisualEffect: UIVisualEffect { return UIBlurEffect(style: .dark) }

    static var id: String { return "com.152percent.pluto.theme.black" }
    init() { }
}

struct LightTheme: Theme {
    var primaryTextColor: UIColor { return .black }
    var primaryTextColorInverted: UIColor { return .white }
    var secondaryTextColor: UIColor { return UIColor(white: 0, alpha: 0.5) }
    var placeholderTextColor: UIColor { return UIColor(white: 0, alpha: 0.4) }
    var placeholderBackgroundColor: UIColor { return UIColor(white: 0.9, alpha: 1) }
    var tintColor: UIColor? { return UIColor(red: 234 / 255, green: 1 / 255, blue: 0 / 255, alpha: 1) }
    var progressTintColor: UIColor? { return .black }
    var editingTintColor: UIColor { return .white }
    var accentColor: UIColor? { return UIColor(red: 201 / 255, green: 116 / 255, blue: 8 / 255, alpha: 1) }
    var imageTintColor: UIColor? { return UIColor(white: 0, alpha: 1) }
    var separatorColor: UIColor { return UIColor(white: 0, alpha: 0.15) }
    var backgroundColor: UIColor { return .white }
    var popoverBackgroundColor: UIColor { return .white }
    var popoverTintColor: UIColor? { return accentColor }
    var selectedBackgroundColor: UIColor { return UIColor(white: 0, alpha: 0.1) }
    var navigationBarStyle: UIBarStyle { return .default }
    var isNavigationTranslucent: Bool { return false }
    var barTintColor: UIColor { return .white }
    var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .black }
    var statusBarStyle: UIStatusBarStyle { return .default }
    var editingStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var preferredVisualEffect: UIVisualEffect { return UIBlurEffect(style: .prominent) }

    static var id: String { return "com.152percent.pluto.theme.light" }
    init() { }
}
