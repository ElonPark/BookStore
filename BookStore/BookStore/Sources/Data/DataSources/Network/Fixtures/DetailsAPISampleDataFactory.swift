//
//  DetailsAPISampleDataFactory.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

#if DEBUG
import Foundation

import Moya

extension DetailsAPI.SampleDataFactory {
    func makeFixtureData() -> Data {
        switch endpoint {
        case .books:
            return convertToData(from: bookDetailsResponse)
        }
    }
}

extension DetailsAPI.SampleDataFactory {
    var errorResponse: String {
    """
    {
      "error": "[books] Not found"
    }
    """
    }

    var bookDetailsResponse: String {
    """
    {
      "error": "0",
      "title": "Securing DevOps",
      "subtitle": "Security in the Cloud",
      "authors": "Julien Vehent",
      "publisher": "Manning",
      "language": "English",
      "isbn10": "1617294136",
      "isbn13": "9781617294136",
      "pages": "384",
      "year": "2018",
      "rating": "5",
      "desc": "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team's highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your cloud ...",
      "price": "$39.65",
      "image": "https://itbook.store/img/books/9781617294136.png",
      "url": "https://itbook.store/books/9781617294136",
      "pdf": {
        "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
        "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
      }
    }
    """
    }
}
#endif
