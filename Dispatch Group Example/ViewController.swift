//
//  ViewController.swift
//  Dispatch Group Example
//
//  Created by Bernardo Silva on 11/09/19.
//  Copyright © 2019 Bernardo Silva. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var hotelsTableView: UITableView!
    var loader: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var backgroundView = UIView()
    //var dispatchGroup = DispatchGroup()
    var restaurantNames: [String] = [] {
        didSet {
            self.restaurantsTableView.reloadData()
        }
    }
  
    var hotelNames: [String] = [] {
        didSet {
            self.hotelsTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view.
        backgroundView.frame = self.view.frame
        backgroundView.backgroundColor = UIColor(red: 197/255, green: 199/255, blue: 201/255, alpha: 0.8)
        backgroundView.addSubview(loader)
        loader.center = backgroundView.center
        self.view.addSubview(backgroundView)
        setupLoader()
        setupTableView()
        searchHotels()
        searchRestaurants()
        //dispatchNotify()
    }
    
    func setupLoader() {
        let transform = CGAffineTransform(scaleX: 2, y: 2)
        self.loader.transform = transform
        loader.hidesWhenStopped = true
        loader.startAnimating()
    }
    
    func setupTableView() {
        restaurantsTableView.dataSource  = self
        restaurantsTableView.delegate  = self
        hotelsTableView.dataSource = self
        hotelsTableView.delegate = self
    }

    func searchPlacesNames(searchText: String, completion: @escaping ([String]) -> Void){
        MapRequest.search(sentence: searchText) { (response, error) in
            if let mapItens = response?.mapItems {
                let names  = mapItens.compactMap({ $0.placemark }).compactMap( { $0.name })
                completion(names)
            } else if let error = error {
                print(error)
            }
            //hides loader
            self.loader.stopAnimating()
            self.backgroundView.isHidden = true
        }
       
    }
    
    func searchHotels() {
        //dispatchGroup.enter()
        self.searchPlacesNames(searchText: "hotel") { names in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // Put your code which should be executed with a delay here
                 self.hotelNames = names
                 //self.dispatchGroup.leave()
            }
           
        }
    }
    
    func searchRestaurants() {
        //dispatchGroup.enter()
        self.searchPlacesNames(searchText: "restaurant") { names in
            self.restaurantNames = names
            //self.dispatchGroup.leave()
        }
    }
    
//    func dispatchNotify() {
//        dispatchGroup.notify(queue: .main) {
//            self.loader.stopAnimating()
//            self.backgroundView.isHidden = true
//        }
//    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == restaurantsTableView {
           return restaurantNames.count
        }
        return hotelNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var name = ""
        if tableView == restaurantsTableView {
            name = restaurantNames[indexPath.row]
        } else {
            name = hotelNames[indexPath.row]
        }
        cell.textLabel?.text = name
        return cell
        
    }
    
    
}
