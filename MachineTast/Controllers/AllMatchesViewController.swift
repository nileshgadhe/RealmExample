//
//  AllMatchesViewController.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.
//

import UIKit
import Alamofire

class AllMatchesViewController: UIViewController {


    @IBOutlet weak var allMatchesTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    var allMatchesArray = [AllMatchesResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.title = "All Matches"
        
        revealViewController().rearViewRevealWidth = 280
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setUpTableView()
        apiCallGetAllMatchData()
    }
    

    func setUpTableView(){
        allMatchesTableView.delegate = self
        allMatchesTableView.dataSource = self
        allMatchesTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        allMatchesTableView.estimatedRowHeight = 100
        allMatchesTableView.rowHeight = UITableView.automaticDimension
        
        allMatchesTableView.register(UINib(nibName: "AllMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "AllMatchesTableViewCell")
        
    }
    
    
    
}

extension AllMatchesViewController{
    
    func apiCallGetAllMatchData(){
        
        let strUrl = "https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=NPKYZ3WZ1VYMNAZ2FLX1WLECAWSMUVOQZOIDBN53F3LVZBPQ&v=20180616"
        
        AF.request(URL.init(string: strUrl)!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            //print(response.result)
            self.allMatchesArray.removeAll()
            
            switch response.result {

            case .success(_):
                
                if let jsonData = response.value as? Dictionary<String,AnyObject>{
                    //print(jsonData)
                    
                    if let responseData = jsonData["response"] as? Dictionary<String,AnyObject>{
                        if let venusArray = responseData["venues"] as? [Dictionary<String,AnyObject>]{
                            
                            for venusDetailDict in venusArray{
                                
                                if let venusDetailDataDict = venusDetailDict as? Dictionary<String,AnyObject>{
                                    
                                    let matchId = venusDetailDataDict["id"] as? String ?? ""
                                    print(matchId)
                                    let matchName = venusDetailDataDict["name"] as? String ?? ""
                                    print(matchName)
                                    var isSaved = false
                                    
                                    let matchObject = MatchesModel()
                                    matchObject.matchId = matchId
                                    matchObject.matchName = matchName
                                    if DatabaseManager.shared().shouldInsertMatch(matches: matchObject){
                                        isSaved = false
                                    } else{
                                        isSaved = true
                                    }
                                    
                                    let allMatchResponse = AllMatchesResponseModel(matchId: matchId, matchName: matchName, isSaved: isSaved)
                                    
                                    self.allMatchesArray.append(allMatchResponse)
                                }
                            
                            }
                            
                        }
                    }
                    
                }
                self.allMatchesTableView.reloadData()
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}


extension AllMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMatchesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMatchesTableViewCell", for: indexPath) as! AllMatchesTableViewCell
        let matchData = allMatchesArray[indexPath.row]
        cell.lblMatchName.text = matchData.matchName
        cell.lblMatchId.text = "Match ID : \(matchData.matchId)"
        
        if matchData.isSaved == false{
            cell.imageViewStar.image = #imageLiteral(resourceName: "ic_empty_star")
        } else{
            cell.imageViewStar.image = #imageLiteral(resourceName: "ic_filled_star")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if allMatchesArray[indexPath.row].isSaved == true{
            
            let matchObject = MatchesModel()
            matchObject.matchId = allMatchesArray[indexPath.row].matchId
            matchObject.matchName = allMatchesArray[indexPath.row].matchName
            
            DatabaseManager.shared().deleteMatchOfId(matches: matchObject)
            
            allMatchesArray[indexPath.row].isSaved = false
            self.allMatchesTableView.reloadData()
            
        } else{
            
            let matchObject = MatchesModel()
            matchObject.matchId = allMatchesArray[indexPath.row].matchId
            matchObject.matchName = allMatchesArray[indexPath.row].matchName
            
            if DatabaseManager.shared().shouldInsertMatch(matches: matchObject){
                DatabaseManager.shared().insertMatch(match: matchObject)
            }
            
            allMatchesArray[indexPath.row].isSaved = true
            self.allMatchesTableView.reloadData()
        }
        
        
        
    }
    
}
