//
//  PairConversionResponse.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 27/10/24.
//

import Foundation
struct PairConversionResponse: Codable{
    let timeLastUpdateUTC: String
    let baseCode: String
    let targetCode: String
    let conversionRate: Double
    
    enum CodingKeys: String, CodingKey{
        case timeLastUpdateUTC = "time_last_update_utc"
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}
