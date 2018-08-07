//
//  SearchHistory.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 8/7/18.
//  Copyright © 2018 Fredrik Eilertsen. All rights reserved.
//

import Foundation

struct SearchHistory: Codable {
    var companies = Set<Company>()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(SearchHistory.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(companies: Set<Company>) {
        self.companies = companies
    }
}
