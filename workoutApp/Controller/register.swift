//
//  register.swift
//  workoutApp
//
//  Created by William Gudiel on 8/16/20.
//  Copyright © 2020 William. All rights reserved.
//
import  UIKit
import Firebase

class register: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = userEmail.text,let password = userPassword.text {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let e = error {
            print(e.localizedDescription)
          } else{
            self.performSegue(withIdentifier: "RegisterToHome", sender: self)
            }
        }
        }
    }
}
