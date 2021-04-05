//
//  JSONUtil.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 18/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import Foundation

class JSONUtil {
    
    private static var url = ""
    
    static private func retrieveData(_ url: String, isOrgNumberSearch: Bool, parseData: @escaping (Data?) -> Void) {
        JSONUtil.url = url

        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { (data, response, _) -> Void in
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse?.statusCode == 200 {
                parseData(data)
            } else {
                if isOrgNumberSearch {
                    print("Error loading data / company not found") // Invalid company number triggers this.
                    parseData(nil) // Want to clear the screen if org. number isn't found.
                } else {
                    print("Error loading data")
                    parseData(nil)
                }
            }
        }.resume()
    }
    
    static func retrieveCompany(_ url: String, callback: @escaping (Company?) -> Void) {
        retrieveData(url, isOrgNumberSearch: false) {
            if $0 == nil {
                runCallbackOnMainQueue(url: url) { callback(nil) } // Error loading data or company not found
            } else {
                let (companyParsed, parsingSuccessful) = JSONUtil.parseCompany($0)
                if parsingSuccessful {
                    print("Parsing complete")
                    runCallbackOnMainQueue(url: url) { callback(companyParsed) }
                } else {
                    runCallbackOnMainQueue(url: url) { callback(nil) } // Parsing error
                }
            }
        }
    }
    
    static func retrieveCompanies(_ url: String, isOrgNumberSearch: Bool, callback: @escaping ([Company]?) -> Void) {
        retrieveData(url, isOrgNumberSearch: isOrgNumberSearch) {
            if $0 == nil {
                runCallbackOnMainQueue(url: url) { callback(nil) } // Error loading data or company not found
            } else {
                if isOrgNumberSearch {
                    let (company, parsingSuccessful) = JSONUtil.parseCompany($0)
                    if parsingSuccessful {
                        print("Parsing complete")
                        runCallbackOnMainQueue(url: url) { callback([company]) }
                    } else {
                        print("Error with parsing data")
                        runCallbackOnMainQueue(url: url) { callback(nil) } // Parsing error
                    }
                } else {
                    let (companies, parsingSuccessful) = JSONUtil.parseCompanies($0)
                    if parsingSuccessful {
                        print("Parsing complete")
                        runCallbackOnMainQueue(url: url) { callback(companies) }
                    } else {
                        print("Error with parsing data")
                        runCallbackOnMainQueue(url: url) { callback(nil) } // Parsing error
                    }
                }
            }
        }
    }
    
    static private func parseCompanies(_ data: Data?) -> ([Company], Bool) {
        var companies = [Company]()
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
            
            if let embeddedDictionary = json["_embedded"] as? [String: AnyObject] {
                if let enheterArray = embeddedDictionary["enheter"] as? [[String: AnyObject]] {
                    for data in enheterArray {
                        companies.append(CompanyUtil.populateCompany(data))
                    }
                }
            }
            return (companies, true)
        } catch {
            return (companies, false)
        }
    }
    
    static private func parseCompany(_ data: Data?) -> (Company, Bool) {
        var company = Company()
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let data = json as? [String: AnyObject] {
                company = CompanyUtil.populateCompany(data)
            }
            return (company, true)
        } catch {
            return (company, false)
        }
    }
    
    static private func runCallbackOnMainQueue(url: String, callback: @escaping () -> Void) {
        if JSONUtil.url == url {
            DispatchQueue.main.async {
                callback()
            }
        }
    }
}
