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
        
        //Set up loading view
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        noResultsLabel.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("SEARCHED FOR: " + searchBar.text!)
        
        //Hide no Results Label
        self.noResultsLabel.hidden = true
        
        //Loading indication
        loadingView.startAnimating();
        
        //Do the search
        makeSearch(searchBar.text!)
    }
    
    func makeSearch(searchText: String)
    {
        //TODO: Search http req manager
        httpRequestManager.instance.searchForGames(searchText, handleSearchResults: {(resultGames: [TrackedGameItem]) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.stopAnimating()
                self.curSearchResults = resultGames
                self.searchResultsTableView.reloadData()
            })
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(curSearchResults.count == 0)
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.stopAnimating()
                self.searchResultsTableView.hidden = true
                self.noResultsLabel.hidden = false
            })
        }
        else{
            self.searchResultsTableView.hidden = false
        }
        return curSearchResults.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = curSearchResults[indexPath.item].getTitle()
        return cell
    }

}

