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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
