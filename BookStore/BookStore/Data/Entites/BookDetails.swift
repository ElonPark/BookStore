//
//  BookDetails.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

enum BookDetails: Decodable, Equatable {
    case success(Details)
    case failure(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.decode(String.self, forKey: .error)

        if error == "0" {
            let details = try Details(from: decoder)
            self = .success(details)
        } else {
            self = .failure(error)
        }
    }
}

extension BookDetails {
    enum CodingKeys: String, CodingKey {
        case error
    }
}

extension BookDetails {
    struct Details: Decodable, Equatable {
        let error: String
        let title: String
        let subtitle: String
        let authors: String
        let publisher: String
        let language: String
        let isbn10: String
        let isbn13: String
        let pages: String
        let year: String
        let rating: String
        let desc: String
        let price: String
        let image: String
        let url: String
        let pdf: [String: String]?
    }
}
