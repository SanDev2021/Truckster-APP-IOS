//
//  PostalCodeMapViewController.swift
//  demo
//
//  Created by RAKESH KUMAR, Sandeep kaur on 2021-02-27.
//

import UIKit
import MapKit
import CoreLocation

class PostalCodeMapViewController: UIViewController,CLLocationManagerDelegate{
@IBOutlet weak var mapView: MKMapView!

@IBOutlet weak var sgmtCtrl: UISegmentedControl!
var a="Your Destination "

var userLoc=CLLocationCoordinate2D()
var offLoc=CLLocationCoordinate2D()
static var latitude=0.0
static var longitude=0.0

var locationManager=CLLocationManager()
override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view.
locationManager.delegate=self
locationManager.desiredAccuracy=kCLLocationAccuracyBest
locationManager.requestWhenInUseAuthorization()
locationManager.startUpdatingLocation()
}
func setResultLabel(lat:Double,long:Double ) {
     PostalCodeMapViewController.latitude=lat
PostalCodeMapViewController.longitude=long
}
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
let userLocation:CLLocation=locations[0]
let lat=userLocation.coordinate.latitude
let long=userLocation.coordinate.longitude
let latDelta:CLLocationDegrees=0.05
let longDelta:CLLocationDegrees=0.05

let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)



userLoc = CLLocationCoordinate2D(latitude: lat, longitude: long)
let region=MKCoordinateRegion(center: userLoc, span: span)
mapView.setRegion(region, animated: true)
print(PostalCodeMapViewController.latitude)
locOffice(lati: PostalCodeMapViewController.latitude, longi: PostalCodeMapViewController.longitude)
offLoc=CLLocationCoordinate2D(latitude: PostalCodeMapViewController.latitude, longitude: PostalCodeMapViewController.longitude)
    
   
    
    }
@IBAction func btnZoomIn(_ sender: Any) {
let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta/2, longitudeDelta: mapView.region.span.longitudeDelta/2)
     let region = MKCoordinateRegion(center: mapView.region.center, span: span)
                  mapView.setRegion(region, animated: true)    }
@IBAction func btnZoomOut(_ sender: Any) {
let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta*2, longitudeDelta: mapView.region.span.longitudeDelta*2)
         let region = MKCoordinateRegion(center: mapView.region.center, span: span)
                      mapView.setRegion(region, animated: true)
}

@IBAction func btnRoute(_ sender: UIButton) {
let placeMark1=MKPlacemark(coordinate: userLoc)
let placeMark2=MKPlacemark(coordinate: offLoc)
let request = MKDirections.Request()
request.source = MKMapItem( placemark: placeMark1)
request.destination = MKMapItem(placemark: placeMark2)
request.transportType = .automobile
let directions = MKDirections(request: request)
directions.calculate {  (response, error) in
    guard let directionResponse = response else { return }
        for route in directionResponse.routes {
        self.mapView.addOverlay(route.polyline)
        self.mapView.delegate = self
        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
}

}


func locOffice(lati: Double, longi: Double)  {
let latitude:CLLocationDegrees=lati
let longitude:CLLocationDegrees = longi

let latDelta:CLLocationDegrees=0.05
let longDelta:CLLocationDegrees=0.05


let span=MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

let loaction = CLLocationCoordinate2D(latitude:latitude,longitude:longitude)

let region = MKCoordinateRegion(center: loaction, span: span)

//set the region on the map
mapView.setRegion(region, animated: true)

//adding annotation for the map
let annotation = MKPointAnnotation()
annotation.title=a
annotation.coordinate=loaction
mapView.addAnnotation(annotation)

}

@IBAction func viewType(_ sender: UISegmentedControl) {


switch (sender.selectedSegmentIndex) {
      case 0:
        mapView.mapType = .standard
      case 1:
        mapView.mapType = .hybrid
      default:
        mapView.mapType = .satellite
  }
}
}
extension PostalCodeMapViewController : MKMapViewDelegate
{
func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
renderer.strokeColor = UIColor.blue
renderer.lineWidth=6.0
return renderer
}
}

