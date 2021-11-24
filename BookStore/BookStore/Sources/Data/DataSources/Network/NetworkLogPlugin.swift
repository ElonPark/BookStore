//
//  NetworkLogPlugin.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import Foundation

import Moya

struct NetworkLogPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        printRequestMessage(from: target)
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            printSuccessMessage(from: response, with: target)

        case let.failure(error):
            printErrorMessage(from: error, with: target)
        }
    }

    private func printRequestMessage(from target: TargetType) {
        let requestInfo = self.requestInfo(from: target)
        let message = "REQUEST: \(requestInfo)"
        print(message)
    }

    private func printSuccessMessage(from response: Response, with target: TargetType) {
        let requestInfo = self.requestInfo(from: target)
        let message = "SUCCESS: \(requestInfo) (\(response.description))"
        print(message)
    }

    private func printErrorMessage(from error: MoyaError, with target: TargetType) {
        let requestInfo = self.requestInfo(from: target)
        let errorDescription = error.errorDescription ?? ""
        let message = "FAILURE: \(requestInfo) \(errorDescription)"
        print(message)
    }

    private func requestInfo(from target: TargetType) -> String {
        let info = "\(target.method.rawValue) \(target.path)"
        return info
    }
}
