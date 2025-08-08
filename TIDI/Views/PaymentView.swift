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
                // Title line
                Text(isTrial ? "Start Free Trial" : priceWithUnit)
                    .fontWeight(.bold)
                    .foregroundColor(isTrial ? .black : .white)
                    .padding(5)

                // Subtitle for trial
                if isTrial {
                    Text("7-day free trial, then \(priceWithUnit)")
                        .fontWeight(.regular)
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

    /// Called when *any* purchase completes successfully
    var onComplete: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color(hex: "#DDD4C8")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)

                // Iterate your [Product] by id:
                ForEach(paymentViewModel.products, id: \.id) { product in
                    PaymentOptionRow(product: product, onComplete: onComplete)
                        .environmentObject(paymentViewModel)  // pass down
                        .environmentObject(appViewModel)
                }
                .padding(.horizontal, 40)

                Text("Choose the purchase option that fits for you.")
                    .fontWeight(.thin)

                Spacer()
            }
            .task {
                do {
                    try await paymentViewModel.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }
}




#Preview {
    PaymentView()
        .environmentObject(PaymentViewModel())
        .environmentObject(AppViewModel())
}
