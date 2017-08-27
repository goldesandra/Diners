//
//  DinersDetailViewController.swift
//  Diners
//
//  Created by Александра Гольде on 27/01/2017.
//  Copyright © 2017 Александра Гольде. All rights reserved.
//

import UIKit

class DinersDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard let svc = segue.source as? RateViewController else {return}
        guard let rating = svc.dinerRating else {return}
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    var diner : Diner?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [rateButton, mapButton]
        for button in buttons {
            guard let button = button else { break }
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
     
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableViewAutomaticDimension
        
        imageView.image = UIImage(data: diner!.image as! Data)
        tableView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = diner!.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DinersDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Name"
            cell.valueLabel.text = diner!.name
        case 1:
            cell.keyLabel.text = "Type"
            cell.valueLabel.text = diner!.type
        case 2:
            cell.keyLabel.text = "Location"
            cell.valueLabel.text = diner!.location
        case 3:
            cell.keyLabel.text = "Was I here?"
            cell.valueLabel.text = diner!.isVisited ? "Yes" : "No"
        default:
            break
        }
        diner!.rating = UIImagePNGRepresentation(rateButton.currentImage! )! as NSData?
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let destViewController = segue.destination as! MapViewController
            destViewController.diner = self.diner
        }
    }
}
