//
//  URLPathPercentEncodable.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

protocol URLPathPercentEncodable {
    func urlPathAllowedEncodeString(from origin: String) -> String
}

extension URLPathPercentEncodable {
    func urlPathAllowedEncodeString(from origin: String) -> String {
        guard let urlPath = origin.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Percent Encoding Error to `\(origin)`")
        }

        return urlPath
    }
}
