//
//  ContentView.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import SwiftUI

struct ContentView: View {
  let viewModel = ViewModel()
  
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
