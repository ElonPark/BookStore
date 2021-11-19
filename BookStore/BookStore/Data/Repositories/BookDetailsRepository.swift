//
//  BookDetailsRepository.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

protocol BookDetailsRepository {
    @discardableResult
    func bookDetails(
        isbn13: String,
        completion: @escaping (Result<BookDetails, RepositoryError>) -> Void
    ) -> RequestCancellable
}

final class BookDetailsRepositoryImpl: NetworkRepository<DetailsAPI>, BookDetailsRepository {
    
    @discardableResult
    func bookDetails(
        isbn13: String,
        completion: @escaping (Result<BookDetails, RepositoryError>) -> Void
    ) -> RequestCancellable {
       return request(endpoint: .books(isbn13: isbn13), completion: completion)
    }
}
