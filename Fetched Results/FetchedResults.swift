import Foundation
import CoreData

final class FetchedResults<Object>: NSObject, NSFetchedResultsControllerDelegate where Object: NSManagedObject {

    private var controller: NSFetchedResultsController<Object>!

    init(_ controller: NSFetchedResultsController<Object>) {
        self.controller = controller
        super.init()
        controller.delegate = self
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .delete:
//            operations.append(.deleteIndexPaths([indexPath!]))
//        case .insert:
//            if let dataSource = self.dataSource as? CollectionUIProvidingDataSource,
//                let collectionView = dataSource.collectionView,
//                newIndexPath!.section > collectionView.numberOfSections - 1 {
//                forceReload = true
//                return
//            }
//
//            operations.append(.insertIndexPaths([newIndexPath!]))
//        case .update:
//            operations.append(.updateIndexPaths([indexPath!]))
//        case .move:
//            if indexPath == newIndexPath {
//                operations.append(.updateIndexPaths([indexPath!]))
//            } else {
//                operations.append(.moveIndexPaths([(source: indexPath!, target: newIndexPath!)]))
//            }
//
//        @unknown default:
//            break
//        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

}
