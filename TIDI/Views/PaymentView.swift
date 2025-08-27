//
//  PaymentView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 11/6/2025.
//

import SwiftUI
import StoreKit
import _Concurrency

struct PaymentOptionRow: View {
    let product: Product
    var onComplete: (() -> Void)?
    
    @EnvironmentObject private var paymentViewModel: PaymentViewModel
    @EnvironmentObject private var appViewModel:   AppViewModel
    
    // Is this product offering a free‐trial introductory offer?
    private var isTrial: Bool {
        product.subscription?.introductoryOffer?.paymentMode == .freeTrial
    }
    
    // Turn StoreKit's subscriptionPeriod into "month"/"year"
    private var unitString: String {
        guard let period = product.subscription?.subscriptionPeriod else {
            return "month"
        }
        switch period.unit {
        case .year:
            return period.value == 1 ? "year" : "\(period.value) years"
        case .month:
            return period.value == 1 ? "month" : "\(period.value) months"
        case .week:
            return period.value == 1 ? "week" : "\(period.value) weeks"
        case .day:
            return period.value == 1 ? "day" : "\(period.value) days"
        @unknown default:
            return "month"
        }
    }
    
    // Combined price + unit, e.g. "$14.99/month"
    private var priceWithUnit: String {
        "\(product.displayPrice)/\(unitString)"
    }
    
    var monthlyProduct: Product? {
        paymentViewModel.products.first {
            $0.subscription?.subscriptionPeriod.unit == .month
        }
    }

    var yearlyProduct: Product? {
        paymentViewModel.products.first {
            $0.subscription?.subscriptionPeriod.unit == .year
        }
    }
    
    var calculatedSavings: String? {
        guard let monthly = monthlyProduct,
              let yearly = yearlyProduct else {
            return nil
        }

        let monthlyPrice = Double(monthly.displayPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
        let yearlyPrice = Double(yearly.displayPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0

        let savings = (12 * monthlyPrice) - yearlyPrice
        return String(format: "$%.2f", savings)
    }
    
    
    var body: some View {
        Button {
            _Concurrency.Task {
                do {
                    try await paymentViewModel.purchase(product)
                    await MainActor.run {
                        appViewModel.hasActiveSubscription = true
                    }
                    onComplete?()
                } catch {
                    print(error)
                }
            }
        } label: {
            VStack {
                // Subtitle for trial
                if isTrial {
                    Text("\(priceWithUnit)")
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .padding(.top, 10)
                    
                    Divider()
                        .frame(height: 1) // Thickness
                        .background(Color.black.opacity(0.2)) // Color
                    
                    HStack{
                        Text("Premium Subscription Features")
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "#38a3a5"))
                            .font(.system(size: 15))
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            Text("7 day free trial")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15))
                        }
                        
                        
                        
                        if unitString == "year", let savingsText = calculatedSavings {
                            HStack(alignment: .top, spacing: 5) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))

                                (
                                    Text("Save ")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15)) +
                                    Text(savingsText)
                                        .bold()
                                        .foregroundColor(.black)
                                        .font(.system(size: 15)) +
                                    Text(" per year")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                )
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            Text("Unlimited business concept creation")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15))
                        }
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            Text("Unlimited AI-feedback generation")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15))
                        }
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            Text("Unlimited AI-generated task creation")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15))
                        }
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            Text("Full-Access to all features")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.top,10)
                    
                    
                }
                
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.white)
            .cornerRadius(20)
            
            
        }
    }
}

// ——————————————————————————
// Main view that lists all products
// ——————————————————————————
struct PaymentView: View {
    @EnvironmentObject private var paymentViewModel: PaymentViewModel
    @EnvironmentObject private var appViewModel:     AppViewModel
    var onComplete: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color(hex: "#DDD4C8").ignoresSafeArea()

            VStack(spacing: 12) {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)

                ForEach(paymentViewModel.products, id: \.id) { product in
                    PaymentOptionRow(product: product, onComplete: onComplete)
                        .environmentObject(paymentViewModel)
                        .environmentObject(appViewModel)
                }
                .padding(.horizontal, 40)

                // Restore Purchases (required by App Review)
                Button {
                    _Concurrency.Task { await paymentViewModel.restorePurchases(appVM: appViewModel) }
                } label: {
                    if paymentViewModel.isRestoring {
                        ProgressView("Restoring…")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    } else {
                        Text("Restore Purchases")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                }
                .disabled(paymentViewModel.isRestoring)
                .padding(.horizontal, 40)
                .background(Color.clear)

                if let err = paymentViewModel.restoreError {
                    Text(err)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 40)
                }

                Text("Choose the purchase option that fits for you.")
                    .fontWeight(.thin)
                // Optional: Add this for extra clarity
                Text("All features listed above require an active subscription.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
                    .padding(.top, 5)
            }
            .task {
                do { try await paymentViewModel.loadProducts() } catch { print(error) }
                // await paymentViewModel.updatePurchasedProducts()   // optional: reflect current entitlements
            }
        }
    }
}



#Preview {
    PaymentView()
        .environmentObject(PaymentViewModel())
        .environmentObject(AppViewModel())
}
