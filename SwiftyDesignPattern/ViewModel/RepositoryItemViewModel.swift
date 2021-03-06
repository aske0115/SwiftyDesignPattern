//
//  RepositoryItemViewModel.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 18/03/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation
import UIKit

class RepositoryItemViewModel {
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
}

extension RepositoryItemViewModel {
    func configure(_ view: UITableViewCell) {
        view.textLabel?.numberOfLines = 0
        view.detailTextLabel?.numberOfLines = 0
        view.textLabel?.text = self.gitHubTitle + "\n✪ : \(self.starCount)"
        view.detailTextLabel?.text = self.description
    }
}
