//
//  Record.swift
//  Mashow
//
//  Created by Kai Lee on 9/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct RecordStatResponse: Decodable {
    let code: Int
    let message: String
    let value: RecordStat
}

struct RecordStat: Decodable, Equatable, Hashable {
    let id: UUID
    let names: [Name]
    let frequencyPercentage: Int

    init(names: [Name], frequencyPercentage: Int) {
        self.id = UUID()
        self.names = names
        self.frequencyPercentage = frequencyPercentage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Generate a new UUID instead of decoding it
        self.id = UUID()
        self.names = try container.decode([Name].self, forKey: .names)
        self.frequencyPercentage = try container.decode(Int.self, forKey: .frequencyPercentage)
    }

    private enum CodingKeys: String, CodingKey {
        case names
        case frequencyPercentage
    }

    struct Name: Decodable {
        let name: String
        let count: Int
    }

    // Equatable conformance
    static func == (lhs: RecordStat, rhs: RecordStat) -> Bool {
        lhs.id == rhs.id
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
