//
//  FixtureFactory.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

protocol FixtureFactory {
    var errorResponse: String { get }

    func makeFixtureData() -> Data
}

extension FixtureFactory {
    func makeFixtureData() -> Data {
        return Data()
    }

    func convertToData(from responseFixture: String) -> Data {
        guard let data = responseFixture.data(using: .utf8) else {
            fatalError("Can't convert data from fixture string. Fixture: \(self)")
        }

        return data
    }
}
