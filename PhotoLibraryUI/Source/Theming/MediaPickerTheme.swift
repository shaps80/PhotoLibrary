import UIKit

public protocol MediaPickerTheme {
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    var placeholderTextColor: UIColor { get }
    var placeholderBackgroundColor: UIColor { get }
    var tintColor: UIColor? { get }
    var imageTintColor: UIColor? { get }
    var separatorColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var navigationBarStyle: UIBarStyle { get }
    var isNavigationTranslucent: Bool { get }
    var barTintColor: UIColor { get }
    var scrollIndicatorStyle: UIScrollView.IndicatorStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }

    static var id: String { get }
    init()
}

public struct MediaPickerDarkTheme: MediaPickerTheme {
    public var navigationBarStyle: UIBarStyle { return .black }
    public var isNavigationTranslucent: Bool { return false }
    public var barTintColor: UIColor { return UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1) }

    public var backgroundColor: UIColor { return UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1) }
    public var placeholderBackgroundColor: UIColor { return UIColor(white: 0.1, alpha: 1) }
    public var selectedBackgroundColor: UIColor { return UIColor(white: 1, alpha: 0.1) }
    public var separatorColor: UIColor { return UIColor(white: 1, alpha: 0.15) }

    public var primaryTextColor: UIColor { return .white }
    public var primaryTextColorInverted: UIColor { return .black }
    public var secondaryTextColor: UIColor { return UIColor(white: 1, alpha: 0.5) }
    public var placeholderTextColor: UIColor { return UIColor(white: 1, alpha: 0.4) }

    public var tintColor: UIColor? { return .blue }
    public var imageTintColor: UIColor? { return UIColor(white: 1, alpha: 0.7) }

    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .white }
    public var statusBarStyle: UIStatusBarStyle { return .lightContent }

    public static var id: String { return "com.152percent.media-picker.theme.dark" }
    public init() { }
}

public struct MediaPickerBlackTheme: MediaPickerTheme {
    public var navigationBarStyle: UIBarStyle { return .black }
    public var isNavigationTranslucent: Bool { return false }
    public var barTintColor: UIColor { return .black }

    public var backgroundColor: UIColor { return .black }
    public var selectedBackgroundColor: UIColor { return UIColor(white: 1, alpha: 0.1) }

    public var primaryTextColor: UIColor { return .white }
    public var secondaryTextColor: UIColor { return UIColor(white: 1, alpha: 0.5) }
    public var placeholderTextColor: UIColor { return UIColor(white: 1, alpha: 0.4) }
    public var placeholderBackgroundColor: UIColor { return UIColor(white: 0.1, alpha: 1) }
    public var tintColor: UIColor? { return UIColor(red: 234 / 255, green: 1 / 255, blue: 0 / 255, alpha: 1) }
    public var imageTintColor: UIColor? { return UIColor(white: 1, alpha: 0.7) }
    public var separatorColor: UIColor { return UIColor(white: 1, alpha: 0.2) }
    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .white }
    public var statusBarStyle: UIStatusBarStyle { return .lightContent }

    public static var id: String { return "com.152percent.media-picker.theme.black" }
    public init() { }
}

public struct MediaPickerLightTheme: MediaPickerTheme {
    public var primaryTextColor: UIColor { return .black }
    public var secondaryTextColor: UIColor { return UIColor(white: 0, alpha: 0.5) }
    public var placeholderTextColor: UIColor { return UIColor(white: 0, alpha: 0.4) }
    public var placeholderBackgroundColor: UIColor { return UIColor(white: 0.9, alpha: 1) }
    public var tintColor: UIColor? { return UIColor(red: 234 / 255, green: 1 / 255, blue: 0 / 255, alpha: 1) }
    public var imageTintColor: UIColor? { return UIColor(white: 0, alpha: 1) }
    public var separatorColor: UIColor { return UIColor(white: 0, alpha: 0.15) }
    public var backgroundColor: UIColor { return .white }
    public var selectedBackgroundColor: UIColor { return UIColor(white: 0, alpha: 0.1) }
    public var navigationBarStyle: UIBarStyle { return .default }
    public var isNavigationTranslucent: Bool { return true }
    public var barTintColor: UIColor { return .white }
    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle { return .black }
    public var statusBarStyle: UIStatusBarStyle { return .default }

    public static var id: String { return "com.152percent.media-picker.theme.light" }
    public init() { }
}
