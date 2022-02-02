//
//  StringExtensions.swift
//  ImageDownloader
//
//  Created by Elon on 2022/02/02.
//

import Foundation
import CryptoKit

extension String {
    var sha1: String {
        let data = Data(self.utf8)
        let digset = Insecure.SHA1.hash(data: data)
        let hex = digset.map { String(format: "%02X", $0) }.joined()
        return hex
    }
}
