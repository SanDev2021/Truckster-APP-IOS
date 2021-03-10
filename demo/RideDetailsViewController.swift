//
//  RideDetailsViewController.swift
//  demo
//
//  Created by RAKESH KUMAR on 2021-03-03.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RideDetailsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var lblCost: UILabel!
    
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var txtTruck: UITextField!
    
    var distance=""
    var estCost=0
    let ref = Database.database().reference()
    let defaults = UserDefaults.standard
    var truckSize=""
    var truckType = ["Small", "Medium", "Large"]

       public func numberOfComponents(in pickerView: UIPickerView) -> Int{
           return 1
       }

       public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

           return truckType.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

           self.view.endEditing(true)
           return truckType[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

           self.txtTruck.text = self.truckType[row]
        truckSize=self.truckType[row]
          
       }
   
    @IBAction func enable(_ sender: UITextField) {
        self.dropdown.isHidden = false
    }
    
       func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropdown.isHidden = false
           if textField == self.txtTruck {
               
               //if you don't want the users to se the keyboard type:

               textField.endEditing(true)
           }
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropdown.isHidden = true
        let defaults = UserDefaults.standard
        getUserInfo(onSuccess:{
            
            self.lblDestination.text = " \(defaults.string(forKey:"DestinationPostalCode")!)"
            self.lblDistance.text = " \(defaults.string(forKey:"Distance")!)"
            self.distance=defaults.string(forKey: "Distance")!
            print(self.distance)
            
            
        }){(Error) in
          print("error")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "PostalMapVc") as! PostalCodeMapViewController
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    
    @IBAction func btnCalculateFare(_ sender: UIButton) {
        let dist=distance
        var val=0
        let intSeparator = dist.split(separator: " ")
        for item in intSeparator {
            let part = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                 
            if let intVal = Int(part) {
                val=intVal/10
            }
            
        }
    
        if txtTruck.text=="Small"{
             estCost=val+100
    
            lblCost.text=("$ \(estCost)")
            print("$ \(estCost)")
            
        }else if txtTruck.text=="Medium"{
             estCost=val+250
            lblCost.text=("$ \(estCost)")
            print("$ \(estCost)")
            
        }else if txtTruck.text=="Large"{
             estCost=val+500
            lblCost.text=("$ \(estCost)")
            print("$ \(estCost)")
        }else{
            let alert = UIAlertController(title: "Alert!", message: "Please select Truck Size.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        }
        
    @IBAction func btnConfirm(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation Alert!", message: "The actual actual fare is subject to change based on the tolls and other factors.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        var costInDollar = ""
        costInDollar = ("$\(estCost)")
        
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).child("RideDetails").setValue([ "Destination":self.defaults.string(forKey: "DestinationPostalCode")! ,"Distance":distance,"Cost":costInDollar,"TruckSize":truckSize])

    }
    func getUserInfo(onSuccess: @escaping()-> Void, onError: @escaping (_ _error: Error?)->Void){
  
       guard let uid = Auth.auth().currentUser?.uid else{
           print("user not found")
           return
       }
       ref.child("users").child(uid).child("LocationDetails").observe(.value, with: { (snapshot) in
           if let dictionary = snapshot.value as? [String : Any]{
               let psCode = dictionary["DestinationPostalCode"] as! String
               let dis = dictionary["Distance"] as! String
            self.defaults.set(psCode, forKey: "DestinationPostalCode")
            self.defaults.set(dis, forKey: "Distance")
                          onSuccess()
               
           }
       }){(Error) in
           onError(Error)
       }
   }
    
    
}
