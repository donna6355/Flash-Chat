//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var charIdx = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        let titleText = K.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIdx, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIdx +=  1
        }
//        titleLabel.text = "⚡️FlashChat"
    }
    

}


//viewController lifecycle
// viewDidiLoad : IBOutler, Button, objects connected, called only once when view created
// viewWillAppear : right before draw the screen, good time to modify some ui to hide or show
// viewDidUppear :  view appear on the screen, start countdown timer or animation
// viewWillDisappear :
// viewDidDisappear : user cant see this view


//app lifecycle
// app launched => app visible => app recedes into background => resources reclaimed 




