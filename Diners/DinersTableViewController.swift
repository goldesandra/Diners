//
//  DinersTableViewController.swift
//  Diners
//
//  Created by Александра Гольде on 24/01/2017.
//  Copyright © 2017 Александра Гольде. All rights reserved.
//

import UIKit
import CoreData

class DinersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Diner>!
    var searchController: UISearchController!
    var filteredResultArray: [Diner] = []
    var diners: [Diner] = [
//        Diner(name: "1", type: "diner", location: "Moscow, Kotelnicheskaya Embankment, 1", image: "1.jpg", isVisited: false), 
//        Diner(name: "2", type: "diner", location: "Moscow", image: "2.jpg", isVisited: false),
//        Diner(name: "3", type: "diner", location: "Moscow", image: "3.jpg", isVisited: false),
//        Diner(name: "4", type: "diner", location: "Moscow", image: "4.jpg", isVisited: false),
//        Diner(name: "5", type: "diner", location: "Moscow", image: "5.jpg", isVisited: false),
//        Diner(name: "6", type: "diner", location: "Moscow", image: "6.jpg", isVisited: false),
//        Diner(name: "7", type: "diner", location: "Moscow", image: "7.jpg", isVisited: false),
//        Diner(name: "8", type: "diner", location: "Moscow", image: "8.jpg", isVisited: false),
//        Diner(name: "9", type: "diner", location: "Moscow", image: "9.jpg", isVisited: false),
//        Diner(name: "10", type: "diner", location: "Moscow", image: "10.jpg", isVisited: false),
//        Diner(name: "11", type: "diner", location: "Moscow", image: "11.jpg", isVisited: false),
//        Diner(name: "12", type: "diner", location: "Moscow", image: "12.jpg", isVisited: false),
//        Diner(name: "13", type: "diner", location: "Moscow", image: "13.jpg", isVisited: false),
//        Diner(name: "14", type: "diner", location: "Moscow", image: "14.jpg", isVisited: false),
//        Diner(name: "15", type: "diner", location: "Moscow", image: "15.jpg", isVisited: false)
    ]
    
    @IBAction func close(segue: UIStoryboardSegue){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = diners.filter{ (diner) -> Bool in
            return (diner.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.2048259495, green: 0.5862664996, blue: 0.9037620472, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil
        )
        let fetchRequest: NSFetchRequest<Diner> = Diner.fetchRequest()
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors=[sortDescripter]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            fetchResultsController = NSFetchedResultsController(fetchRequest:  fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                diners = fetchResultsController.fetchedObjects!
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasWatched = userDefaults.bool(forKey: "wasWatched")
        guard !wasWatched else {return}
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier:  "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
     // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard  let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete :
            guard  let indexPath = newIndexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update :
            guard  let indexPath = newIndexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        diners = controller.fetchedObjects as! [Diner]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
            return diners.count
    }
    func dinerToDisplayAt(indexPath: IndexPath) -> Diner {
        let diner : Diner
        if searchController.isActive && searchController.searchBar.text != "" {
            diner = filteredResultArray[indexPath.row]
        } else {
            diner = diners[indexPath.row]
        }
        return diner
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DinersTableViewCell
        let diner = dinerToDisplayAt(indexPath: indexPath)
        cell.thumbnailImageView.image = UIImage(data: diner.image as! Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = diner.name
        cell.locationLabel.text = diner.location
        cell.typeLabel.text = diner.type
        cell.accessoryType = diner.isVisited ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let ac = UIAlertController(title: nil, message: "Choose your move" ,  preferredStyle: .actionSheet)
    //        let call = UIAlertAction(title: "Call 8(914)354-212\(indexPath.row)", style: .default){
    //            (action: UIAlertAction) -> Void in
    //            let ac2 = UIAlertController(title: nil, message: "Call reject", preferredStyle: .alert)
    //            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            ac2.addAction(ok)
    //            self.present(ac2, animated: true, completion: nil)
    //        }
    //        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "I wasn't here" : "I was here"
    //        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) {
    //            (action) in
    //            let cell = tableView.cellForRow(at: indexPath)
    //            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
    //            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
    //        }
    //        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //        ac.addAction(cancel)
    //        ac.addAction(call)
    //        ac.addAction(isVisited)
    //        present(ac, animated: true, completion: nil)
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            self.restaurantsNames.remove(at: indexPath.row)
    //            self.restaurantImages.remove(at: indexPath.row)
    //            self.restaurantIsVisited.remove(at: indexPath.row)
    //        }
    //        // tableView.reloadData()
    //        tableView.deleteRows(at: [indexPath], with: .fade)
    //    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .default, title: "Share"){ (action, indexPath) in
            let defaultText = "I'm in" + self.diners[indexPath.row].name! + "right now"
            if let image = UIImage(data: self.diners[indexPath.row].image as! Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Delete"){ (action, indexPath) in
            self.diners.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do{
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destViewController = segue.destination as! DinersDetailViewController
                destViewController.diner = dinerToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

extension DinersTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension DinersTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
