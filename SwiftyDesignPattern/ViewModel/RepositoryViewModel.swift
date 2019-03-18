//
//  RepositoryViewModel.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol RepositoryViewModelType {

    associatedtype Input
    associatedtype Output

    func transfer(_ input: Input) -> Output
}

class RepositoryViewModel: RepositoryViewModelType {

    struct Input {
        let viewWillAppear: Driver<Void>
        let didPressRefreshButton: Driver<Void>
    }

    struct Output {
        let showRepositoryList: Driver<[Repository]>
    }

    func transfer(_ input: Input) -> Output {
        let posts = Driver.merge(input.viewWillAppear, input.didPressRefreshButton)
            .flatMapLatest {
                return Service().fetchRepository2(service: ServiceSetting())
        }.asDriver(onErrorJustReturn: [])

        return Output(showRepositoryList: posts)
    }
}
