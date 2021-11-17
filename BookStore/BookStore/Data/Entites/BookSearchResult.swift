//
//  BookSearchResult.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

enum BookSearchResult: Decodable, Equatable {
    case success(SearchResult)
    case failure(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .error)
        let total = try? container.decode(String.self, forKey: .total)
        let page = (try? container.decode(String.self, forKey: .page)) ?? "0"
        let books = try? container.decode([Book].self, forKey: .books)

        if let total = total, let totalNumber = Int(total), let books = books {
            let pageNumber = Int(page) ?? 0
            let searchResult = SearchResult(error: error, total: totalNumber, page: pageNumber, books: books)
            self = .success(searchResult)
        } else {
            self = .failure(error)
        }
    }
}

extension BookSearchResult {
    enum CodingKeys: String, CodingKey {
        case error
        case total
        case page
        case books
    }
}

extension BookSearchResult {
    struct SearchResult: Equatable {
        let error: String
        let total: Int
        let page: Int
        let books: [Book]
    }
}

extension BookSearchResult {
    struct Book: Decodable, Equatable {
        let title: String
        let subtitle: String
        let isbn13: String
        let price: String
        let image: String
        let url: String
    }
}
