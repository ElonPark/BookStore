//
//  BookSearchRepository.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

protocol BookSearchRepository {
  func search(
    byKeyword query: String,
    completion: @escaping (Result<BookSearchResult, Error>) -> Void
  )

  func search(
    byKeyword query: String,
    withPagination page: Int,
    completion: @escaping (Result<BookSearchResult, Error>) -> Void
  )
}

final class BookSearchRepositoryImpl: NetworkRepository<SearchAPI>, BookSearchRepository {

  func search(
    byKeyword query: String,
    completion: @escaping (Result<BookSearchResult, Error>) -> Void
  ) {
    request(endpoint: .search(query: query), completion: completion)
  }

  func search(
    byKeyword query: String,
    withPagination page: Int,
    completion: @escaping (Result<BookSearchResult, Error>) -> Void
  ) {
    request(endpoint: .searchWithPagination(query: query, page: page), completion: completion)
  }
}
