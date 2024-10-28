//
//  ConverterView.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 23/10/24.
//

import SwiftUI

// MARK: - Main Converter View
struct ConverterView: View {
    
    //MARK: -Properties
    private let conversionTypes = ["One to one", "One to many"]
    @State private var selectedType = "One to one"
    @State private var baseCurrency: [String: String] = [:]
    @State private var convertCurrency: [[String: String]] = []
    
    @State private var targetCode: [String: String] = [:]
    
    //MARK: -Body
    var body: some View {
        NavigationStack{
            VStack {
                //SelectedCategory
                conversionTypeSelection
                
                //ConverterView
                converterView
            }
            .navigationTitle("💲 Converter")
            .navigationBarTitleDisplayMode(.large)
            //MARK: -UpdateData
            .onAppear {
                loadCurrencies()
            }
            .onChange(of: baseCurrency) { _, newValue in
                saveBaseCurrency(baseCurrency: baseCurrency)
            }
            .onChange(of: convertCurrency) { _, newValue in
                saveConverterCurrency(converterCurrency: newValue)
            }
            .onChange(of: targetCode){_, newValue in
                saveTargetCode(targetCode: targetCode)
            }
        }
    }
    
    // MARK: - Extracted Views
    private var conversionTypeSelection: some View {
        HStack {
            ForEach(conversionTypes, id: \.self) { type in
                Text(type)
                    .padding(6)
                    .background(selectedType == type ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.2))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedType = type
                    }
            }
            Spacer()
        }
        .padding()
    }
    
    private var converterView: some View {
        VStack {
            Group {
                if selectedType == "One to one" {
                    OneToOneConverterView(baseCurrency: $baseCurrency, targetCode: $targetCode)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    OneToManyConverterView(baseCurrency: $baseCurrency, convertCurrency: $convertCurrency)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.default, value: selectedType)
        }
    }
    
    // MARK: -Helper func
    private func loadCurrencies() {
        baseCurrency = getBaseCurrency()
        convertCurrency = getConverterCurrency() ?? []
        targetCode = getTargetCode()
    }
}

