//
//  ConverterCurrencyList.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 25/10/24.
//

import SwiftUI

struct ConverterCurrencyList: View {
    @StateObject private var viewModel = OneToManyConverterViewVM()
    @State private var searchText = ""
    @Binding var convertCurrency: [[String: String]]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.currencySymbols
                    .filter { searchText.isEmpty || $0.key.localizedCaseInsensitiveContains(searchText) || $0.value.localizedCaseInsensitiveContains(searchText) }
                    .sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(key)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text(value)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            let currency = [key: value]
                            if convertCurrency.contains(where: { $0 == currency}){
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let currency = [key: value]
                            if let index = convertCurrency.firstIndex(where: { $0 == currency }) {
                                convertCurrency.remove(at: index)
                            } else {
                                convertCurrency.append(currency)
                                print("appended")
                                print(convertCurrency)
                            }
                        }
                        
                        
                    }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Enter name or code")
        }
        .navigationTitle("Converter currency list")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            Task{
                do{
                    try await viewModel.fetchSymbols()
                } catch {
                    print("Error fetching symbols: \(error)")
                }
            }
        }
    }
    
}

//#Preview {
//    ConverterCurrencyList()
//}
