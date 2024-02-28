//
//  View+Extensions.swift
//  AndroidSwiftUITimePicker
//
//  Created by Silverius Daniel Wijono on 28/02/24.
//

import SwiftUI

public extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
  
  @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
    if visibility != .gone {
      if visibility == .visible {
        self
      } else {
        hidden()
      }
    }
  }
}

struct RoundedCorner: Shape {

  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

public enum ViewVisibility: CaseIterable {
  case visible, // view is fully visible
       invisible, // view is hidden but takes up space
       gone // view is fully removed from the view hierarchy
}
