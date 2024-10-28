//
//  Symbols.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//

import Foundation
struct SymbolsResponse: Codable {
    let success: Bool
    let symbols: [String: String]
}
