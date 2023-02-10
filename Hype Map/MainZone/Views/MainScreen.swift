//
//  MainScreen.swift
//  Hype Map
//
//  Created by Артем Соловьев on 17.01.2023.
//

import SwiftUI
import Firebase
import MapKit

struct MainScreen: View {
    
    @StateObject private var viewModel = MainViewModel()
    @AppStorage("login_status") var login_status = false
    
    private var batteryLevel: Float {
        return UIDevice.current.batteryLevel * 100
    }
    
    private var batteryState: UIDevice.BatteryState {
        return withAnimation(.spring()) {
            UIDevice.current.batteryState
        }
    }
    
    private let generator = UINotificationFeedbackGenerator()
    
    @State var settingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                mapView
                
                VStack {
                    
                    VStack(spacing: 12) {
                        HStack(alignment: .center) {
                            HypeGlassButton(imageButton: "friend_button", width: 50, height: 50) {
                                
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text(viewModel.nameCity)
                                    .font(.system(size: 20))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                HStack {
                                    Image(viewModel.iconWeather)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    Text(String(viewModel.temp))
                                        .font(.system(size: 16))
                                        .bold()
                                }
                            }
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            HypeGlassButton(imageButton: "setting_button", width: 50, height: 50) {
                                settingSheet.toggle()
                            }
                        }
                        .frame(height: 70)
                        .padding(.horizontal, 16)
                        .padding(.top, 5)
                        
                        HStack {
                            Spacer()
                            
                            HypeGlassButton(imageButton: "layer_button", width: 50, height: 50) {
                                
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 14) {
                        HypeGlassButton(imageButton: "message_button", width: 50, height: 50) {
                            
                        }
                        
                        if viewModel.showLocationButton {
                            HypeGlassButton(imageButton: "location_button", width: 70, height: 70) {
                                viewModel.goToCurrentLocation()
                                let haptic = UIImpactFeedbackGenerator(style: .light)
                                haptic.impactOccurred()
                            }
                        }
                        
                        HypeGlassButton(imageButton: "profile_button", width: 50, height: 50) {
                            
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .environmentObject(viewModel)
            .sheet(isPresented: $settingSheet) {
                SettingView()
                    .environmentObject(viewModel)
                    .background(.ultraThinMaterial)
                    .onAppear() {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                            return
                        }
                        controller.view.backgroundColor = UIColor(Color.pinkColor)
                    }
            }
            .onAppear() {
                if NetworkMonitor.shared.isConnected {
                    print("connected")
                } else {
                    print("not connected")
                }
            }
        }
    }
    
    //MARK: - Map View + mark users
    private var mapView: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                HypeMark(batteryLevel: batteryLevel, charge: batteryState)
                    .frame(width: 80, height: 95)
                    .padding(.bottom, 70)
                    .onTapGesture {
                        let haptic = UIImpactFeedbackGenerator(style: .soft)
                        haptic.impactOccurred()
                        viewModel.goToCurrentLocation()
                    }
                    .animation(.spring(), value: viewModel.breathEffect)
            }
        }
        .animation(.spring(), value: viewModel.lat)
        .animation(.spring(), value: viewModel.lon)
        .ignoresSafeArea(.all)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
