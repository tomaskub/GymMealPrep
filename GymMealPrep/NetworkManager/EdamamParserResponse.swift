//
//  EdamamParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/15/23.
//

import Foundation

// MARK: - EdamamParser
struct EdamamParserResponse: Codable {
    let text: String?
    let parsed: [Parsed]?
    let hints: [Hint]
    let links: Links

    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
        case links = "_links"
    }
    // MARK: - Hint
    struct Hint: Codable {
        let food: EdamamFood
        let measures: [Measure]
    }
    // MARK: - Food
    struct EdamamFood: Codable, Identifiable {
        var id: String
        let label, knownAs: String
        let nutrients: Nutrients
        let category: String
        let categoryLabel: String
        let image: String?

        enum CodingKeys: String, CodingKey {
            case id = "foodId"
            case label, knownAs, nutrients, category, categoryLabel, image
        }
    }

    // MARK: - Nutrients
    struct Nutrients: Codable {
        let enercKcal: Double?
        let protein, fat, carbs: Double?
        let fibtg: Double?

        enum CodingKeys: String, CodingKey {
            case enercKcal = "ENERC_KCAL"
            case protein = "PROCNT"
            case fat = "FAT"
            case carbs = "CHOCDF"
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
        let weight: Double
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
        let quantity: Double?
        let measure: Measure?
    }
}



