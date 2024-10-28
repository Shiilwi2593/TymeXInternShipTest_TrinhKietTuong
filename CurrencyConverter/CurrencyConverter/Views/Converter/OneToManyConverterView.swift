//
//  OneToOneConverterView.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//

import SwiftUI

struct OneToManyConverterView: View {
    // MARK: - Properties
    @State private var amount: Double = 1
    @Binding var baseCurrency: [String: String]
    @Binding var convertCurrency: [[String: String]]
    @StateObject private var viewModel = OneToManyConverterViewVM()
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                BaseCurrencyField(amount: $amount, baseCurrency: $baseCurrency)
                
                ScrollView {
                    LazyVStack {
                        ForEach(convertCurrency, id: \.self) { currency in
                            if let key = currency.keys.first, let value = currency.values.first {
                                ConvertCurrencyCell(key: key, value: value, viewModel: viewModel, baseCurrency: $baseCurrency, amount: $amount)
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            
            addCurrencyButton
                .padding(.trailing, 20)
                .padding(.bottom, 30)
        }
        .onAppear {
            let base = baseCurrency.keys.first ?? "EUR"
            let symbols = convertCurrency.compactMap { $0.keys.first }
            
            Task {
                do {
                    print(symbols)
                    try await viewModel.fetchRates(base: base, symbols: symbols)
                } catch {
                    print("Error fetching rates:", error)
                }
            }
        }
    }
    
    private var addCurrencyButton: some View {
        NavigationLink(destination: ConverterCurrencyList(convertCurrency: $convertCurrency)) {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .shadow(radius: 2)
                .overlay {
                    Image(systemName: "plus")
                }
        }
    }
}



// MARK: - Extracted Views
struct BaseCurrencyField: View {
    @Binding var amount: Double
    @Binding var baseCurrency: [String: String]
    @FocusState var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 1){
            NavigationLink(destination: BaseCurrencyList(baseCurrency: $baseCurrency), label: {
                HStack{
                    GroupBox{
                        HStack{
                            VStack(alignment: .leading, spacing: 4){
                                Text(baseCurrency.keys.first ?? "VND")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                Text(baseCurrency.values.first ?? "Vietnamese Dong")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                                
                            }
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                }
                .padding(.leading)
                
                
            })
            
            
            TextField("Enter amount...", value: $amount, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .padding()
                .cornerRadius(10)
                .frame(width: 370, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .shadow(radius: 8)
                )
                .padding()
                .focused($isInputFocused)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack{
                            Spacer()
                            Button("Done") {
                                isInputFocused = false
                            }
                        }
                        .padding()
                    }
                }
        }
    }
    
}


struct ConvertCurrencyCell: View {
    var key: String
    var value: String
    @ObservedObject var viewModel: OneToManyConverterViewVM
    @Binding var baseCurrency: [String: String]
    @Binding var amount: Double
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(key)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(value)
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    if let (convertedAmount, rate) = viewModel.calculateAmount(amount: amount, symbols: key) {
                        Text(formatCurrency(convertedAmount))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("1 \(baseCurrency.keys.first ?? "") = \(formatRate(rate)) \(key)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    } else {
                        Text("N/A")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
            }
            Divider()
                .padding()
        }
        .padding([.leading, .trailing], 21)
    }
    
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    private func formatRate(_ rate: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 5
        formatter.maximumFractionDigits = 5
        return formatter.string(from: NSNumber(value: rate)) ?? "\(rate)"
    }
    
}
