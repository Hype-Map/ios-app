//
//  HypeMark.swift
//  Hype Map
//
//  Created by Артем Соловьев on 24.01.2023.
//

import SwiftUI
import MapKit

struct HypeMark: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    var batteryLevel: Float
    var charge: UIDevice.BatteryState
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(Color.white, lineWidth: 5)
                .overlay(content: {
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [Color.white, Color.white.opacity(0.3)]), startPoint: .top, endPoint: .bottom).opacity(0.6))
                        .cornerRadius(3)
                        .background(.ultraThinMaterial)
                    Text("Онлайн")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                })
                .frame(maxWidth: 45, maxHeight: 18)
                .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                Circle()
                    .overlay {
                        Image("Cat")
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .padding(4)
                    }
                    .frame(width: 50, height: 50)
                    .scaleEffect(CGSize(width: viewModel.breathEffect, height: viewModel.breathEffect))
                Image("triangle")
                    .frame(width: 17, height: 18)
                    .offset(y: -5)
            }
            
            RoundedRectangle(cornerRadius: 19)
                .strokeBorder(Color.white, lineWidth: 5)
                .overlay(content: {
                    ZStack {
                        LinearGradient(gradient: .init(colors: [charge == .charging || charge == .full ? Color.yellow : Color.white, charge == .charging || charge == .full ? Color.yellow.opacity(0.8) : Color.white.opacity(0.3)]), startPoint: .top, endPoint: .bottom).opacity(charge == .charging || charge == .full ? 0.6 : 0.6)
                            .animation(.spring(), value: charge)
                            .background(.ultraThinMaterial)
                        
                        HStack(spacing: 3) {
                            Image("battery")
                            Text("\(Int(batteryLevel))" + " %")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                    .cornerRadius(3)
                })
                .frame(maxWidth: 50, maxHeight: 18)
                .padding(.top, 10)
            
        }
        .environmentObject(viewModel)
        .foregroundColor(Color.pinkColor)
//        .frame(maxHeight: 111)
    }
}
