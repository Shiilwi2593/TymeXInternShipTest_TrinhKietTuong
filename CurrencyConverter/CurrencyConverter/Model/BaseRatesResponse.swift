//
//  BaseRatesResponse.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 26/10/24.
//

import Foundation

struct BaseRatesResponse: Codable{
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}

