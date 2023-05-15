//
//  EdamamParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/15/23.
//
//   let edamamParser = try? JSONDecoder().decode(EdamamParser.self, from: jsonData)

import Foundation

// MARK: - EdamamParser
struct EdamamParserResponse: Codable {
    let text: String
    let parsed: [Parsed]
    let hints: [Hint]
    let links: Links

    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
        case links = "_links"
    }
}

// MARK: - Hint
struct Hint: Codable {
    let food: EdamamFood
    let measures: [Measure]
}

// MARK: - Food
struct EdamamFood: Codable {
    let foodId, label, knownAs: String
    let nutrients: Nutrients
    let category: String
    let categoryLabel: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case foodId
        case label, knownAs, nutrients, category, categoryLabel, image
    }
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal: Double
    let procnt, fat, chocdf: Double
    let fibtg: Double

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procnt = "PROCNT"
        case fat = "FAT"
        case chocdf = "CHOCDF"
        case fibtg = "FIBTG"
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
    let label: String
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

// MARK: - Parsed
struct Parsed: Codable {
    let food: EdamamFood
}
