// MIT License
//
// Copyright (c) 2022 Iosif
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
