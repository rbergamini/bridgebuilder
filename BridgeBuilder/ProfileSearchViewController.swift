//
//  ProfileSearchViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 6/17/17.
//  Copyright © 2017 Duke Innovation CoLab. All rights reserved.
//

import Foundation

import Firebase

import FirebaseDatabase


import UIKit

import FirebaseAuth

class ProfileSearchViewController: UITableViewController, UISearchResultsUpdating
{
    
    var profileStore: ProfileStore!
    let searchController = UISearchController(searchResultsController: nil)
    // Ray Wenderlich
    var filteredProfiles = [Profile]()
    var profiles = [Profile]()
    private var currentUid: String!
    
    // MARK: - iOS Methods
    override func viewDidLoad() {
        
        guard let user = Auth.auth().currentUser else
        {
            showError(message:"No user currently logged in.")
            return
        }
        
        currentUid = user.uid;
     
        profileStore = ProfileStore()
        
        populateProfilesFromDatabase()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // Ray Wenderlich Demo code
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        definesPresentationContext = true;
        tableView.tableHeaderView = searchController.searchBar;
        
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showConnection"
        {
            let connectionVC = segue.destination as! ConnectionViewController
            if let selectedIndex = tableView.indexPathForSelectedRow
            {
                let profile = profileStore.allProfiles[selectedIndex.row]
                
                getConnectionFromDatabase(with: profile, completion: {inputConnection in
                    connectionVC.connectionID = inputConnection
                    print("**/**/**"+inputConnection)
                    connectionVC.updateView()
                })
            }
        }
    }
    
    
    // MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredProfiles.count;
        }
        return profileStore.allProfiles.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",for:indexPath)
        
        
        let profile: Profile!
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            profile = filteredProfiles[indexPath.row]
        }
        else
        {
            profile = profileStore.allProfiles[indexPath.row]
        }
        
        cell.textLabel?.text = profile.name;
        cell.detailTextLabel?.text = profile.answer1;
        
        return cell;
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }*/
    
    // MARK: - Search Methods
    
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        filteredProfiles = profileStore.allProfiles.filter { profile in
            return profile.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    // MARK: - Database Methods
    func getConnectionFromDatabase(with other: Profile,completion: @escaping (String) -> ())
    {
        // Check if the connection has already been created
        let usersRef = Database.database().reference().child("users")
        let currentUserConnectionRef = usersRef.child(currentUid).child("connections")
        
        currentUserConnectionRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            
            let connectionID: String!
            
            if snapshot.hasChild(other.uid)
            {
                connectionID = snapshot.childSnapshot(forPath: other.uid).value as! String
            }
            else
            {
                connectionID = self.createNewConnectionInDatabase(with: other)
            }
            
            completion(connectionID)
        })
    }
    
    func createNewConnectionInDatabase(with other: Profile) -> String
    {
        // Create the connectionID
        let connectionRef = Database.database().reference().child("connections")
        let currentDate = Date()
        let values: [String:String] = ["dateCreated" : currentDate.description]
        
        let newConnection = connectionRef.childByAutoId()
        newConnection.setValue(values)
        let connectionID = newConnection.key
        
        // Add the connection to each profile
        let usersRef = Database.database().reference().child("users")
        usersRef.child(currentUid).child("connections").child(other.uid).setValue(connectionID)
        usersRef.child(other.uid).child("connections").child(currentUid).setValue(connectionID)
        
        return connectionID
    }
    
    func populateProfilesFromDatabase()
    {
        let database = Database.database().reference().child("users")
        
        
        database.queryOrderedByKey().observe(.childAdded, with: { [unowned self] (data) -> Void in
            let uid = data.ref.key;
            if(uid != self.currentUid)
            {
            print("*******"+data.ref.key)
            //print(data.childSnapshot(forPath: "firstName").value)
            
            guard let firstName = data.childSnapshot(forPath: "firstName").value as? String else
            {
                //self.showError(message: "Error")
                return
            }
            
            guard let lastName = data.childSnapshot(forPath: "lastName").value as? String else
            {
                //self.showError(message: "Error")
                return
            }
            
            
            self.profileStore.addProfile(firstName, lastName, uid)
            
            //self.profileStore.createProfile()
            
            self.tableView.reloadData()
            }
            
        })
    }
    
    // MARK: - Error Checking TODO: Extract this to make accessible to everyone so we're not duplicating code
    func showError(message: String)
    {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        
        let defaultAction = UIAlertAction(title:"Close Alert", style: .default, handler: nil)
        
        alertController.addAction(defaultAction);
        
        present(alertController, animated: true, completion:nil);
        
    }
}
