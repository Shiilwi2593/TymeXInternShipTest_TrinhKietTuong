//
//  UserDefaults.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//
import Foundation

//MARK: -BaseCurrency
func saveBaseCurrency(baseCurrency: [String: String]){
    let defaults = UserDefaults.standard
    defaults.set(baseCurrency, forKey: "baseCurrency")
}

func getBaseCurrency() -> [String: String] {
    let defaults = UserDefaults.standard
    return (defaults.dictionary(forKey: "baseCurrency") ?? ["VND": "Vietnamese Dong"]) as! [String: String]
}

//MARK: -ConverterCurrencyList
func saveConverterCurrency(converterCurrency: [[String: String]]){
    let defaults = UserDefaults.standard
    defaults.set(converterCurrency, forKey: "converterCurrency")
}

func getConverterCurrency() -> [[String: String]]? {
    let defaults = UserDefaults.standard
    return defaults.array(forKey: "converterCurrency") as? [[String: String]]
}


//MARK: -TargetCode
func saveTargetCode(targetCode: [String: String]){
    let defaults = UserDefaults.standard
    defaults.set(targetCode, forKey: "targetCode")
}

func getTargetCode() -> [String: String]{
    let defaults = UserDefaults.standard
    return (defaults.dictionary(forKey: "targetCode") ?? ["USD": "United States Dollar"]) as! [String: String]
}
