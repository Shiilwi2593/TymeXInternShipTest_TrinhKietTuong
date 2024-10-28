//
//  OneToOneConverterView.swift
//  CurrencyConverter
//
//  Created by Trịnh Kiết Tường on 26/10/24.
//


import SwiftUI

struct OneToOneConverterView: View {
    //MARK: -Properties
    @Binding var baseCurrency: [String: String]
    @Binding var targetCode: [String: String]
    
    @State private var amount: Double = 0
    @State private var convertAmount: Double = 0.0
    @State private var isReversed = false
    
    @StateObject private var oneToOneVM = OneToOneConverterVM()
    
    //MARK: -Body
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    BaseCodeSession(amount: $amount, baseCurrency: $baseCurrency)
                        .foregroundStyle(.black)
                        .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        Button(action: swapCurrencies) {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(isReversed ? 180 : 0))
                                .scaleEffect(isReversed ? 1.1 : 1.0)
                                .background(Circle().fill(Color.white))
                                .shadow(radius: 2)
                                .animation(.easeInOut(duration: 0.3), value: isReversed)
                        }
                        Spacer()
                    }
                    
                    TargetCodeSession(baseCurrency: $baseCurrency, convertAmount: $convertAmount, targetCode: $targetCode, oneToOneVM: oneToOneVM)
                        .padding(.vertical)
                }
            }
            .padding(.bottom, 20) 
        }
        .onAppear {
            Task {
                await fetchAndCalculateConversion()
            }
        }
        .onChange(of: amount) { _, newValue in
            convertAmount = oneToOneVM.calculateConvertedAmount(for: amount) ?? 0
        }
    }
    
    private func swapCurrencies() {
        isReversed.toggle()
        
        let tempBase = baseCurrency
        baseCurrency = targetCode
        targetCode = tempBase
        
        Task {
            await fetchAndCalculateConversion()
        }
    }
    
    private func fetchAndCalculateConversion() async {
        do {
            try await oneToOneVM.fetchPairConversionRate(baseCode: baseCurrency.keys.first!, targetCode: targetCode.keys.first!)
            convertAmount = oneToOneVM.calculateConvertedAmount(for: amount) ?? 0
        } catch {
            print("Error fetching conversion rate: \(error.localizedDescription)")
        }
    }
}


// MARK: - Extracted Views
struct BaseCodeSession: View {
    @Binding var amount: Double
    @Binding var baseCurrency: [String: String]
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("From")
                .font(.headline)
                .padding(.horizontal)
            
            NavigationLink(destination: BaseCurrencyList(baseCurrency: $baseCurrency)) {
                GroupBox {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(baseCurrency.keys.first ?? "EUR")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(baseCurrency.values.first ?? "Euro")
                                .font(.subheadline)
                        }
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
            }
            
            TextField("Enter amount", value: $amount, format: .number)
                .keyboardType(.decimalPad)
                .padding()
                .cornerRadius(10)
                .frame(width: 370, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .shadow(radius: 8)
                )
                .padding(.horizontal)
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

struct TargetCodeSession: View {
    @Binding var baseCurrency: [String: String]
    @Binding var convertAmount: Double
    @Binding var targetCode: [String: String]
    var oneToOneVM: OneToOneConverterVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("To")
                .font(.headline)
                .padding(.horizontal)
            
            NavigationLink(destination: TargetCodeCurrencyList(targetCode: $targetCode)) {
                GroupBox {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(targetCode.keys.first ?? "USD")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(targetCode.values.first ?? "American Dollar")
                                .font(.subheadline)
                        }
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.black)
                }
                .padding(.horizontal)
            }
            VStack(alignment: .trailing){
                TextField("Converted amount", value: $convertAmount, format: .currency(code: targetCode.keys.first ?? "USD"))
                    .disabled(true)
                    .allowsHitTesting(false)  // Disable targeting
                    .padding()
                    .cornerRadius(10)
                    .frame(width: 370, height: 80)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .cornerRadius(8)
                            .shadow(radius: 8)
                    )
                
                let baseCurrency = oneToOneVM.conversionData?.baseCode ?? "N/A"
                let targetCurrency = oneToOneVM.conversionData?.targetCode ?? "N/A"
                let rate = oneToOneVM.conversionData?.conversionRate ?? 0.0
                let formattedRate = String(format: "%.3f", rate)
                Text("1 \(baseCurrency) = \(formattedRate) \(targetCurrency)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                
                Text("Last update: \(formatLastUpdateDate(oneToOneVM.conversionData?.timeLastUpdateUTC ?? "N/A"))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
        }
    }
    
    func formatLastUpdateDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        guard let date = inputFormatter.date(from: dateString) else { return "N/A" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy, h:mm a"
        
        return outputFormatter.string(from: date)
    }
}
