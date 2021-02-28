//
//  LoginViewController.swift
//  demo
//
//   Created by RAKESH KUMAR, Sandeep kaur on 2021-02-24.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {

var someVariable: String = "someValue"
var en=0;
@IBOutlet weak var btnLogin: UIButton!
@IBOutlet weak var btnSignup: UIButton!
@IBOutlet weak var txtUser: UITextField!
@IBOutlet weak var txtPass: UITextField!
@IBOutlet weak var lblUser:UILabel!
@IBOutlet weak var lblUsername:UILabel!
@IBOutlet weak var lblPassword:UILabel!
var loggedInUser = ""
var loggedInUserPass = ""
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
}

@IBAction func btnHelp(_ sender: UIBarButtonItem) {
    let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeVC = mainSB.instantiateViewController(withIdentifier: "contactVC")as! ContactUsViewController

    navigationController?.pushViewController(homeVC, animated: true)
    
}

@IBAction func userLogin(_ sender: UIButton) {

 validateFields()
    login()

        print("logged in")
//    let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let homeVC = mainSB.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
//        navigationController?.pushViewController(homeVC, animated: true)
        

//        print("wrong pass")
//        let alert = UIAlertController(title: "wrong password", message: nil, preferredStyle: .alert)
//
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
    

}
    

   

func validateFields(){
if txtUser.text?.isEmpty == true{
    print("no email text")
    return
}
if txtPass.text?.isEmpty == true{
    print("no email text")
    return
}
return
//  login()
}


func login(){
    Auth.auth().signIn(withEmail: txtUser.text!, password: txtPass.text!)
    {
               
        
        [weak self] authResult, err in
        guard let strongSelf = self
        else {return}
        if let err = err{
            print(err.localizedDescription)
            
            let alert = UIAlertController(title: "Invalid Credentials", message: "Wrong Username or password.Please try Again!", preferredStyle: .alert)
          
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
        else {
            self?.segue()
            let alert = UIAlertController(title: "Login Success!", message: "Welcome, You loggedin now!", preferredStyle: .alert)
          
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self!.present(alert, animated: true, completion: nil)
        }
    
    }
   
   
}
    func segue(){
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let homeVC = mainSB.instantiateViewController(withIdentifier: "homeVC") as!HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)
               
    }

func checkUserInfo(){
if Auth.auth().currentUser != nil{
    print(Auth.auth().currentUser?.uid)
    print("signed in")
   
    

   
   return
}
}
//        func alertmessage(msg:String) {
//            let alert = UIAlertController(title: "Alert", message:msg, preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }




@IBAction func btnsignup(_ sender: Any) {
    let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeVC = mainSB.instantiateViewController(withIdentifier: "signUpVc") as! SignUpViewController
    navigationController?.pushViewController(homeVC, animated: true)
}



}
