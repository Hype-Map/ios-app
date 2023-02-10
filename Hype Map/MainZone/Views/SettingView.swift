//
//  SettingView.swift
//  Hype Map
//
//  Created by Артем Соловьев on 25.01.2023.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Button {
                viewModel.logOut()
            } label: {
                Text("Выйти")
            }

        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(MainViewModel())
    }
}
