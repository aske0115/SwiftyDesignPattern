//
//  Repository.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation


struct Repository: Decodable {
    let fullName: String
    let description: String?
    let starCount: Int
    let forkCount: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description = "description"
        case starCount = "stargazers_count"
        case forkCount = "forks_count"
        case url = "html_url"
    }
}

// MARK: Repositories

struct Repositories: Decodable {
    let items: [Repository]
    enum CodingKeys: String, CodingKey {
        case items
    }
}


struct Repositories2: Decodable {
    let items: [Repository]
    enum CodingKeys: String, CodingKey {
        case items
    }
}
