//
//  SearchFirmTableViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 04/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }}

class CustomSearchController: UISearchController {
    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }}

extension SearchFirmTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let newScope = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        let newSearchText = searchController.searchBar.text!
        
        /* The web service returns an error message if the search text is 1 character.
         No point in searching for the same scope and search text as the last search. After clicking away the alert message in case of a parse error, this function is triggered, therefore we need to check if scope and text have changed. */
        if !(newScope == scope && newSearchText == searchText) && newSearchText.count > 1 && (scope != "Org.nummer" || newSearchText.count == 9) {
            scope = newScope
            searchText = newSearchText
            filterContentForSearchText(searchText: searchController.searchBar.text!, scope:scope)
        }
    }
}

extension SearchFirmTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = searchBar.scopeButtonTitles![selectedScope]
        if scope == FilterConstants.orgNumberScope {
            searchController.searchBar.placeholder = "Organisasjonsnummer(9 siffer)"
        } else if scope == FilterConstants.employeesMoreThan50Scope {
            searchController.searchBar.placeholder = "Firmanavn (Ansatte > 50)"
        } else {
            searchController.searchBar.placeholder = "Firmanavn (Alle)"
        }
        if let searchBarText = searchController.searchBar.text {
            if searchBarText.count > 1
                && (scope != "Org.nummer" || searchBar.text!.count == 9) {
                filterContentForSearchText(searchText: searchBar.text!, scope: scope)
            }
        }
    }
}

extension SearchFirmTableViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

class SearchFirmTableViewController: UITableViewController {
    
    private struct FilterConstants {
        static let searchFirmScope = "Firmanavn (Alle)"
        static let employeesMoreThan50Scope = "Ansatte > 50"
        static let orgNumberScope = "Org.nummer"
    }
    
    private var filteredCompanies = [Company]()
    let searchController = CustomSearchController(searchResultsController: nil)
    var detailViewController: FirmDetailsTableViewController? = nil
    private var scope = ""
    private var searchText = ""
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Finn firma"
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? FirmDetailsTableViewController
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Firmanavn (Alle)"
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [FilterConstants.searchFirmScope, FilterConstants.employeesMoreThan50Scope, FilterConstants.orgNumberScope]
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = FilterConstants.searchFirmScope) {
        
        var url :String
        if (scope == FilterConstants.orgNumberScope) {
            url = "http://data.brreg.no/enhetsregisteret/enhet/\(searchText).json"
        } else {
            var filter = "$filter=startswith(navn,'\(searchText)')"
            if (scope == FilterConstants.employeesMoreThan50Scope) {
                filter += " and antallAnsatte gt 50"
            }
            url = "http://data.brreg.no/enhetsregisteret/enhet.json?" + filter
        }
        
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { print("Couldn't encode URL"); return }
        
        if !activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        JSONUtil.retrieveCompanies(encodedURL, isOrgNumberSearch: scope == FilterConstants.orgNumberScope) { self.companiesParsed($0) }
    }
    
    private func companiesParsed(_ companies: [Company]?) {
        if let comps = companies {
            self.filteredCompanies = comps
            self.tableView.reloadData()
        } else {
            let alertTitle:String
            let alertMessage:String
            if (self.scope == FilterConstants.orgNumberScope) {
                alertTitle = "Company not found"
                alertMessage = "Couldn't find the company you were looking for. Wrong number?" //Wrong org. number is the most likely issue.
            } else {
                alertTitle = "Error loading data"
                alertMessage = "Couldn't retrieve data. Do you have an internet connection?"
            }
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.activityIndicator.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let company = filteredCompanies[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! FirmDetailsTableViewController
                controller.company = company
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCompanies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let company = filteredCompanies[indexPath.row]
        
        if let navn = company.navn {
            cell.textLabel?.text = navn
        }
        
        return cell
    }
    
}
