//
//  SecondViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var noResultsLabel: UILabel!
    @IBOutlet var searchResultsTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var curSearchResults : [TrackedGameItem]!
    
    //Get the loading wheel going
    let loadingView = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curSearchResults = [TrackedGameItem]()
        
        //Set up table view cells
        searchResultsTableView.register(UINib(nibName: "SearchGameCell", bundle: nil), forCellReuseIdentifier: "Cell")
        searchResultsTableView.rowHeight = searchResultsTableView.dequeueReusableCell(withIdentifier: "Cell")!.frame.height
        
        //Set up loading view
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        loadingView.center = self.view.center;
        loadingView.hidesWhenStopped = true;
        self.view.addSubview(loadingView);
        loadingView.stopAnimating()
        
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noResultsLabel.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCHED FOR: " + searchBar.text!)
        
        //Hide no Results Label
        self.noResultsLabel.isHidden = true
        
        //Loading indication
        loadingView.startAnimating();
        
        //Do the search
        makeSearch(searchBar.text!)
    }
    
    func makeSearch(_ searchText: String)
    {
        //TODO: Search http req manager
        httpRequestManager.instance.searchForGames(searchText, handleSearchResults: {(resultGames: [TrackedGameItem]) in
            
            DispatchQueue.main.async(execute: {
                self.loadingView.stopAnimating()
                self.curSearchResults = resultGames
                self.searchResultsTableView.reloadData()
            })
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(curSearchResults.count == 0)
        {
            DispatchQueue.main.async(execute: {
                self.loadingView.stopAnimating()
                self.searchResultsTableView.isHidden = true
                self.noResultsLabel.isHidden = false
            })
        }
        else{
            self.searchResultsTableView.isHidden = false
        }
        return curSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchGameCell
        let gameItem = curSearchResults[(indexPath as NSIndexPath).row]
        
        cell.gameNameLabel.text = curSearchResults[(indexPath as NSIndexPath).item].getTitle()
        cell.addToTrackedButton.addTarget(self, action: #selector(clickAddGame), for: .touchUpInside)
        cell.addToTrackedButton.tag = (indexPath as NSIndexPath).row
        
        //Get the image async
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            
            //Make the URL secure to make request
            let unsecureURLString: String = gameItem.getImgUrl();
            let secureURLString = unsecureURLString.replacingOccurrences(of: "http", with: "http", options: NSString.CompareOptions.literal, range: nil)
            
            //Create NSURL object for making the request
            let url = URL(string: secureURLString)
            
            //Make the request for the image and if we get data set it to image
            let data = try? Data(contentsOf: url!);

            DispatchQueue.main.async {
                if(data != nil){
                    cell.gameImageView.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
    
    func clickAddGame(_ sender: UIButton)
    {
        let index = sender.tag
        let id = curSearchResults[index].getgbid()
        httpRequestManager.instance.addGameToTracked(String(id))
        self.view.makeToast(message: "Added: " + curSearchResults[index].getTitle() + " to tracked games")
    }

}

