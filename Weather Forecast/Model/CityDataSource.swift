//
//  CityDataSource.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-12.
//

import CoreData
import Foundation
import UIKit

class CityDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var tableView: UITableView!
    var tableViewCellIdentifier: String!
    var segueIdentifier: String!
    var managedObjectContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<ObjectType>!
    var fetchedResultsController: NSFetchedResultsController<ObjectType>!
    var configure: (CellType, ObjectType) -> Void
    var selectCell: (() -> Void)?
    var editActions: (ObjectType) -> [UITableViewRowAction]

    init(tableView: UITableView, tableViewCellIdentifier: String, segueIdentifier: String, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ObjectType>, configure: @escaping (CellType, ObjectType) -> Void, selectCell: (() -> Void)? = nil, editActions: @escaping (ObjectType) -> [UITableViewRowAction]) {

        self.tableView = tableView
        self.tableViewCellIdentifier = tableViewCellIdentifier
        self.managedObjectContext = managedObjectContext
        self.fetchRequest = fetchRequest
        self.configure = configure
        self.selectCell = selectCell
        self.editActions = editActions

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    // MARK: - UITableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anObject = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! CellType

        // Configure cell
        configure(cell, anObject)

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let anObject = fetchedResultsController.object(at: indexPath)
        let rowActionsArray = editActions(anObject)

        return rowActionsArray
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell?()
    }

    // MARK: - NSFetchedResultsControllerDelegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }
}
