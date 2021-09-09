//
//  SearchViewController.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-05.
//

import CoreData
import UIKit

class SearchViewController: UIViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }


    // MARK: - Properties
    // A instance of core data stack that is injected in the presenting view (prepare for segue)
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<City>!

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // Function to set up fetch request and fetched results controller
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        // Set the delegate to self
        fetchedResultsController.delegate = self

        // Perform fetch on fetchedResultsController with error handling
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegates and fetchedResultsController
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setUpFetchedResultsController()
    }

    // MARK: - Helper Method

    // Method to add the selected city to the context and persist the data to the store
    func addCity(name: String) {
        // Instantiate the managed object associated with the main context
        let city = City(context: dataController.viewContext)
        // Separate citty name from province and country in the response string
        city.name = name.components(separatedBy: ",")[0]
        city.country = name.components(separatedBy: ",")[2]
        try? dataController.viewContext.save()

        // Configure and present the alertVC
        let alertVC = UIAlertController(title: "Successful", message: "\(city.name ?? "") has been added to the list of your cities", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            // Pop to the root vc after data being persisted and user is presented
            self?.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okAction)
        alertVC.view.layoutIfNeeded()
        present(alertVC, animated: true, completion: nil)
    }

}
