//
//  Service.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

enum Result<T> {
    case success(T)
    case error(Error)
    case errorWithMessage(String)
}

enum ServiceError: Error {
    case unknonw
    case requestFailed(response:URLResponse, data:Data?)
}

struct ServiceSetting: Codable {
    var language = Language.swift
    var userID   = UserID.aske0115
    var sortType = SortType.stars
    enum Language: String, Codable {
        case swift, objc, java, kotlin, python
        static let allValues: [Language] = [.swift, .objc, .java, .kotlin, .python]
    }
    enum UserID: String, Codable {
        case all, aske0115
        static let allValues: [UserID] = [.all, .aske0115]
    }
    enum SortType: String, Codable {
        case stars, forks, updated
        static let allValues: [SortType] = [.stars, .forks, .updated]
    }
}

class Service {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchRepository2(service: ServiceSetting) -> Driver<[Repository]> {
        let url = "https://api.github.com/search/repositories?q=language:\(service.language.rawValue)+user:\(service.userID.rawValue)&sort=\(service.sortType.rawValue)"
        return Observable.create { emit in
            Alamofire.request(URL(string: url)!).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                        do {
                            let response = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(Repositories.self, from: response)
                            emit.onNext(data.items)
                            emit.onCompleted()
                        } catch let error {
                            emit.onError(error)
                        }
                case .failure(let error):
                        emit.onError(error)
                }
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    
    func fetchRepository<T: Decodable>(service: ServiceSetting) -> Observable<Result<T>> {
        let url = "https://api.github.com/search/repositories?q=language:\(service.language.rawValue)+user:\(service.userID.rawValue)&sort=\(service.sortType.rawValue)"
        return session.rx
            .json(url: URL(string: url)!)
            .flatMap { json throws -> Observable<Result<T>> in
                if let json = json as? [String: Any] {

                    let response = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    do {
                        let repo = try JSONDecoder().decode(T.self, from: response)
                        return Observable.just(Result<T>.success(repo))
                    } catch let error {
                        return Observable.just(Result<T>.error(error))
                    }
                } else {
                    return Observable.just(Result<T>.errorWithMessage("파싱할 수 없어!"))
                }

        }
    }

    func fetchRepositoryRequest<T: Decodable>(service: ServiceSetting, completion: @escaping(Result<T>) -> Void) {
        let url = "https://api.github.com/search/repositories?q=language:\(service.language.rawValue)+user:\(service.userID.rawValue)&sort=\(service.sortType.rawValue)"
        Alamofire.request(URL(string: url)!).responseData { response in
            if let json = response.result.value {
                do {
                    let repositories = try JSONDecoder().decode(T.self, from: json)
                    completion(.success(repositories))
                } catch let error {
                    completion(.error(error))
                }
            }
        }
    }
}
