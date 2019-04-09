import Foundation

/// A box that allows us to weakly hold on to an object
private final class Closure<T> {
    var closure: (T) -> Void

    init(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}

/// Stores a value of type T, and allows objects to subscribe to
/// be notified with this value is changed.
final class SubscribableValue<T> {

    private var subscriptions = NSMapTable<AnyObject, Closure<T>>.weakToStrongObjects()

    let dispatchQueue = DispatchQueue(label: "theme.queue", attributes: .concurrent)

    var value: T {
        didSet {
            // get the value on the queue to ensure we don't access the value while its being written
            let value = dispatchQueue.sync { self.value }
            let closures = subscriptions.objectEnumerator()?.allObjects as? [Closure<T>] ?? []
            closures.forEach { $0.closure(value) }
        }

    }

    init(value: T) {
        self.value = value
    }

    func subscribe(_ object: AnyObject, using handler: @escaping (T) -> Void) {
        subscriptions.setObject(Closure<T>(closure: handler), forKey: object)
    }

}
