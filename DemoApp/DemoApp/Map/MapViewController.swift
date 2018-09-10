//
//  MapViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit
import MapKit
import McPicker
class MapViewController: DemoAppViewController {

    //MARK: - VARIABLES AND OUTLETS
    @IBOutlet weak var map: MKMapView!
    var barBtnItem : UIBarButtonItem?
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    let places: [Place] = [
        Place("CDMX", "Ciudad de Mexico", CLLocationCoordinate2DMake(19.3202829,-99.4328046)),
        Place("London", "United Kingdom", CLLocationCoordinate2DMake(51.5285582, -0.2416806)),
        Place("Frankfurt", "Deutschland", CLLocationCoordinate2DMake(50.1211277,8.4964816)),
        Place("Madrid", "España", CLLocationCoordinate2DMake(40.4378698,-3.8196202))
    ]
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
        
        //1 @setPlaceMaker
        self.setPlaceMaker()
        
        //Go to location using Picker
        
        //
    }
    
    //MARK: - LOAD CONFIGS
    fileprivate func loadConfig(){
        self.map.delegate = self
        
        //@setUpSearchBar
        self.setUpSearchBar()
        
        //@setUpBarItems
        self.barBtnItem = UIBarButtonItem(title: "Locations", style: .plain, target: self, action: #selector(self.setLocation))
        self.navigationItem.rightBarButtonItem = barBtnItem
    }
    
    //MARK: @setUpSearchBar
    fileprivate func setUpSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.searchBar.barStyle = .black
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.searchController = self.searchController
    }
    
    //MARK: @setUpBarItems
    fileprivate func setUpBarItems(){
        self.barBtnItem = UIBarButtonItem(title: "Locations", style: .plain, target: self, action: #selector(self.setLocation))
        self.navigationItem.rightBarButtonItem = barBtnItem
    }
    
    //MARK: - GO TO LOCATIONS FROM PICKER
    @objc fileprivate func setLocation(){
        
        let data: [[String]] = [["CDMX", "London", "Frankfurt", "Madrid"]]
        McPicker.showAsPopover(data: data, fromViewController: self, barButtonItem: barBtnItem) { [weak self] (selections: [Int : String]) -> Void in
            guard let strongSelf = self else {return}
            if let name = selections[0], name  == "CDMX" {
                strongSelf.updateMapRegion(rangeSpan: 80000, coordinate: strongSelf.places[0].coordinate)
            }
            if let name = selections[0], name  == "London" {
                strongSelf.updateMapRegion(rangeSpan: 80000, coordinate: strongSelf.places[1].coordinate)
            }
            if let name = selections[0], name  == "Frankfurt" {
                strongSelf.updateMapRegion(rangeSpan: 80000, coordinate: strongSelf.places[2].coordinate)
            }
            if let name = selections[0], name  == "Madrid" {
                strongSelf.updateMapRegion(rangeSpan: 80000, coordinate: strongSelf.places[3].coordinate)
            }
        }
 
    }
    
    //MARK: - MAP FUNCTIONS
    //MARK: @setPlaceMaker
    fileprivate func setPlaceMaker(){
        
        self.places.forEach { (place) in
            self.map.addAnnotation(place)
        }
    }
    //MARK: @updateMapRegion
    func updateMapRegion(rangeSpan:CLLocationDistance, coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, rangeSpan, rangeSpan)
        map.region = region
    }
    
    //MARK: - SEARCH ADDRESS
    //MARK: @searchAddress (from a string)
    func searchAddress(address: String, completionHandler:@escaping(CLLocationCoordinate2D?, String, NSError?)-> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil{
                if let placemark = placemarks?[0]{
                    let coordinate = placemark.location?.coordinate
                    let location  = (placemark.locality ?? String()) + " " +  (placemark.isoCountryCode ?? String())
                    completionHandler(coordinate, location, nil)
                }
            } else{
                completionHandler(nil, "", error as NSError?)
            }
            
        }
    }
    //MARK: @searchLocation (from a place)
    func placemark(annotation: Place, completionHandler:@escaping(CLPlacemark?)-> Void){
        let coordinate = annotation.coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks{
                completionHandler(placemarks.first)
            } else {
                completionHandler(nil)
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //@getPinAnnotation: Add Pin
        //return self.getPinAnnotation(mapView, annotation: annotation)
        
        //@getAnnotationView: Add custom annotation view
        return self.getAnnotationView(mapView, annotation: annotation)
        
    }
    
    //Mark: @getPinAnnotation (returns a simple pin, you can change only color and add text)
    fileprivate func getPinAnnotation(_ mapView: MKMapView, annotation: MKAnnotation) -> MKPinAnnotationView?{
        var annotationView = MKPinAnnotationView()
        guard let annotation = annotation as? Place else {
            return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView {
            annotationView = dequedView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        annotationView.pinTintColor = .green
        annotationView.canShowCallout = true
        
        //Custom text:
        let paragraph = UILabel()
        paragraph.numberOfLines = 0
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate"
        annotationView.detailCalloutAccessoryView = paragraph
        return annotationView
    }
    
    //Mark: @getAnnotationView
    fileprivate func getAnnotationView(_ mapView: MKMapView, annotation: MKAnnotation)  -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? Place else {
            return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        annotationView.image = UIImage(named: "iconPin")
        annotationView.canShowCallout = true
        
        //Custom text:
        let paragraph = UILabel()
        paragraph.numberOfLines = 0
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate"
        paragraph.adjustsFontSizeToFitWidth = true
        annotationView.detailCalloutAccessoryView = paragraph
        annotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named:"iconPin"))
        
        //Add button
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        
        return annotationView
    }
    
    //MARK: DETAIL
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vcDetail = MapDetailViewController(nibName: "MapDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        //searchBar.tintColor = .white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //Filter by segment
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text , term.isEmpty == false else {
            
            MessageManager.shared.showBar(title: nil, subtitle: "White spaces are not permitted", type: .warning, fromBottom: false)
            return
        }
        
        self.searchAddress(address: term) { (coordinate, location, error) in
            guard error == nil else {
                MessageManager.shared.showBar(title: "No address found", subtitle: String(), type: .warning, fromBottom: false)
                return
            }
            guard let coordinate  = coordinate else {
                MessageManager.shared.showBar(title: "No address found", subtitle: String(), type: .warning, fromBottom: false)
                return
            }
            
            self.map.camera.centerCoordinate = coordinate
            self.map.camera.altitude = 1000.0
            let pin = Place(term, location, coordinate)
            self.map.addAnnotation(pin)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
    }
}
