//
//  ContentView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 16.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("login_status") var login_status = false
    
    var body: some View {
        if login_status {
            MainScreen()
                .preferredColorScheme(.dark)
        } else {
            MainAuthScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
