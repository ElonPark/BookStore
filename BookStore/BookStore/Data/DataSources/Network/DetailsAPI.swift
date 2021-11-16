//
//  DetailsAPI.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

enum DetailsAPI {
  case books(isbn13: String)
}

extension DetailsAPI: TargetType {
  var baseURL: URL {
    return BookStoreInformation.API.url
  }

  var method: Moya.Method {
    return .get
  }

  var path: String {
    switch self {
    case let .books(isbn13):
      return "/books/\(isbn13)"
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

extension DetailsAPI: EndpointTastable {
  struct SampleDataFactory: FixtureFactory {
    let endpoint: DetailsAPI
  }

  var sampleDataFactory: FixtureFactory {
    return SampleDataFactory(endpoint: self)
  }
}
