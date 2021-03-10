//
//  SignUpViewController.swift
//  demo
//
//  Created by RAKESH KUMAR, Sandeep kaur  on 2021-02-24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Photos
import FirebaseStorage

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var mySign=PaymentViewController()

@IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnReg:UIButton!
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var imagePlace: UIImageView!
    
    
    var imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        checkPermissions()
        imagePickerController.delegate = self
   btnReg.setTitle("Register ", for: .normal)
}
    
    @IBAction func btnRegister(_ sender: Any) {
        var myInfo=StructOperation()
        let n=txtName.text!
        let ln = txtLastName.text!
        let ph = txtPhone.text!
        let em = txtEmail.text!
        
        var email=myInfo.pass2(email: em)
        var phone=myInfo.pass4(phone: ph)
        var lastName=myInfo.pass5(lastname: ln)
        var name=myInfo.pass3(name: n)
                self.mySign.setResultLabel(e: &email, ph: &phone, lname: &lastName, name: &name)
                if txtEmail.text?.isEmpty == true{
        print("no text in email field")
            return}
        if txtPassword.text?.isEmpty == true{
            print("no text")
            return}
        signUp(email: txtEmail.text!, password: txtPassword.text!, name: txtName.text!,lastname: txtLastName.text!, phone: txtPhone.text!, onSuccess: {
            print("signed uop")
        }){ (onError) in
            print("error \(onError?.localizedDescription)")
        }
        
        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainSB.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        navigationController?.pushViewController(homeVC, animated: true)
        
        let alert = UIAlertController(title: "Registeration Success!", message: "You have been Succesfully Registered now. Please Login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func signUp(email: String, password: String,name:String, lastname: String,phone:String, onSuccess: @escaping () -> Void, onError: @escaping(_ error : Error?) -> Void) {
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else{
                print("error \(error?.localizedDescription)")
                print("sign up ")
                return
            }
            SignUpViewController.uploadToDatabase(email: email, name: name, lastname: lastname, phone: phone) {
                onSuccess()
            }}}
    //uploaind to dtabase
    static func uploadToDatabase(email: String, name: String, lastname: String, phone: String, onSuccess: @escaping () -> Void){
        var ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).child("UserInfo").setValue(["email": email, "name": name,"lastname": lastname,"phone": phone])
        print("SigN Up")
        onSuccess()
        
        
    }
    //chooseingg the photo from the photlibrary
    @IBAction func imgBtnTapped(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
        
    }
    //if we have permision from the user
    func checkPermissions(){
        
    }
    func requestAuthroizationHandler(status : PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus()  == PHAuthorizationStatus.authorized {
            print ("we have access to photos ")
        }else{
            print ("we have no access to the photos ")
        }
    }
    // how will be kno wwhich mage they have choose and print th eurl in the log
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //setting image
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            selectedImageFromPicker = editedImage}
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            imagePlace.image = selectedImage
        }
        
        //getting url for the photo
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            
        print(url)
            uploadToCloud(fileURL: url)
    }
    imagePickerController.dismiss(animated: true, completion: nil)
        
}
    //upload to cloud
    func uploadToCloud(fileURL : URL){
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFile = fileURL
        let photoRef = storageRef.child("UploadPhotoOne")
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil){(metadata,err) in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Photo Upload")
        }
        
        
    }
    

}
