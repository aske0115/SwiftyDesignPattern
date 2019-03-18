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
    private var viewModel: [RepositoryItemViewModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    private var viewModel2: RepositoryViewModel!

    let dispose: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel2 = RepositoryViewModel()
        setupUI()
        bind()
    }

    func setupUI() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension

        self.title = "Repository List"

        let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
    }

    func bind() {

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: ))).map { _ in }
            .asDriver(onErrorJustReturn: ())
        let tapRightButton = self.navigationItem.rightBarButtonItem!.rx.tap.asDriver()

        let input = RepositoryViewModel.Input(viewWillAppear: viewWillAppear, didPressRefreshButton: tapRightButton)
        let output = viewModel2.transfer(input)

        output.showRepositoryList.drive(onNext: { repository in
            self.viewModel = repository.map {RepositoryItemViewModel($0)}
        })
        .disposed(by: dispose)
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
