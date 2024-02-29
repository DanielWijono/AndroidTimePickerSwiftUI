//
//  CircularMinutePicker.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

public struct CircularMinutePicker: View {
  @Binding var selectedMinute: Int
  
  public var body: some View {
    GeometryReader { geometry in
      Circle()
        .fill(Color.gray.opacity(0.2))
      
      ForEach(0 ..< 12) { index in
        let minute = index * 5
        ZStack {
          if minute == selectedMinute {
            Circle()
              .foregroundColor(.teal)
              .frame(width: 40, height: 40)
          }
          Text("\(minute)")
            .font(.body)
            .foregroundColor(minute == selectedMinute ? .white : .black)
        }
        .position(minutePosition(for: minute, in: geometry.size))
        .onTapGesture {
          withAnimation {
            selectedMinute = minute
          }
        }
      }
      
      Path { path in
        path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
        path.addLine(to: lineEnd(for: selectedMinute, in: geometry.size))
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
            selectedMinute = Int(round((angle * 12) / (2 * .pi))) % 12 * 5
          }
      )
      Circle()
        .fill(Color.teal)
        .frame(width: 15, height: 15)
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
  }
  
  func minutePosition(for minute: Int, in size: CGSize) -> CGPoint {
    let angle = minuteAngle(for: minute)
    let radius = min(size.width, size.height) / 2 - 30
    let x = size.width / 2 + cos(angle - CGFloat.pi / 2) * radius
    let y = size.height / 2 + sin(angle - CGFloat.pi / 2) * radius
    return CGPoint(x: x, y: y)
  }
  
  func lineEnd(for minute: Int, in size: CGSize) -> CGPoint {
    let angle = minuteAngle(for: minute)
    let radius = min(size.width, size.height) / 2 - 45
    let x = size.width / 2 + cos(angle - .pi / 2) * radius
    let y = size.height / 2 + sin(angle - .pi / 2) * radius
    
    return CGPoint(x: x, y: y)
  }
  
  func minuteAngle(for minute: Int) -> CGFloat {
    2 * CGFloat.pi / 12 * CGFloat(minute / 5)
  }
}
