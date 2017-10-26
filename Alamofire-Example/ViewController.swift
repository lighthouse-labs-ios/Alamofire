//
//  ViewController.swift
//  Alamofire-Example
//
//  Created by Kareem Sabri on 2017-10-26.
//  Copyright © 2017 Kareem Sabri. All rights reserved.
//

import Alamofire
import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.register()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func register() {
        let random = arc4random()
        let u = User(email: "kareem.sabri+\(String(random))@gmail.com", password: "mypassword")
        u.save {
            debugPrint(u.id!)
        }
    }
}

