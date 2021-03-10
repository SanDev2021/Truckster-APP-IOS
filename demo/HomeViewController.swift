//
//  ViewController.swift
//  demo
//
//  Created by RAKESH KUMAR, Sandeep kaur on 2021-02-11.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    let transiton = Transition()
    var topView: UIView?
    @IBOutlet weak var searchButton: UIButton!
    let locationManager = CLLocationManager()
    var lat=0.0
    var long=0.0
    var ul=0.0
    var ulo=0.0
    
    @IBOutlet weak var txtDemo: UITextField!
    
    var myPost=PostalCodeMapViewController()
    @IBOutlet weak var lblMessage: UILabel!
    let  validityType: String.ValidityType  = .postalCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
      
        //self.navigationItem.title = "Truckster"
    searchButton.isHidden=true
    
        
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "rideVC") as! RideDetailsViewController
        navigationController?.pushViewController(homeVC, animated: true)
        
     let postalCode=txtDemo.text!
        
        let api = "https://api.zip-codes.com/ZipCodesAPI.svc/1.0/QuickGetZipCodeDetails/\(postalCode)?key=46WEHN44RQ9XRG691HWL"
        print(api)
        let url = URL(string: api)
                
        let task  = URLSession.shared.dataTask(with: url! as URL) { [self](data, response , error) in
                    if let error  = error {
                        print(error)
                    }else {
                        if let urlContent = data{
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                print(jsonResult)
                                lat=((jsonResult["Latitude"]!as? Double)!)
                                long=((jsonResult["Longitude"]!as? Double)!)
                                
                                let d1=CLLocation(latitude: ul, longitude: ulo)
                                print(ul)
                                let d2=CLLocation(latitude: lat, longitude: long)
                                print(lat)
                                let dis = ((d1.distance(from: d2))/1000).rounded(.up)
                           
                                let distance = "\(dis) Km"
                                print(distance)
                                
                                let ref = Database.database().reference()
                             
                                
                                let uid = Auth.auth().currentUser?.uid
                                ref.child("users").child(uid!).child("LocationDetails").setValue(["DestinationPostalCode": postalCode, "Latitude": lat,"Longitude":long,"Distance":distance])
                                
                                
                                
                                let myLat=StructOperation()
                                let latt=myLat.pass(lat: lat)
                                let longg=myLat.pass1(long: long)
                               
                                self.myPost.setResultLabel(lat: latt, long: longg)
                               
                                
                                if let description = ((jsonResult["Latitude"] as? NSArray)?[0] as? NSDictionary)?["Longitude"] as? String{
                                    print(description)
                                    DispatchQueue.main.async {
                                     //
                                    }
                                }
                                
                                

                            }catch {
                                print(error)
                            }
                        }
                    }
                }
                //start the task
                task.resume()
        
       
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        ul=locValue.latitude
        ulo=locValue.longitude
        
        
    }
   
    @IBAction func verifyPostalCode(_ sender: Any) {
    
 
    guard let text = txtDemo.text  else { return }
                if text.isValid(validityType){
            searchButton.isHidden=false
                    lblMessage.backgroundColor=UIColor.green
                    lblMessage.textColor=UIColor.black
            lblMessage.text = "This postal code is Valid Postal\n Tap Search button to proceed"
        }else{
            searchButton.isHidden=true
            lblMessage.backgroundColor=UIColor.red
            lblMessage.textColor=UIColor.white
            lblMessage.text = "This postal code is not valid! \nPlease Enter in the format of A1A 1A1"
        }
    }
    
    
    
    @IBAction func signout(_ sender: Any) {
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }

    func transitionToNew(_ menuType: MenuType) {
       

        topView?.removeFromSuperview()
        switch menuType {
        case .profile:
            
            
                            let newStBd = UIStoryboard(name: "Main", bundle: nil)
                                   let CustTableVc = newStBd.instantiateViewController(withIdentifier: "ProfileID") as! ProfileViewController
                                   navigationController?.pushViewController(CustTableVc, animated: true)
//        
      
        default:
            
                            let newStBd = UIStoryboard(name: "Main", bundle: nil)
                                   let CustTableVc = newStBd.instantiateViewController(withIdentifier: "PaymentID") as! PaymentViewController
                                   navigationController?.pushViewController(CustTableVc, animated: true)
        }
    }
    
    
   
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
    
    
    
  
}


