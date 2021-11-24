//
//  BookSearchRepository.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

protocol BookSearchRepository {
    @discardableResult
    func search(
        byKeyword query: String,
        completion: @escaping (Result<BookSearchResult, RepositoryError>) -> Void
    ) -> RequestCancellable

    @discardableResult
    func search(
        byKeyword query: String,
        withPagination page: Int,
        completion: @escaping (Result<BookSearchResult, RepositoryError>) -> Void
    ) -> RequestCancellable
}

final class BookSearchRepositoryImpl: NetworkRepository<SearchAPI>, BookSearchRepository {

    @discardableResult
    func search(
        byKeyword query: String,
        completion: @escaping (Result<BookSearchResult, RepositoryError>) -> Void
    ) -> RequestCancellable {
        request(endpoint: .search(query: query), completion: completion)
    }

    @discardableResult
    func search(
        byKeyword query: String,
        withPagination page: Int,
        completion: @escaping (Result<BookSearchResult, RepositoryError>) -> Void
    ) -> RequestCancellable {
        request(endpoint: .searchWithPagination(query: query, page: page), completion: completion)
    }
}
