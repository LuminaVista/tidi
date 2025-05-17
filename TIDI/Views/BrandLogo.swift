//
//  BrandLogo.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/5/2025.
//

import SwiftUI

struct BrandLogo: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @ObservedObject var brandVM = BrandViewModel()
    let businessIdeaId: Int
    @State private var tagline: String = ""
    @State private var selectedPalette: [String] = []
    @State private var isLoading = false
    @State private var logoImageURL: String?
    
    let palettes: [String: [String]] = [
        "Green":  ["#f0f4c3", "#e6ee9c", "#aed581", "#81c784", "#66bb6a", "#388e3c", "#2e7d32"],
        "Red":    ["#f8bbd0", "#f06292", "#e91e63", "#d32f2f", "#b71c1c", "#7f0000"],
        "Orange": ["#f4a261", "#f68c1f", "#e76f51", "#e65100", "#bf360c", "#8d6e63"],
        "Yellow": ["#fffde7", "#fff59d", "#fff176", "#ffee58", "#fdd835", "#fbc02d"],
        "Blue":   ["#e1f5fe", "#81d4fa", "#4fc3f7", "#29b6f6", "#0288d1", "#01579b"],
        "Purple": ["#f3e5f5", "#ce93d8", "#ab47bc", "#8e24aa", "#6a1b9a", "#4a148c"],
        "Pink":   ["#f8bbd0", "#f48fb1", "#f06292", "#ec407a", "#d81b60", "#880e4f"],
        "Grey":   ["#f5f5f5", "#e0e0e0", "#bdbdbd", "#9e9e9e", "#616161", "#212121"]
    ]
    
    var body: some View {
        ScrollView {
            HStack {
                Button(action: {
                    dismiss() // Modern back navigation
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding(.leading, 15)
                .padding(.top, 10)
                Spacer()
                Text("Brand: AI Generated Logo").font(.headline)
                    .padding(.trailing, 20)
                Spacer()
            }
            
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Tagline")
                    .font(.headline)
                
                TextField("Promotional tagline for business", text: $tagline)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                VStack{
                    HStack{
                        Text("Colour theme")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    ForEach(palettes.sorted(by: { $0.key < $1.key }), id: \.key) { key, colors in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack{
                                Text(key)
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.leading, 8)
                                Spacer()
                                HStack {
                                    ForEach(colors, id: \.self) { hex in
                                        Circle()
                                            .fill(Color(hex: hex))
                                            .frame(width: 25, height: 25)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedPalette.contains(hex) ? Color.black : Color.clear, lineWidth: 3)
                                            )
                                            .onTapGesture {
                                                if selectedPalette.contains(hex) {
                                                    selectedPalette.removeAll(where: { $0 == hex })
                                                } else {
                                                    selectedPalette.append(hex)
                                                }
                                            }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                .padding(10)
                
                // 🖼️ Render Image
                if let logoURL = brandVM.logoImageUrl {
                    AsyncImage(url: URL(string: logoURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 240)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                            
                        case .failure:
                            Text("❌ Failed to load image")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Button(action: {
                    brandVM.generateLogo(
                        businessIdeaId: businessIdeaId,
                        tagline: tagline,
                        palette: selectedPalette
                    )
                }) {
                    HStack {
                        if brandVM.logoLoading {
                            ProgressView()
                        } else {
                            Text("Generate Logo")
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#DDD4C8"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .disabled(tagline.isEmpty || selectedPalette.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BrandLogo(businessIdeaId: 97)
}
