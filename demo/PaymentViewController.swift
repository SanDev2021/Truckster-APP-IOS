//
//  PaymentViewController.swift
//  demo
//
//   Created by RAKESH KUMAR, Sandeep kaur on 2021-02-17.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PaymentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var txtCardType: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
    
    @IBOutlet weak var txtNameCard: UITextField!
    
    @IBOutlet weak var txtCardNo: UITextField!
    
    @IBOutlet weak var txtExpDate: UITextField!
    
    @IBOutlet weak var txtCvvNo: UITextField!
    
    @IBOutlet weak var txtBillAdd: UITextField!
    
    var email = ""
    var phone = ""
    var lsname = ""
    var Fname = ""
    var cardType = ["Debit", "Credit", "MasterCard"]

       public func numberOfComponents(in pickerView: UIPickerView) -> Int{
           return 1
       }

       public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

           return cardType.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

           self.view.endEditing(true)
           return cardType[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

           self.txtCardType.text = self.cardType[row]
           self.dropdown.isHidden = true
       }
    @IBAction func enable(_ sender: UITextField) {
        self.dropdown.isHidden = false
    }
    
       func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropdown.isHidden = false
           if textField == self.txtCardType {
               
               //if you don't want the users to se the keyboard type:

               textField.endEditing(true)
           }
       }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropdown.isHidden = true
        
      
        // Do any additional setup after loading the view.
    }
    func setResultLabel(e: inout String,ph: inout String,lname: inout String,name: inout String)  {
      
        email = e
        phone = ph
        lsname = lname
        Fname = name
        print(e)
    }
    @IBAction func Signout(_ sender: UIButton) {
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
   @IBAction func saveBtnPressed(_ sender: UIButton) {
    
    print("done")
    var ref = Database.database().reference()
    let c=txtNameCard.text!
    let cn=txtCardNo.text!
    let c1=txtCardType.text!
    let c2=txtExpDate.text!
    let c3=txtCvvNo.text!
    let c4=txtBillAdd.text!
    
    
    let uid = Auth.auth().currentUser?.uid
    ref.child("users").child(uid!).child("cardDetails").setValue(["cardHolderName": c, "CardNumber": cn,"cardType":c1, "ExpiryDate": c2,"CVVNumber":c3,"BillingAdress":c4])

}
}
