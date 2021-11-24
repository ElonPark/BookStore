//
//  BookDetailsError.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

enum BookDetailsError: Error {
  case isbnError
  case resultError(String)
  case undefinedError(String)
  case urlError(String)
}
