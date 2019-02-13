//
//  RepositoryViewModel.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation


class RepositoryViewModel{
//    private var model:Repository

    var gitHubTitle:String?
    var starCount:Int = 0
    var description:String?
    
    init(_ model:Repository){
//        self.model = model
        
        self.gitHubTitle = model.fullName
        self.starCount = model.starCount
        self.description = model.description
    }
    
}
