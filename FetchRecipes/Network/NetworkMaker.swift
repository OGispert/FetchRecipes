//
//  NetworkMaker.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import UIKit

protocol NetworkMaker {
    func fetch<T: Codable>(responseModel: T.Type, endpoint: Endpoint) async throws -> T
    func downloadImage(from stringURL: String?) async throws -> Data
}
