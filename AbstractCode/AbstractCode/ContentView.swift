//
//  ContentView.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  
  var body: some View {
    VStack {
      Image(uiImage: viewModel.cardImage)
        .resizable()
        .frame(width: 230, height: 300)
      stateText
        .padding(20)
      HStack {
        Button("Draw new card") {
          viewModel.getNewHand()
        }
        Spacer()
        Button("Reshuffle") {
          viewModel.reshuffleDeck()
        }
      }
      .padding(20)
    }
  }
  
  // MARK: Setup View
  private var stateText: Text {
    switch viewModel.state {
    case .fetching:
      return Text("Loading hand...")
    case .playing(let hand):
      return Text("Available cards in deck: \(hand.remaining)")
    case .error(let message):
      return Text(message)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
