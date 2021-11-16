//
//  NetworkRepository.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

class NetworkRepository<API: TargetType> {

  let provider: NetworkProvider<API>

  init(networkProvider: NetworkProvider<API>) {
    self.provider = networkProvider
  }

  func request<Response: Decodable>(endpoint: API, completion: @escaping (Result<Response, Error>) -> Void) {
    provider.request(endpoint) { result in
      switch result {
      case let .success(response):
        do {
          let response = try response.filterSuccessfulStatusCodes()
          let jsonDecoder = JSONDecoder()
          let data = try jsonDecoder.decode(Response.self, from: response.data)
          completion(.success(data))

        } catch {
          completion(.failure(error))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
