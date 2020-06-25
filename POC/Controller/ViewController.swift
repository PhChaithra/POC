//
//  ViewController.swift
//  POC
//
//  Created by ChaithraPH on 25/06/20.
//  Copyright © 2020 ChaithraPH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        spinner.center = self.view.center
        self.view.addSubview(spinner)

        spinner.startAnimating()
        DataLoader.sharedLoader.loadContentFrom(url: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") { (success) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
            self.navigationItem.title = DataLoader.sharedLoader.networkData
        }
    }

}

