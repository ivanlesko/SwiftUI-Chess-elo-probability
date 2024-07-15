//
//  ContentView.swift
//  Chess Elo Calculator
//
//  Created by IvanL on 7/13/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = EloViewModel()
    
    @State private var user1EloString = ""
    @State private var user2EloString = ""
    
    var body: some View {
        VStack {
            Text("Chess elo probability")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Form {
                Section(header: Text("Enter player info")) {
                    TextField("Player 1 elo", text: $user1EloString)
                        .keyboardType(.numberPad)
                        .onChange(of: user1EloString) { newValue in
                            viewModel.setUser1Elo(Int(newValue))
                        }
                    
                    TextField("Player 2 elo", text: $user2EloString)
                        .keyboardType(.numberPad)
                        .onChange(of: user2EloString) { newValue in
                            viewModel.setUser2Elo(Int(newValue))
                        }
                }
            }
            .frame(height: 160)
            
            VStack(spacing: 10) {
                Text("Player 1's chance of winning")
                    .font(.title2)
                
                Text("\(Int(round(viewModel.expectedScores.0 * 100)))%")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 24)
                    .foregroundColor(viewModel.user1Color)
                
                Text("Player 2's chance of winning")
                    .font(.title2)
                
                Text("\(Int(round(viewModel.expectedScores.1 * 100)))%")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(viewModel.user2Color)
            }

            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
