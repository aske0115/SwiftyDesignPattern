//
//  ViewController.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: [RepositoryViewModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    let dispose: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension

        self.title = "Repository List"

        let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)

        self.navigationItem.rightBarButtonItem = rightButton

        self.navigationItem.rightBarButtonItem!.rx.tap
            .debug()
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.viewModel?.removeAll()
                self.requestRepositoryList()
            })
            .disposed(by: dispose)

        requestRepositoryList()
    }

    func requestRepositoryList() {
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "Repositories")!
        data.configure(cell)

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.viewModel?[indexPath.row] else { return }

        let webView: WKWebView = WKWebView()
        let viewController = UIViewController()

        viewController.view = webView
        viewController.title = data.gitHubTitle

        webView.load(URLRequest(url: data.url))
        
        print("didSelectedRow  ")

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
