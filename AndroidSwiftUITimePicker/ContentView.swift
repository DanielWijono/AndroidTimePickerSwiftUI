//
//  ContentView.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

struct ContentView: View {
  @State private var showingTimePicker = false
  
  var body: some View {
    VStack {
      Text("Select your Time Here")
        .padding(.bottom, 16)
      
      Text("Current time : ")
    }
    .onTapGesture {
      showingTimePicker = true
    }
    .sheet(isPresented: $showingTimePicker) {
      // Present the CustomTimePickerView when showingTimePicker is true
      CustomTimePickerView(okPressed: .constant(false), cancelPressed: .constant(false), selectedDate: .constant(Date()))
    }
    .padding()
    .background(Rectangle().foregroundColor(.teal))
    .cornerRadius(16)
  }
}

#Preview {
  ContentView()
}
