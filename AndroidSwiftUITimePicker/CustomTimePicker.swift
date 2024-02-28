//
//  CustomTimePicker.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

public struct CustomTimePickerView: View {
  @State private var selectedHour = 12
  @State private var selectedMinutes = 0
  @State private var isAMSelected = true
  @State private var isHourSelected = true
  @State private var isKeyboardSelected = false
  @State private var hourText = ""
  @State private var minuteText = ""
  @Binding var okPressed: Bool
  @Binding var cancelPressed: Bool
  @Binding var selectedDate: Date
  
  private var dateComponentsHour = 0
  
  public init(isKeyboardSelected: Bool = false, okPressed: Binding<Bool>, cancelPressed: Binding<Bool>, selectedDate: Binding<Date>) {
    _okPressed = okPressed
    _cancelPressed = cancelPressed
    _selectedDate = selectedDate
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute], from: selectedDate.wrappedValue)
    
    if let hour = dateComponents.hour {
      dateComponentsHour = hour
      let hourIn12HourFormat = hour % 12
      _selectedHour = State(initialValue: hourIn12HourFormat == 0 ? 12 : hourIn12HourFormat) // 0 means 12 in 12-hour format
      _hourText = State(initialValue: String(format: "%02d", selectedHour))
    }
    
    if let minute = dateComponents.minute {
      _selectedMinutes = State(initialValue: minute)
      _minuteText = State(initialValue: String(format: "%02d", selectedMinutes))
    }
  }
  
  public var body: some View {
    VStack {
      HStack {
        Text("Select time")
          .font(.system(size: 14, weight: .medium))
        
        Spacer()
      }
      .padding(.leading, 40)
      // MARK: CLOCK TYPE
      VStack {
        HStack {
          Spacer()
          Button(action: {
            isHourSelected = true
          }) {
            Text(selectedHour < 10 ? "0\(selectedHour)" : "\(selectedHour)")
              .font(.system(size: 57, weight: .medium))
              .foregroundColor(isHourSelected ? .white : .black)
              .padding()
              .background(isHourSelected ? Color.teal : Color.gray)
              .cornerRadius(10)
          }
          
          Text(":")
            .font(.system(size: 36, weight: .medium))
            .foregroundColor(.black)
          
          Button(action: {
            isHourSelected = false
          }) {
            Text(selectedMinutes < 10 ? "0\(selectedMinutes)" : "\(selectedMinutes)")
              .font(.system(size: 57, weight: .medium))
              .foregroundColor(!isHourSelected ? .white : .black)
              .padding()
              .background(!isHourSelected ? Color.teal : Color.gray)
              .cornerRadius(10)
          }
          
          VStack(spacing: 0) {
            Button(action: {
              isAMSelected = true
            }) {
              Text("AM")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isAMSelected ? Color.white : Color.black)
                .padding()
                .background(isAMSelected ? Color.teal : Color.gray)
                .cornerRadius(8, corners: [.topLeft, .topRight])
            }
            .frame(height: 36)
            .padding(.bottom, 16)
            
            Button(action: {
              isAMSelected = false
            }) {
              Text("PM")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(!isAMSelected ? Color.white : Color.black)
                .padding()
                .background(!isAMSelected ? Color.teal : Color.gray)
                .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
            }
            .frame(height: 36)
          }
          .padding(.leading)
          
          Spacer()
        }
        .padding()
        
        CircularHourPicker(selectedHour: $selectedHour)
          .frame(width: 300, height: 300)
          .visibility(isHourSelected ? .visible : .gone)
        
        CircularMinutePicker(selectedMinute: $selectedMinutes)
          .frame(width: 300, height: 300)
          .visibility(!isHourSelected ? .visible : .gone)
      }
      .visibility(isKeyboardSelected ? .gone : .visible)
      
      CustomKeyboardTimeView(isAMSelected: $isAMSelected, isKeyboardSelected: $isKeyboardSelected, selectedHour: $selectedHour, selectedMinute: $selectedMinutes)
        .visibility(isKeyboardSelected ? .visible : .gone)
      
      HStack {
        if isKeyboardSelected {
          Image("clock")
            .frame(width: 20, height: 14)
            .onTapGesture {
              isKeyboardSelected.toggle()
            }
        } else {
          Image("keyboard")
            .frame(width: 20, height: 14)
            .onTapGesture {
              isKeyboardSelected.toggle()
            }
        }
        
        Spacer()
        Button(action: {
          cancelPressed.toggle()
        }) {
          Text("Cancel")
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color.teal)
            .padding()
        }
        
        Button(action: {
          let calendar = Calendar.current
          var dateComponents = calendar.dateComponents([.hour, .minute], from: Date())
          
          if isAMSelected {
            dateComponents.hour = selectedHour == 12 ? 0 : selectedHour
          } else {
            dateComponents.hour = selectedHour == 12 ? 12 : selectedHour + 12
          }
          
          dateComponents.minute = selectedMinutes
          
          if let date = calendar.date(from: dateComponents) {
            selectedDate = date
          }
          okPressed.toggle()
        }) {
          Text("Ok")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color.teal)
            .padding()
        }
      }
      .padding(.leading, 20)
      .padding()
    }
    .onAppear {
      isAMSelected = dateComponentsHour < 12
    }
  }
}

