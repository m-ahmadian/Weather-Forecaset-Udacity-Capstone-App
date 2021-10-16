//
//  InitialViewController.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-05.
//

import UIKit
import CoreData

class InitialViewController: UIViewController {

    // MARK: - Properties
    // A reference to the core data stack
    var dataController: DataController!
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    var cityDataSource: CityDataSource<City, UITableViewCell>!

    // MARK: - Outlets
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // Function to set up fetch request and fetched results controller
    fileprivate func setUpFetchedResultsController() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        setUpCityDataSource(fetchRequest)
    }

    func setUpCityDataSource(_ fetchRequest: NSFetchRequest<City>) {

        cityDataSource = CityDataSource(tableView: tableView, tableViewCellIdentifier: "cityCell", managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest, configure: { cell, aCity in
            cell.textLabel?.text = aCity.name
            cell.detailTextLabel?.text = aCity.country
        }, editActions: { (aCity) -> [UITableViewRowAction] in
            let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { rowAction, indexPath in
                let cityToDelete = aCity
                self.dataController.viewContext.delete(cityToDelete)
                try? self.dataController.viewContext.save()
                if self.tableView.numberOfRows(inSection: 0) == 0 {
                    self.updateRefreshButtonState()
                }
            }
            deleteButton.backgroundColor = .red
            return [deleteButton]
        })
        tableView.delegate = cityDataSource
        tableView.dataSource = cityDataSource
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite Cities"
        // Set the delegate
        searchView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call the method to configure out fetchedResultsController
        setUpFetchedResultsController()
        // Delete the search text and reload tableView whenever this view is about to appear
        searchView.text = ""
        tableView.reloadData()
        updateRefreshButtonState()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Inject the dependency of core data stack and passing the selected city if needed, based on the segue destination
        if segue.identifier == "SearchViewController" {
            let searchVC = segue.destination as? SearchViewController
            searchVC?.dataController = dataController
        }
        else if segue.identifier == "DetailViewController" {
            let detailVC = segue.destination as? DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC?.city = self.cityDataSource.fetchedResultsController.object(at: indexPath)
            }
        }
    }

    // MARK: - Helper Methods
    func updateRefreshButtonState() {
        guard tableView.numberOfSections != 0 else {
            refreshButton.isHidden = true
            return
        }
        UIView.transition(with: refreshButton, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.refreshButton.isHidden = self.cityDataSource.fetchedResultsController.sections?[0].numberOfObjects == 0
        })
    }
}

// MARK: - Extension for SearchBarDelegate method
extension InitialViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Add a predicate to fetch city names that begin with the search text, if the text is not empty
        let predicate: NSPredicate?
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name BEGINSWITH[C] %@", searchText)
        } else {
            predicate = nil
        }
        fetchRequest.predicate = predicate
        setUpCityDataSource(fetchRequest)
        tableView.reloadData()
    }
}
