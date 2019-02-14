//
//  ViewController.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: [RepositoryViewModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        self.title = "Repository List"

        Service().fetchRepositoryRequest { (response: Result<Repositories>) in
            switch response {
            case .success(let repo):
                self.viewModel = repo.items.map {RepositoryViewModel($0)}
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = self.viewModel?[indexPath.row] else { return UITableViewCell()}
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Repositories") {
//            data(c)
            data.configure(cell)
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Repositories")
//            cell.viewModel = data
            data.configure(cell)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.viewModel?[indexPath.row] else { return }
        let webView: WKWebView = WKWebView()
        let viewController = UIViewController()
        viewController.view = webView
        viewController.title = data.gitHubTitle
        webView.load(URLRequest(url: data.url))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
