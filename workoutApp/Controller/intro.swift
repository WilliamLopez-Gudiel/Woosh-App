//
//  intro.swift
//  workoutApp
//
//  Created by William Gudiel on 8/16/20.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit

class introController: UIViewController {
    
    
    @IBOutlet weak var wooshXConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.wooshXConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        wooshXConstraint.constant -= view.bounds.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

}
