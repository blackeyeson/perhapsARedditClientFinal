//
//  APIError.swift
//  CleanSwift_Academy
//
//  Created by Giorgi Bostoghanashvili on 29.08.22.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
    case httpError
    case decodingError
}
