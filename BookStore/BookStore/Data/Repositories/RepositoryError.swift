//
//  RepositoryError.swift
//  BookStore
//
//  Created by Elon on 2021/11/20.
//

import Foundation

import Moya

enum RepositoryError: Error {
    case explicitlyCancelledError(Error)
    case undefinedError(Error)

    var isExplicitlyCancelled: Bool {
        guard case .explicitlyCancelledError = self else { return false }
        return true
    }

    init(_ error: Error) {
        self = Self.makeRepositoryError(error)
    }

    private static func makeRepositoryError(_ error: Error) -> Self {
        let undefinedError = Self.undefinedError(error)

        guard let moyaError = error as? MoyaError,
              case let .underlying(underlyingError, _) = moyaError
        else { return undefinedError }

        if let afError = underlyingError.asAFError, afError.isExplicitlyCancelledError {
            return .explicitlyCancelledError(underlyingError)
        }

        let nsError = underlyingError as NSError
        guard nsError.code == URLError.cancelled.rawValue else { return undefinedError }
        return .explicitlyCancelledError(underlyingError)
    }
}
