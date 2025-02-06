//
//  NetworkError.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import Foundation

struct NetworkError: Error {
    enum ErrorType {
        case badRequest
        case responseError
        case decodingError
    }

    let type: ErrorType
    let code: Int?
    let message: String?

    init(type: ErrorType, code: Int? = nil, message: String? = nil) {
        self.type = type
        self.code = code
        self.message = message
    }
}

struct ErrorResponse: Codable {
    let message: String?
    let members: [String]?
    let errors: [String]?
}
