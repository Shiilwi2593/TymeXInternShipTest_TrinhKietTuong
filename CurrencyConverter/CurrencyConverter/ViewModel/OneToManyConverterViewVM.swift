//
//  OneToOneConverterViewVM.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//

import Foundation

class OneToManyConverterViewVM: ObservableObject{
    @Published var currencySymbols: [String: String] = [:]
    @Published var baseRatesRespone: BaseRatesResponse?
    let apiKey = "7bef9de0b7a773791fa66c9b96f9809f"
    
    //FetchSymbols
    func fetchSymbols() async throws{
        guard let url = URL(string: "https://api.exchangeratesapi.io/v1/symbols?access_key=\(apiKey)") else {
            throw ErrorHandling.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorHandling.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let symbolsResponse = try decoder.decode(SymbolsResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.currencySymbols = symbolsResponse.symbols
                print(self.currencySymbols)
            }
        } catch {
            throw ErrorHandling.decodeError
        }
    }
    
    //FetchRates
    func fetchRates(base: String, symbols: [String]) async throws {
        guard let url = URL(string: "https://api.exchangeratesapi.io/v1/latest?access_key=\(apiKey)&symbols=\(symbols.joined(separator: ","))") else {
            throw ErrorHandling.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorHandling.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let ratesResponse = try decoder.decode(BaseRatesResponse.self, from: data)
            DispatchQueue.main.async {
                self.baseRatesRespone = ratesResponse
                print("Fetched rates for base \(base):", self.baseRatesRespone?.rates ?? [:])
            }
            
        } catch  {
            throw ErrorHandling.decodeError
        }
    }
    
    //CalculateAmount
    func calculateAmount(amount: Double, symbols: String) -> (convertedAmount: Double, rate: Double)? {
        guard let rates = baseRatesRespone?.rates[symbols] else {
            return nil
        }
        let convertedAmount = amount * rates
        return (convertedAmount, rates)
    }
}
