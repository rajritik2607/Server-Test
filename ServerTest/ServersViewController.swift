//
//  ServersViewController.swift
//  ServerTest
//
//  Created by Ritik Suryawanshi on 05/06/21.
//

import UIKit
import Firebase

class ServersViewController: UIViewController {

    
    @IBOutlet var activate1: UIButton!
    
    @IBOutlet var activate2: UIButton!
    
    @IBOutlet var activate3: UIButton!
    
    @IBOutlet var activate4: UIButton!
    
    var status : String = "false"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activate4.backgroundColor = .red
        activate2.backgroundColor = .red
        activate3.backgroundColor = .red
        activate1.backgroundColor = .red

        // Do any additional setup after loading the view.
    }
    
    @IBAction func activate1Pressed(_ sender: Any) {
        activate1.backgroundColor = .green
        activate2.backgroundColor = .red
        activate3.backgroundColor = .red
        activate4.backgroundColor = .red
        status = "true"
        
        let values = ["status": status]
        
        Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(values) {
          (error:Error?, ref:DatabaseReference) in
          
            if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
        
    }
    
    @IBAction func activate2Pressed(_ sender: Any) {
        activate2.backgroundColor = .green
        activate1.backgroundColor = .red
        activate3.backgroundColor = .red
        activate4.backgroundColor = .red
        status = "false"
        
        let values = ["status": status]
        
        Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(values) {
          (error:Error?, ref:DatabaseReference) in
          
            if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    
    @IBAction func activate3Pressed(_ sender: Any) {
        activate3.backgroundColor = .green
        activate1.backgroundColor = .red
        activate2.backgroundColor = .red
        activate4.backgroundColor = .red
        status = "false"
        
        let values = ["status": status]
        
        Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(values) {
          (error:Error?, ref:DatabaseReference) in
          
            if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    @IBAction func activate4Pressed(_ sender: Any) {
        activate4.backgroundColor = .green
        activate2.backgroundColor = .red
        activate3.backgroundColor = .red
        activate1.backgroundColor = .red
        status = "false"
        
        let values = ["status": status]
        
        Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(values) {
          (error:Error?, ref:DatabaseReference) in
          
            if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
