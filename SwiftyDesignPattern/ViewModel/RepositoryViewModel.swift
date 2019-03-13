//
//  RepositoryViewModel.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ViewModelType{
    associatedtype Input
    associatedtype Output
    
    func transform(_ input:Input) -> Output
    
}

class RepositoryViewModel:ViewModelType{
    
    var gitHubTitle: String
    var starCount: Int = 0
    var description: String?
    var url: URL
    init(_ model: Repository) {
        self.gitHubTitle = model.fullName
        self.starCount = model.starCount
        self.description = model.description
        self.url = URL(string: model.url)!
    }
    
    func transform(_ input: Input) -> Output {
//        let reloadData = input.refreshTap
        return RepositoryViewModel.Output
    }
}

extension RepositoryViewModel {
    
    struct Input{
        let refreshTap:Driver<Void>
    }
    
    struct Output{
        let reloadData:Driver<Void>
    }
    
    func configure(_ view: UITableViewCell) {
        view.textLabel?.numberOfLines = 0
        view.detailTextLabel?.numberOfLines = 0
        view.textLabel?.text = self.gitHubTitle + "\n✪ : \(self.starCount)"
        view.detailTextLabel?.text = self.description
    }
}
