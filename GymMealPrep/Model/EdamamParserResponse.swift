//
//  EdamamParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/15/23.
//
//   let edamamParser = try? JSONDecoder().decode(EdamamParser.self, from: jsonData)

import Foundation

// MARK: - EdamamParserResponse
struct EdamamParserResponse: Codable {
    let text: String
    let parsed: [ParsedFood]
    let hints: [Hint]
    let links: Links

    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
        case links
    }
}

// MARK: - Hint
struct Hint: Codable {
    let food: ParsedFood
    let measures: [Measure]
}

// MARK: - Food
struct ParsedFood: Codable {
    let foodID, label, knownAs: String
    let nutrients: Nutrients
    let category: String
    let categoryLabel: String
    let image: String?
}

enum Category: String, Codable {
    case genericFoods = "Generic foods"
}

enum CategoryLabel: String, Codable {
    case food = "food"
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal: Int
    let procnt, fat, chocdf: Double
    let fibtg: Int

    enum CodingKeys: String, CodingKey {
        case enercKcal
        case procnt
        case fat
        case chocdf
        case fibtg
    }
}

// MARK: - Measure
struct Measure: Codable {
    let uri: String
    let label: String
    let weight: Double
    let qualified: [Qualified]?
}

// MARK: - Qualified
struct Qualified: Codable {
    let qualifiers: [Qualifier]
    let weight: Int
}

// MARK: - Qualifier
struct Qualifier: Codable {
    let uri: String
    let label: Label
}

enum Label: String, Codable {
    case boneless = "boneless"
    case bonelessAndSkinless = "boneless and skinless"
    case skinless = "skinless"
    case small = "small"
    case whole = "whole"
}

// MARK: - Links
struct Links: Codable {
    let next: Next
}

// MARK: - Next
struct Next: Codable {
    let title: String
    let href: String
}

