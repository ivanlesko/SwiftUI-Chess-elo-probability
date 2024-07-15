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
            .frame(height: 150)
            
            VStack(alignment: .leading) {
                Text("Player 1 has a \(Int(round(viewModel.expectedScores.0 * 100)))% chance of winning")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom, 10)
                Text("Player 2 has a \(Int(round(viewModel.expectedScores.1 * 100)))% chance of winning")
                    .font(.system(size: 20, weight: .medium))
            }
            .padding(.horizontal)
            .padding(.top)

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
