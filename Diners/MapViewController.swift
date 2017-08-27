//
//  MapViewController.swift
//  Diners
//
//  Created by Александра Гольде on 29/01/2017.
//  Copyright © 2017 Александра Гольде. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var diner : Diner!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(diner.location!) { (placemarks, error) in
            guard error == nil else {return}
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first!
            let annotation = MKPointAnnotation()
            annotation.title = self.diner.name
            annotation.subtitle = self.diner.type
            guard let location = placemark.location else {return}
            annotation.coordinate = location.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil}
        
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }

        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightImage.image = UIImage(data: diner.image as! Data )//UIImage(named: diner.image)
        annotationView?.rightCalloutAccessoryView = rightImage
        annotationView?.pinTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
