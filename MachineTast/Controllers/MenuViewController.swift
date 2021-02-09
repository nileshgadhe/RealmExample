//
//  MenuViewController.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserve
//

import UIKit

class MenuViewController: UIViewController {

    
    @IBOutlet weak var menuTableView: UITableView!
    
    let menuArray = ["All Matches", "Saved Matches"]
    let menuImgArray:[UIImage] = [#imageLiteral(resourceName: "ic_all_matches"), #imageLiteral(resourceName: "ic_saved_matches")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    
    class func navigationController() -> UINavigationController{
        
        let controller:UINavigationController = UINavigationController()
        controller.isNavigationBarHidden = true
        return controller;
        
    }
    
    func setUpTableView(){
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        menuTableView.estimatedRowHeight = 100
        menuTableView.rowHeight = UITableView.automaticDimension
        
        menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
    }
    
    
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuLbl.text = menuArray[indexPath.row]
        cell.imageView?.image = menuImgArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController =  MenuViewController.navigationController()
        let revealController = self.revealViewController()
        
        switch indexPath.row {
            
        case 0:
            let viewToPush = mainstoryboard.instantiateViewController(withIdentifier: "AllMatchesViewController") as! AllMatchesViewController
            navController.pushViewController(viewToPush, animated: true)
            revealController?.pushFrontViewController(navController, animated: true)
            
        case 1:
            let viewToPush = mainstoryboard.instantiateViewController(withIdentifier: "SavedMatchesViewController") as! SavedMatchesViewController
            navController.pushViewController(viewToPush, animated: true)
            revealController?.pushFrontViewController(navController, animated: true)
            
        default:
            print("")
        }
        
    }
}
