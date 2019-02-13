//
//  Service.swift
//  SwiftyDesignPattern
//
//  Created by GeunHwa Lee on 13/02/2019.
//  Copyright © 2019 GeunHwa Lee. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T>{
    case success(T)
    case error(Error)
    case errorWithMessage(String)
}

enum ServiceError:Error{
    case unknonw
    case requestFailed(response:URLResponse,data:Data?)
}

struct ServiceSetting: Codable {
    var language = Language.swift
    var userID   = UserID.all
    var sortType = SortType.stars
    
    enum Language: String, Codable {
        case swift, objc, java, kotlin, python
        static let allValues: [Language] = [.swift, .objc, .java, .kotlin, .python]
    }
    enum UserID: String, Codable {
        case all, giftbott
        static let allValues: [UserID] = [.all, .giftbott]
    }
    enum SortType: String, Codable {
        case stars, forks, updated
        static let allValues: [SortType] = [.stars, .forks, .updated]
    }
}


class Service{
    private let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars"
    
    func fetchRepositoryRequest<T:Decodable>(completion: @escaping(Result<T>) -> ())
    {
        
        Alamofire.request(URL(string: url)!).responseData { response in
            if let json = response.result.value
            {
                do
                {
                    let repositories = try JSONDecoder().decode(T.self, from: json)
                    completion(.success(repositories))
                }catch let error
                {
                    completion(.error(error))
                }
//            }
//        }
            }
        }
    }
}
