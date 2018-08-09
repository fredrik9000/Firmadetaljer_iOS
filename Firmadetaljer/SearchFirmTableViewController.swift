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
        if !(newScope == scope && newSearchText == searchText) && newSearchText.count > 1 && (scope != NSLocalizedString("OrganizationNumberScopeButton", comment: "") || newSearchText.count == 9) {
            scope = newScope
            saveList()
            filterContentForSearchText(searchText: searchController.searchBar.text!, scope:scope)
        } else if newSearchText.count == 0 {
            if self.tableView.style == .plain {
                self.tableView = lastViewedCompaniesTableView
                resultsTableView.tableHeaderView = nil
                lastViewedCompaniesTableView.tableHeaderView = searchController.searchBar
                searchController.searchBar.becomeFirstResponder()
            }
        }
    }
}

extension SearchFirmTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = searchBar.scopeButtonTitles![selectedScope]
        if scope == FilterConstants.orgNumberScope {
            searchController.searchBar.placeholder = NSLocalizedString("Org.numberPlaceholder", comment: "")
        } else {
            searchController.searchBar.placeholder = NSLocalizedString("FirmNamePlaceholder", comment: "")
        }
        if let searchBarText = searchController.searchBar.text {
            if searchBarText.count > 1
                && (scope != NSLocalizedString("OrganizationNumberScopeButton", comment: "") || searchBar.text!.count == 9) {
                filterContentForSearchText(searchText: searchBar.text!, scope: scope)
            } else if searchBarText.count == 0 {
                if self.tableView.style == .plain {
                    self.tableView = lastViewedCompaniesTableView
                    resultsTableView.tableHeaderView = nil
                    lastViewedCompaniesTableView.tableHeaderView = searchController.searchBar
                    searchController.searchBar.becomeFirstResponder()
                }
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
        static let searchFirmScope = NSLocalizedString("FirmNameScopeButton", comment: "")
        static let orgNumberScope = NSLocalizedString("OrganizationNumberScopeButton", comment: "")
    }
    
    private var filteredCompanies = [Company]()
    let searchController = CustomSearchController(searchResultsController: nil)
    var detailViewController: FirmDetailsTableViewController? = nil
    private var scope = ""
    private var searchText = ""
    private var resultsTableView: UITableView!
    private var lastViewedCompaniesTableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    
    var lastViewedCompanies: CompaniesViewedHistory = CompaniesViewedHistory(companies: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("last_viewed_companies.json") {
            if let jsonData = try? Data(contentsOf: url), let savedSearchHistory = CompaniesViewedHistory(json: jsonData) {
                lastViewedCompanies = savedSearchHistory
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? FirmDetailsTableViewController
        }
        
        //Set up the search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("FirmNamePlaceholder", comment: "")
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [FilterConstants.searchFirmScope, FilterConstants.orgNumberScope]
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        //Metrics used for result and search history table views
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        //Set up table view used for results when searching
        resultsTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        //Set up table view used for search history
        lastViewedCompaniesTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight), style: .grouped)
        lastViewedCompaniesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PreviouslyViewedCompanyCell")
        lastViewedCompaniesTableView.dataSource = self
        lastViewedCompaniesTableView.delegate = self
        lastViewedCompaniesTableView.tableHeaderView = searchController.searchBar
        
        //Display the search history by default
        self.tableView = lastViewedCompaniesTableView
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = view.center
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.addSubview(activityIndicator)
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
            let filter = "$filter=startswith(navn,'\(searchText)')"
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
            if self.tableView.style == .grouped {
                self.tableView = resultsTableView
                lastViewedCompaniesTableView.tableHeaderView = nil
                resultsTableView.tableHeaderView = searchController.searchBar
                searchController.searchBar.becomeFirstResponder()
            }
            self.tableView.reloadData()
        } else {
            let alertTitle:String
            let alertMessage:String
            if (self.scope == FilterConstants.orgNumberScope) {
                alertTitle = NSLocalizedString("CompanyNotFoundTitle", comment: "")
                alertMessage = NSLocalizedString("CompanyNotFoundMessage", comment: "") //Wrong org. number is the most likely issue.
            } else {
                alertTitle = NSLocalizedString("ErrorLoadingDataTitle", comment: "")
                alertMessage = NSLocalizedString("ErrorLoadingDataMessage", comment: "")
            }
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.activityIndicator.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompanyDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let company: Company
                if self.tableView.style == .plain {
                    company = filteredCompanies[indexPath.row]
                } else {
                    company = lastViewedCompanies.companies[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! FirmDetailsTableViewController
                controller.company = company
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                if lastViewedCompanies.companies.contains(company) {
                    lastViewedCompanies.companies.remove(at: lastViewedCompanies.companies.index(of: company)!)
                }
                lastViewedCompanies.companies.insert(company, at: 0)
                saveList()
                if self.tableView.style == .grouped {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.style == .plain {
            return filteredCompanies.count
        } else {
            return lastViewedCompanies.companies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView.style == .grouped {
            return NSLocalizedString("LastViewedCompanyHeader", comment: "")
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if self.tableView.style == .plain {
            cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
            
            if let navn = filteredCompanies[indexPath.row].navn {
                cell.textLabel?.text = navn
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "PreviouslyViewedCompanyCell", for: indexPath)
            
            if let navn = lastViewedCompanies.companies[indexPath.row].navn {
                cell.textLabel?.text = navn
            }
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showCompanyDetails", sender: indexPath)
    }
    
    func saveList() {
        if let json = lastViewedCompanies.json {
            if let url = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("last_viewed_companies.json") {
                do {
                    try json.write(to: url)
                } catch let error {
                    print("Couldn't save \(error)")
                }
            }
        }
    }
}
