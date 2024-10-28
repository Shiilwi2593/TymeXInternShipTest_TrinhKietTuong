//
//  BaseCurrencyList.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//

import SwiftUI

struct BaseCurrencyList: View {
    @StateObject private var viewModel = OneToManyConverterViewVM()
    @State private var searchText = ""
    @Binding var baseCurrency: [String: String]
    
    var body: some View {
        List {
            ForEach(viewModel.currencySymbols
                .filter { searchText.isEmpty || $0.key.localizedCaseInsensitiveContains(searchText) || $0.value.localizedCaseInsensitiveContains(searchText) }
                .sorted { (lhs, rhs) -> Bool in
                    let lhsChecked = baseCurrency.keys.contains(lhs.key)
                    let rhsChecked = baseCurrency.keys.contains(rhs.key)
                    if lhsChecked != rhsChecked {
                        return lhsChecked && !rhsChecked
                    }
                    return lhs.key < rhs.key
                }, id: \.key
            ) { key, value in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(key)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(value)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    if baseCurrency.keys.contains(key) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    baseCurrency = [key: value]
                }
            }
        }
        .navigationTitle("Base currency list")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .toolbar, prompt: "Enter name or code")
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchSymbols()
                } catch {
                    print("Error fetching symbols: \(error)")
                }
            }
        }
    }
}
