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
        if let moyaError = error as? MoyaError,
            case let .underlying(underlyingError, _) = moyaError,
            let afError = underlyingError.asAFError,
            afError.isExplicitlyCancelledError {
            self = .explicitlyCancelledError(underlyingError)

        } else {
            self = .undefinedError(error)
        }
    }
}
