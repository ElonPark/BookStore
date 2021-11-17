//
//  BookDetailsRepository.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

protocol BookDetailsRepository {
    func bookDetails(
        isbn13: String,
        completion: @escaping (Result<BookDetails, Error>) -> Void
    )
}

final class BookDetailsRepositoryImpl: NetworkRepository<DetailsAPI>, BookDetailsRepository {
    
    func bookDetails(
        isbn13: String,
        completion: @escaping (Result<BookDetails, Error>) -> Void
    ) {
        request(endpoint: .books(isbn13: isbn13), completion: completion)
    }
}
