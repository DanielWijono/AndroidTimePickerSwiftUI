//
//  ContentView.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

struct ContentView: View {
  @State private var showingTimePicker = false
  @State private var okPressed = false
  @State private var cancelPressed = false
  @State private var selectedDate = Date()
  
  var body: some View {
    VStack {
      Text("Select your Time Here")
        .padding(.bottom, 16)
      
      Text("Current time : \(selectedDate, formatter: dateFormatter)")
    }
    .onTapGesture {
      showingTimePicker = true
    }
    .fullScreenCover(isPresented: $showingTimePicker) {
      CustomTimePickerView(okPressed: $showingTimePicker, cancelPressed: $showingTimePicker, selectedDate: $selectedDate)
    }
    .padding()
    .background(Rectangle().foregroundColor(.teal))
    .cornerRadius(16)
  }
}

// Date formatter for displaying the selected date
private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .none
  formatter.timeStyle = .short
  return formatter
}()

#Preview {
  ContentView()
}
