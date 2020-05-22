//
//  ViewController.swift
//  CGLibrary
//
//  Created by nobleidea on 05/17/2020.
//  Copyright (c) 2020 nobleidea. All rights reserved.
//

import UIKit
import CGLibrary
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let str = CGJSONValue.string("CGJSONValue TEST").stringValue else { return }
        CGLibrary().log(with: str)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

