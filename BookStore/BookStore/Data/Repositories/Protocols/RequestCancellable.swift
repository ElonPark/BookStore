//
//  RequestCancellable.swift
//  BookStore
//
//  Created by Elon on 2021/11/20.
//

import Foundation

import Moya

protocol RequestCancellable {
    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }

    /// Cancels the represented request.
    func cancel()
}

/// Repository 외부에서 Moya 종속성을 모르게 하기 위한 Wrapper
final class CancellableWrapper {

    private let cancellable: Cancellable

    init(cancellable: Cancellable) {
        self.cancellable = cancellable
    }
}

extension CancellableWrapper: RequestCancellable {
    var isCancelled: Bool {
        cancellable.isCancelled
    }

    func cancel() {
        cancellable.cancel()
    }
}
