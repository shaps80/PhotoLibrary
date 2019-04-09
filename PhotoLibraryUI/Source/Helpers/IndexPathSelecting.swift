//
//  IndexPathSelection.swift
//  Credit: https://www.raizlabs.com/dev/2016/05/smarter-animated-row-deselection-ios/
//
//  This version by Shahpour Benkau on 21/05/2017 – based on the version from raizlabs.com
//

import UIKit
import Composed

// Represents a view that provides indexPath selection (e.g. UITableView, UICollectionView)
internal protocol IndexPathSelectionProviding {
    var selectedIndexPaths: [IndexPath] { get }
    func deselect(indexPath: IndexPath, animated: Bool)
    func select(indexPath: IndexPath, animated: Bool)
}

extension UITableView: IndexPathSelectionProviding {
    internal var selectedIndexPaths: [IndexPath] {
        return indexPathsForSelectedRows ?? []
    }

    internal func select(indexPath: IndexPath, animated: Bool) {
        selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }

    internal func deselect(indexPath: IndexPath, animated: Bool) {
        deselectRow(at: indexPath, animated: animated)
    }
}

extension UICollectionView: IndexPathSelectionProviding {
    internal var selectedIndexPaths: [IndexPath] {
        return indexPathsForSelectedItems ?? []
    }

    internal func select(indexPath: IndexPath, animated: Bool) {
        selectItem(at: indexPath, animated: animated, scrollPosition: [])
    }

    internal func deselect(indexPath: IndexPath, animated: Bool) {
        deselectItem(at: indexPath, animated: animated)
    }
}

// Represents a view that hosts an indexPath selection provider.
protocol IndexPathSelectionHosting {
    var indexPathSelectionProvider: IndexPathSelectionProviding? { get }
    var transitionCoordinator: UIViewControllerTransitionCoordinator? { get }
}

extension UITableViewController: IndexPathSelectionHosting {
    var indexPathSelectionProvider: IndexPathSelectionProviding? {
        return tableView
    }
}

extension UICollectionViewController: IndexPathSelectionHosting {
    var indexPathSelectionProvider: IndexPathSelectionProviding? {
        return collectionView
    }
}

extension DataSourceViewController: IndexPathSelectionHosting {
    var indexPathSelectionProvider: IndexPathSelectionProviding? {
        return collectionView
    }
}

/**
 Provides the default implementation for clearing the selection during an interactive gesture.
 This also handles cancelled interactions.

 Usage:
 func viewWillAppear(animated: Bool) {
 super.viewWillAppear(animated: animated)
 clearSelection()
 }

 If you're using something other than a UITableViewController or UICollectionViewController, you can opt-in to this same protocol as such:
 extension MyViewController: IndexPathSelectionHosting { }
 */
extension IndexPathSelectionHosting {

    internal func clearSelection() {
        guard let indexPaths = indexPathSelectionProvider?.selectedIndexPaths else { return }

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                // Deselect the cells, with animations enabled if this is an animated transition
                indexPaths.forEach {
                    self.indexPathSelectionProvider?.deselect(indexPath: $0, animated: context.isAnimated)
                }
            }, completion: { context in
                // If the transition was cancel, reselect the rows that were selected before,
                // so they are still selected the next time the same animation is triggered
                if context.isCancelled {
                    indexPaths.forEach {
                        self.indexPathSelectionProvider?.select(indexPath: $0, animated: false)
                    }
                }
            })
        } else { // If this isn't a transition coordinator, just deselect the rows without animating
            indexPathSelectionProvider?.selectedIndexPaths.forEach {
                indexPathSelectionProvider?.deselect(indexPath: $0, animated: false)
            }
        }
    }

}
