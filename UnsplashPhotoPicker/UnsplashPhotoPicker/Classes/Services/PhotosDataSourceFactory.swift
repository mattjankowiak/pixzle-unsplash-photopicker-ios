//
//  PhotosDataSourceFactory.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-10-10.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

enum PhotosDataSourceFactory: PagedDataSourceFactory {
    case search(query: String)
    case collection(identifier: String)
    case all(orderBy: String = "popular") // Supports "latest" or "popular"

    var dataSource: PagedDataSource {
        return PagedDataSource(with: self)
    }

    func initialCursor() -> UnsplashPagedRequest.Cursor {
        switch self {
        case .search(let query):
            return SearchPhotosRequest.cursor(with: query, page: 1, perPage: 30)
        case .collection(let identifier):
            let perPage = 30
            return GetCollectionPhotosRequest.cursor(with: identifier, page: 1, perPage: perPage)
        case .all(let orderBy):
            return UnsplashPagedRequest.Cursor(page: 1, perPage: 30, parameters: ["order_by": orderBy])
        }
    }

    func request(with cursor: UnsplashPagedRequest.Cursor) -> UnsplashPagedRequest {
        switch self {
        case .search(let query):
            return SearchPhotosRequest(with: query, page: cursor.page, perPage: cursor.perPage)
        case .collection(let identifier):
            return GetCollectionPhotosRequest(for: identifier, page: cursor.page, perPage: cursor.perPage)
        case .all(let orderBy):
            return ListPhotosRequest(page: cursor.page, perPage: cursor.perPage, orderBy: orderBy)
        }
    }
}

class ListPhotosRequest: UnsplashPagedRequest, @unchecked Sendable {
    private let orderBy: String

    init(page: Int, perPage: Int, orderBy: String = "popular") {
        self.orderBy = orderBy
        let cursor = Cursor(page: page, perPage: perPage, parameters: ["order_by": orderBy])
        super.init(with: cursor)
    }

    override var endpoint: String {
        return "/photos"
    }

    override func prepareParameters() -> [String: Any]? {
        var params = super.prepareParameters()
        params?["order_by"] = orderBy
        return params
    }

    override func processResponseData(_ data: Data?) {
        if let photos = try? JSONDecoder().decode([UnsplashPhoto].self, from: data ?? Data()) {
            self.items = photos
        }
        super.processResponseData(data)
    }
}
