//
//  ProfileViewController.swift
//  demo
//
//   Created by RAKESH KUMAR, Sandeep kaur on 2021-02-17.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblLName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        getUserInfo(onSuccess:{
            
            self.lblname.text = " \(defaults.string(forKey:"userNameKey")!)"
            self.lblEmail.text = " \(defaults.string(forKey:"userEmailKey")!)"
            self.lblLName.text = " \(defaults.string(forKey:"userLastNameKey")!)"
            self.lblPhone.text = " \(defaults.string(forKey:"userPhoneKey")!)"
            
            
        }){(Error) in
          print("error")
        }
        }
    @IBAction func Signout(_ sender: UIButton) {
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
     func getUserInfo(onSuccess: @escaping()-> Void, onError: @escaping (_ _error: Error?)->Void){
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else{
            print("user not found")
            return
        }
        ref.child("users").child(uid).child("UserInfo").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any]{
                let email = dictionary["email"] as! String
                let name = dictionary["name"] as! String
                let lastname = dictionary["lastname"] as! String
                let phone = dictionary["phone"] as! String
               
                
                defaults.set(email, forKey: "userEmailKey")
                defaults.set(name, forKey: "userNameKey")
                defaults.set(lastname, forKey: "userLastNameKey")
                defaults.set(phone, forKey: "userPhoneKey")
                onSuccess()
                
            }
        }){(Error) in
            onError(Error)
        }
    }
}
