//
//  ImageDownloadCancelable.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Alamofire

public protocol ImageDownloadCancelable {
  @discardableResult func cancel() -> Self
}

extension Alamofire.Request: ImageDownloadCancelable {}
