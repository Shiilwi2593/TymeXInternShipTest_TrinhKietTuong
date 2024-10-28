//
//  TargetCodeCurrencyList.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 27/10/24.
//

import SwiftUI

struct TargetCodeCurrencyList: View {
    @StateObject var viewModel = OneToManyConverterViewVM()
    @State private var searchText: String = ""
    @Binding var targetCode: [String: String]
    
    var body: some View {
        List {
            ForEach(viewModel.currencySymbols
                .filter { searchText.isEmpty || $0.key.localizedCaseInsensitiveContains(searchText) || $0.value.localizedCaseInsensitiveContains(searchText) }
                .sorted { (lhs, rhs) -> Bool in
                    let lhsChecked = targetCode.keys.contains(lhs.key)
                    let rhsChecked = targetCode.keys.contains(rhs.key)
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
                    
                    if targetCode.keys.contains(key) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    targetCode = [key: value]
                }
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Enter name or code")
        .navigationTitle("Target Currency List")
        .navigationBarTitleDisplayMode(.inline)
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