public struct CustomKeyboardTimeView: View {
  @Binding private var isAMSelected: Bool
  @Binding private var isKeyboardSelected: Bool
  
  @Binding private var selectedHour: Int
  @Binding private var selectedMinute: Int
  
  private var hourText: Binding<String> {
    Binding<String>(get: { String(format: "%02d", selectedHour) }, set: { selectedHour = Int($0) ?? 00 })
  }

  private var minuteText: Binding<String> {
    Binding<String>(get: { String(format: "%02d", selectedMinute) }, set: { selectedMinute = Int($0) ?? 00 })
  }
  
  @State private var isEditingHour: Bool = false
  @State private var isEditingMinute: Bool = false
  
  public init(isAMSelected: Binding<Bool>, isKeyboardSelected: Binding<Bool>, selectedHour: Binding<Int>, selectedMinute: Binding<Int>) {
    _isAMSelected = isAMSelected
    _isKeyboardSelected = isKeyboardSelected
    _selectedHour = selectedHour
    _selectedMinute = selectedMinute
  }
  
  private func isHourValid(input: String) -> Bool {
    if let number = Int(input) {
      return (0 ... 12).contains(number)
    }
    return false
  }
  
  private func isMinuteValid(input: String) -> Bool {
    if let number = Int(input) {
      return (0 ... 60).contains(number)
    }
    return false
  }
  
  public var body: some View {
    VStack {
      HStack {
        TextField("", text: hourText, onEditingChanged: { isEditing in
          isEditingHour = isEditing
        })
        .onChange(of: isEditingHour) {
            guard !isEditingHour else { return }
            guard !isHourValid(input: hourText.wrappedValue) else { return }
            selectedHour = 8
        }
        .keyboardType(.numberPad)
        .font(.system(size: 45, weight: .medium))
        .foregroundColor(isEditingHour ? .white : .black)
        .padding()
        .background(isEditingHour ? Color.teal : Color.gray)
        .cornerRadius(10)
        .multilineTextAlignment(.center)
        .frame(width: 100)
        .lineLimit(1)
        
        Text(":")
          .font(.system(size: 36, weight: .medium))
          .foregroundColor(Color.black)
        
        TextField("", text: minuteText, onEditingChanged: { isEditing in
          isEditingMinute = isEditing
        })
        .onChange(of: isEditingMinute) {
          guard !isEditingMinute else { return }
          guard !isMinuteValid(input: minuteText.wrappedValue) else { return }
          selectedMinute = 0
        }
        .keyboardType(.numberPad)
        .font(.system(size: 45, weight: .medium))
        .foregroundColor(isEditingMinute ? .white : .black)
        .padding()
        .background(isEditingMinute ? Color.teal : Color.gray)
        .cornerRadius(10)
        .multilineTextAlignment(.center)
        .frame(width: 100)
        .lineLimit(1)
        
        VStack(spacing: 0) {
          Button(action: {
            isAMSelected = true
          }) {
            Text("AM")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(isAMSelected ? Color.white : Color.black)
              .padding()
              .background(isAMSelected ? Color.teal : Color.gray)
              .cornerRadius(8, corners: [.topLeft, .topRight])
          }
          .frame(height: 36)
          .padding(.bottom, 16)
          
          Button(action: {
            isAMSelected = false
          }) {
            Text("PM")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(!isAMSelected ? Color.white : Color.black)
              .padding()
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.gray, lineWidth: 2)
              )
              .background(!isAMSelected ? Color.teal : Color.gray)
              .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
          }
          .frame(height: 36)
        }
        .padding(.leading)
      }
    }
  }
}

public struct CustomTimePickerView_Previews: PreviewProvider {
  public static var previews: some View {
    let calendar = Calendar.current
    
    var customDate = Date()
    
    let desiredComponents = DateComponents(year: 2020, month: 5, day: 10, hour: 11, minute: 35, second: 0)
    customDate = calendar.date(from: desiredComponents)!
        
    return CustomTimePickerView(okPressed: .constant(false), cancelPressed: .constant(false), selectedDate: .constant(customDate))
  }
}

