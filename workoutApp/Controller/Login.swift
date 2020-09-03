//
//  Login.swift
//  workoutApp
//
//  Created by William Gudiel on 8/16/20.
//  Copyright © 2020 William. All rights reserved.
//

import  UIKit
import Firebase
class Login: UIViewController {
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = userEmail.text,let password = userPassword.text {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let self = self else { return }
            if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
        }
        }
    }
}
