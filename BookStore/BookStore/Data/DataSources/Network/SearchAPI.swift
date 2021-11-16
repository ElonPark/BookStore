//
//  SearchAPI.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

enum SearchAPI {
  case search(query: String)
  case searchWithPagination(query: String, page: Int)
}

extension SearchAPI: TargetType, URLPathPercentEncodable {
    var baseURL: URL {
        return BookStoreInformation.API.url
    }

    var method: Moya.Method {
        return .get
    }

    var path: String {
        switch self {
        case let .search(query):
            let encodedQuery = urlPathAllowedEncodeString(from: query)
            return "/search/\(encodedQuery)"

        case let .searchWithPagination(query, page):
            let encodedQuery = urlPathAllowedEncodeString(from: query)
            return "/search/\(encodedQuery)/\(page)"
        }
    }

    var headers: [String : String]? {
        return nil
    }

    var task: Task {
        return .requestPlain
    }

    var sampleData: Data {
        return sampleDataFactory.makeFixtureData()
    }
}

extension SearchAPI: EndpointTastable {
  struct SampleDataFactory: FixtureFactory {
    let endpoint: SearchAPI
  }

  var sampleDataFactory: FixtureFactory {
    return SampleDataFactory(endpoint: self)
  }
}
