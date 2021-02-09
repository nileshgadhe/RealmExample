//
//  SavedMatchesViewController.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.
//

import UIKit

class SavedMatchesViewController: UIViewController {

    @IBOutlet weak var savedMatchesTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var lblNoData: UILabel!
    
    var savedMatchesArray = [MatchesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.title = "Saved Matches"
        
        revealViewController().rearViewRevealWidth = 280
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setUpTableView()
        getSavedMatches()
    }

    
    func setUpTableView(){
        
        savedMatchesTableView.delegate = self
        savedMatchesTableView.dataSource = self
        savedMatchesTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        savedMatchesTableView.estimatedRowHeight = 100
        savedMatchesTableView.rowHeight = UITableView.automaticDimension
        
        savedMatchesTableView.register(UINib(nibName: "AllMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "AllMatchesTableViewCell")
        
    }
    
    func getSavedMatches(){
        self.savedMatchesArray.removeAll()
        self.savedMatchesArray = DatabaseManager.shared().getAllMatches()
        if savedMatchesArray.count != 0{
            self.lblNoData.isHidden = true
            self.savedMatchesTableView.reloadData()
        } else{
            self.lblNoData.isHidden = false
            self.savedMatchesTableView.reloadData()
            
        }
    }
    
}


extension SavedMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedMatchesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMatchesTableViewCell", for: indexPath) as! AllMatchesTableViewCell
        
        let matchData = savedMatchesArray[indexPath.row]
        cell.lblMatchName.text = matchData.matchName
        cell.lblMatchId.text = "Match ID : \(matchData.matchId!)"
        cell.imageViewStar.image = #imageLiteral(resourceName: "ic_filled_star")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let savedMatch = savedMatchesArray[indexPath.row]
        DatabaseManager.shared().deleteMatchOfId(matches: savedMatch)
        getSavedMatches()
    }
    
}
