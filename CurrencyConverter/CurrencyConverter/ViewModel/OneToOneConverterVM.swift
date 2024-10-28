//
//  OneToOneConverterVM.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 27/10/24.
//

import Foundation

class OneToOneConverterVM: ObservableObject{
    @Published var conversionData: PairConversionResponse?
    let apiKey = "3c4fd3b31b18e3415f23e057"
    
    //FetchPaỉrConversionRate
    func fetchPairConversionRate(baseCode: String, targetCode: String) async throws{
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/pair/\(baseCode)/\(targetCode)") else {
            throw ErrorHandling.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw ErrorHandling.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(PairConversionResponse.self, from: data)
            DispatchQueue.main.async {
                self.conversionData = decodedResponse
            }
        } catch  {
            throw ErrorHandling.decodeError
        }
    }
    
    //CalculateConvertedAmount
    func calculateConvertedAmount(for amount: Double) -> Double? {
        guard let rate = conversionData?.conversionRate else {
            return nil
        }
        return amount * rate
    }
}
