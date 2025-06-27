//
//  TIDIApp.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 4/2/2025.
//

import SwiftUI
import StoreKit
import _Concurrency

@main
struct TIDIApp: App {
    //    var body: some Scene {
    //        WindowGroup {
    //            SplashScreenView()
    //                .preferredColorScheme(.light)
    //        }
    //    }
    @StateObject var appViewModel = AppViewModel()
    @StateObject var paymentVM = PaymentViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appViewModel)
                .environmentObject(paymentVM)
                .preferredColorScheme(.light)
                .task {
                    await appViewModel.checkSubscriptionStatus()

                    _Concurrency.Task.detached(priority: .background) { [weak appViewModel] in
                        guard let appViewModel else { return }

                        for await update in Transaction.updates {
                            
                            print("Received transaction update: \(update)")
                            guard case .verified(let transaction) = update else {
                                print("Unverified transaction")
                                continue
                            }
                            print("Verified transaction: \(transaction.productID)")
                            await transaction.finish()

                            // reflect renewal / restore / revoke in the UI
                            await MainActor.run{
                                _Concurrency.Task {
                                    print("Refreshing subscription status after update")
                                    await appViewModel.checkSubscriptionStatus()
                                }
                            }
                        }
                    }
                }
        }
    }
}
