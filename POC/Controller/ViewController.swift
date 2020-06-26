//
//  ViewController.swift
//  POC
//
//  Created by ChaithraPH on 25/06/20.
//  Copyright © 2020 ChaithraPH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {

        spinner.center = self.view.center
        self.view.addSubview(spinner)
        
        self.loadContent()
        
    }
    
    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataLoader.sharedLoader.contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: .subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text = DataLoader.sharedLoader.contents[indexPath.row].title
        cell.detailTextLabel?.text = DataLoader.sharedLoader.contents[indexPath.row].description
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        
        if DataLoader.sharedLoader.contents[indexPath.row].imageURL.count>0 {
            
            self.loadImageFrom(url: DataLoader.sharedLoader.contents[indexPath.row].imageURL, cell: cell)
            
        }
        cell.imageView?.image = UIImage(named: "DefaultImage")
        return cell
    }
    
    //MARK: - Action methods
    
    @IBAction func refreshContent(sender:UIBarButtonItem)
    {
        self.loadContent()
    }
    
    // MARK: - Private methods
    
    func loadContent() {
       spinner.startAnimating()
        DataLoader.sharedLoader.loadContentFrom(url: Constants.ContentURL) { (success,error) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            if success
            {
                self.navigationItem.title = DataLoader.sharedLoader.networkData
                self.tableView.reloadData()
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert,animated:true,completion: nil)
            }
            
        }
    }
    
    func loadImageFrom(url:String, cell:UITableViewCell) -> () {
        getData(from: URL(string: url)!) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.imageView?.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
}

