//
//  ViewController.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel:[RepositoryViewModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Service().fetchRepositoryRequest { (response:Result<Repositories>) in
            switch response{
            case .success(let repo):
                self.viewModel = repo.items.map{RepositoryViewModel($0)}
                print(repo)
            case .error(let error):
                print(error.localizedDescription)
            case .errorWithMessage(let message):
                print(message)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Repositories"){
            guard let data = self.viewModel?[indexPath.row] else{ return cell}
            cell.textLabel?.text = data.gitHubTitle ?? "" + "[ \(data.starCount) ]"
            cell.detailTextLabel?.text = data.description
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Repositories")
            guard let data = self.viewModel?[indexPath.row] else{ return cell}
            cell.textLabel?.text = data.gitHubTitle ?? "" + "[ \(data.starCount) ]"
            cell.detailTextLabel?.text = data.description
            return cell
        }
        
    }
}
