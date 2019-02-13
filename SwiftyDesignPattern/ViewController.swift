//
//  ViewController.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service().fetchRepositoryRequest { (repositories) in
            print(repositories)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

