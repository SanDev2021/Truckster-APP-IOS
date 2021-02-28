//
//  ContactUsViewController.swift
//  demo
//
//   Created by RAKESH KUMAR, Sandeep kaur on 2021-02-24.
//

import UIKit
import WebKit
import MessageUI
class ContactUsViewController: UIViewController {

    @IBOutlet weak var wbContact: WKWebView!
       var en=0;
       fileprivate let application=UIApplication.shared
       override func viewDidLoad() {
           super.viewDidLoad()
           if en==0{
               let htmlPath=Bundle.main.path(forResource:"contact", ofType: "html")
               let url=URL(fileURLWithPath: htmlPath!)
               let request = URLRequest(url: url)
               wbContact.load(request)
           }else{
               let htmlPath=Bundle.main.path(forResource:"fr-Contact", ofType: "html")
               let url=URL(fileURLWithPath: htmlPath!)
               let request = URLRequest(url: url)
               wbContact.load(request)
           }
       }
       
       @IBAction func btnCall(_ sender: UIButton) {
           makePhoneCall(phoneNumber: "43658780908")
           
           //                if let phoneURL = URL(string: "tel:// 123456789" ) {
           //                    if application.canOpenURL(phoneURL ){
           //                        application.open(phoneURL, options: [:], completionHandler: nil)
           //                    }
           //                }
           
       }
       
       @IBAction func btnEmail(_ sender: UIButton) {
           //        if MFMessageComposeViewController.canSendText() {
           //            let controller = MFMessageComposeViewController()
           //                controller.body = "hi there"
           //                controller.recipients=["4567890"]
           //                controller.messageComposeDelegate=self
           //            self.present(controller, animated: true, completion: nil)
           
           let email = "foo@bar.com"
           if let url = URL(string: "mailto:\(email)") {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
       }
       
       
       @IBAction func btnNav(_ sender: UIButton) {
           let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let homeVC = mainSB.instantiateViewController(withIdentifier: "mapVC")
           navigationController?.pushViewController(homeVC, animated: true)
       }
       func makePhoneCall(phoneNumber: String) {
           if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
               let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                   UIApplication.shared.canOpenURL(phoneURL as URL)
               }))
               
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
               self.present(alert, animated: true, completion: nil)
           }
       }
   }

   extension ContactUsViewController:MFMailComposeViewControllerDelegate{
       private func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
       }
       
       
   }
