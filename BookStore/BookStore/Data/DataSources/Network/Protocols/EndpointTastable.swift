//
//  EndpointTastable.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

#if DEBUG
import Foundation

import Moya

protocol EndpointTastable {
    var sampleDataFactory: FixtureFactory { get }

    static func endpointErrorResponseClosure(_ target: Self) -> Endpoint
    static func endpointNetworkErrorClosure(_ target: Self) -> Endpoint
}

extension EndpointTastable where Self: TargetType {
    static func endpointErrorResponseClosure(_ target: Self) -> Endpoint {
        let url = URL(target: target).absoluteString
        let factory = target.sampleDataFactory
        let data = factory.convertToData(from: factory.errorResponse)
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, data) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }

    static func endpointNetworkErrorClosure(_ target: Self) -> Endpoint {
        let url = URL(target: target).absoluteString
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkError(URLError(.badServerResponse) as NSError) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
}
#endif
