//
//  WebsiteRecipeSoupEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 15/08/2023.
//

import Foundation
import SwiftSoup

enum WebsiteRecipeSoupEngineError: Error {
    case failedToCreateStringFromData
}

final class WebsiteRecipeSoupEngine {
    let documentData: Data
    var document: Document?
    
    init(documentData: Data) throws {
        self.documentData = documentData
        self.document = try parseIntoDocument(documentData)
    }
    
    func getTitle() throws -> String? {
        if let doc = document {
            return try doc.title()
        }
        return nil
    }
    
    func getText() throws -> String? {
        if let doc = document, let body = doc.body() {
            return try body.text(trimAndNormaliseWhitespace: false)
        }
        return nil
    }
    
    func getImageSourceLinks() throws -> [String]? {
        if let doc = document, let body = doc.body() {
            let imageElements = try body.select("img")
            let sources = try imageElements.map { element in
                try element.attr("src")
            }
            return sources
        }
        return nil
    }
    
    func parseIntoDocument(_ data: Data) throws -> Document {
        guard let dataString = String(data: data, encoding: .utf8) else {
            throw WebsiteRecipeSoupEngineError.failedToCreateStringFromData
        }
        return try SwiftSoup.parse(dataString)
    }
}
