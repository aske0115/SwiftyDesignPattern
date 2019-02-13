//
//  TableViewCell.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 14/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell:UITableViewCell{
    
    var viewModel:RepositoryViewModel?{
        didSet{
            guard let vm = self.viewModel else { return }
            self.textLabel?.numberOfLines = 0
            self.detailTextLabel?.numberOfLines = 0
            self.textLabel?.text = (vm.gitHubTitle ?? "") + "\n✪ : \(vm.starCount)"
            self.detailTextLabel?.text = vm.description
            self.setNeedsDisplay()
        }
    }

}
