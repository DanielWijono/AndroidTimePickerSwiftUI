//
//  CircularHourPicker.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

public struct CircularHourPicker: View {
  @Binding var selectedHour: Int
  
  public var body: some View {
    GeometryReader { geometry in
      Circle()
        .fill(Color.gray.opacity(0.2))
      
      ForEach(1 ..< 13) { hour in
        ZStack {
          if hour == selectedHour {
            Circle()
              .foregroundColor(Color.teal)
              .frame(width: 40, height: 40)
          }
          Text("\(hour)")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color.black)
            .foregroundColor(hour == selectedHour ? .white : .black)
        }
        .position(hourPosition(for: hour, in: geometry.size))
        .onTapGesture {
          withAnimation {
            selectedHour = hour
          }
        }
      }
      
      Path { path in
        path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
        path.addLine(to: lineEnd(for: selectedHour, in: geometry.size))
      }
      .stroke(Color.teal, lineWidth: 2)
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            let vector = CGVector(dx: value.location.x - geometry.size.width / 2,
                                  dy: value.location.y - geometry.size.height / 2)
            var angle = atan2(vector.dy, vector.dx) + .pi / 2
            if angle < 0 {
              angle += 2 * .pi
            }
            selectedHour = Int(round((angle * 12) / (2 * .pi))) % 12
            if selectedHour == 0 {
              selectedHour = 12
            }
          }
      )
      Circle()
        .fill(Color.teal)
        .frame(width: 15, height: 15)
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
  }
  
  func hourPosition(for hour: Int, in size: CGSize) -> CGPoint {
    let angle = hourAngle(for: hour)
    let radius = min(size.width, size.height) / 2 - 30
    let x = size.width / 2 + cos(angle - CGFloat.pi / 2) * radius
    let y = size.height / 2 + sin(angle - CGFloat.pi / 2) * radius
    return CGPoint(x: x, y: y)
  }
  
  func lineEnd(for hour: Int, in size: CGSize) -> CGPoint {
    let angle = hourAngle(for: hour)
    let radius = min(size.width, size.height) / 2 - 45
    let x = size.width / 2 + cos(angle - .pi / 2) * radius
    let y = size.height / 2 + sin(angle - .pi / 2) * radius
    
    return CGPoint(x: x, y: y)
  }
  
  func hourAngle(for hour: Int) -> CGFloat {
    2 * CGFloat.pi / 12 * CGFloat(hour)
  }
}
