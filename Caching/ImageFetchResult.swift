import Foundation

public struct ImageFetchResult {
    private var assets: [Asset]

    internal init(_ assets: [Asset]) {
        self.assets = assets
    }
}

extension ImageFetchResult: RandomAccessCollection, RangeReplaceableCollection, MutableCollection {

    public init() {
        assets = []
    }

    public var startIndex: Int {
        return assets.startIndex
    }

    public var endIndex: Int {
        return assets.endIndex
    }

    public func index(after i: Int) -> Int {
        return assets.index(after: i)
    }

    public subscript(position: Int) -> Asset {
        get { return assets[position] }
        set { assets[position] = newValue }
    }

    public mutating func replaceSubrange<C: Swift.Collection, R: RangeExpression>(_ subrange: R, with newElements: C)
        where C.Element == Asset, R.Bound == Int {
            assets.replaceSubrange(subrange, with: newElements)
    }

}
