//
//  SearchFirmTableViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 04/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

extension SearchFirmTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let newSearchText = searchController.searchBar.text!
        
        // The web service returns an error message if the search text is 1 character so this must be prevented.
        // This will also be triggered after clicking away the alert message in case of a parse error,
        // so the same search should not be performed twice as it is not needed.
        if newSearchText != oldSearchText && isValidSearchQuery(searchText: newSearchText) {
            filterContentForSearchText(searchText: searchController.searchBar.text!, scope:currentScope)
        } else if newSearchText.count == 0 {
            // In case the search field is blank, show last view companies.
            // If the tableview style is .grouped it is already being viewed.
            if self.tableView.style == .plain {
                self.tableView = lastViewedCompaniesTableView
            }
        }
        // Keep track of the last searched text
        oldSearchText = newSearchText
    }
}

extension SearchFirmTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        currentScope = searchBar.scopeButtonTitles![selectedScope]
        if currentScope == FilterConstants.orgNumberScope {
            searchBar.placeholder = NSLocalizedString("Org.numberPlaceholder", comment: "")
        } else {
            searchBar.placeholder = NSLocalizedString("FirmNamePlaceholder", comment: "")
        }
        
        // When changing scope we do another search so that the result is updated to match the current scope and text
        if let searchBarText = searchBar.text {
            if isValidSearchQuery(searchText: searchBarText) {
                filterContentForSearchText(searchText: searchBar.text!, scope: currentScope)
            } else if searchBarText.count == 0 {
                // In case the search field is blank, show last view companies.
                // If the tableview style is .grouped it is already being viewed.
                if self.tableView.style == .plain {
                    self.tableView = lastViewedCompaniesTableView
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
    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: FirmDetailsTableViewController? = nil
    private var currentScope = FilterConstants.searchFirmScope // Initial scope
    private var oldSearchText = "" // Initial search text
    private var resultsTableView: UITableView!
    private var lastViewedCompaniesTableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var clearSearchHistoryButton: UIBarButtonItem!
    
    var lastViewedCompanies: CompaniesViewedHistory = CompaniesViewedHistory(companies: [])
    
    @IBAction func deleteSearch(_ sender: Any) {
        lastViewedCompanies.companies = []
        self.tableView.reloadData()
        saveList()
    }
    
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
        
        // Set up the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("FirmNamePlaceholder", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = [FilterConstants.searchFirmScope, FilterConstants.orgNumberScope]
        searchController.searchBar.delegate = self
        searchController.delegate = self

        //Metrics used for result and last viewed companies table views
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // Set up table view used for results when searching
        resultsTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        // Set up table view used for search history
        lastViewedCompaniesTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight), style: .grouped)
        lastViewedCompaniesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PreviouslyViewedCompanyCell")
        lastViewedCompaniesTableView.dataSource = self
        lastViewedCompaniesTableView.delegate = self
        
        // Display the last viewed companies by default
        self.tableView = lastViewedCompaniesTableView
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        clearSearchHistoryButton.title = NSLocalizedString("ClearSearchHistory", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    private func isValidSearchQuery(searchText: String) -> Bool {
        return searchText.count > 1
            && (currentScope != NSLocalizedString("OrganizationNumberScopeButton", comment: "") || searchText.count == 9)
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
        JSONUtil.retrieveCompanies(encodedURL, isOrgNumberSearch: scope == FilterConstants.orgNumberScope) { self.handleCompaniesSearchResult($0) }
    }
    
    private func handleCompaniesSearchResult(_ companies: [Company]?) {
        // When there is no error searching, keep track of filtered companies and reload the table view.
        // Otherwise, show and error message.
        if let comps = companies {
            self.filteredCompanies = comps
            if self.tableView.style == .grouped {
                self.tableView = resultsTableView
            }
            self.tableView.reloadData()
        } else {
            let alertTitle:String
            let alertMessage:String
            if (self.currentScope == FilterConstants.orgNumberScope) {
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
                    lastViewedCompanies.companies.remove(at: lastViewedCompanies.companies.firstIndex(of: company)!)
                    if self.tableView.style == .grouped && indexPath.row != 0 {
                        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.top)
                    }
                }
                lastViewedCompanies.companies.insert(company, at: 0)
                saveList()
                if self.tableView.style == .grouped {
                    if indexPath.row != 0 {
                        tableView.insertRows(at:  [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
                        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
                    }
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
