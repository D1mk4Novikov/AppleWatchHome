//
//  ContentView.swift
//  AppleWatchHome
//
//  Created by Pedro Rojas on 29/09/21.
//

import SwiftUI

struct AppleWatchView: View {
    private static let size: CGFloat = 100
    private static let spacingBetweenColumns: CGFloat = 16
    private static let spacingBetweenRows: CGFloat = 16
    private static let totalColumns: Int = 30

    let gridItems = Array(
        repeating: GridItem(
            .fixed(size),
            spacing: spacingBetweenColumns,
            alignment: .center
        ),
        count: totalColumns
    )

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea([.all])
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                LazyVGrid(
                    columns: gridItems,
                    alignment: .center,
                    spacing: Self.spacingBetweenRows
                ) {
                    ForEach(0..<1000) { value in
                        GeometryReader { proxy in
                            Image(appName(value))
                                .resizable()
                                .cornerRadius(Self.size/2)
                                .frame(height: Self.size)
                                .scaleEffect(
                                    scale(
                                        proxy: proxy,
                                        value: value
                                    )
                                )
                                .offset(
                                    x: offsetX(value),
                                    y: 0
                                )
                        }
                        // You need to add height
                        .frame(
                            width: Self.size,
                            height: Self.size
                        )
                    }
                }
            }
        }
    }

    func offsetX(_ value: Int) -> CGFloat {
        let rowNumber = value / gridItems.count

        if rowNumber % 2 == 0 {
            return Self.size/2 + Self.spacingBetweenColumns/2
        }

        return 0
    }

    func appName(_ value: Int) -> String {
        apps[value%apps.count]
    }

    func scale(proxy: GeometryProxy, value: Int) -> CGFloat {
        let rowNumber = value / gridItems.count
        let appIndex = value%apps.count

        let x = (rowNumber % 2 == 0) ? proxy.frame(in: .global).midX + proxy.size.width/2 :
        proxy.frame(in: .global).midX

        let y = proxy.frame(in: .global).midY
        let center: CGPoint = CGPoint(
            x: UIScreen.main.bounds.size.width*0.5,
            y: UIScreen.main.bounds.size.height*0.5
        )

        let maxDistanceToCenter = getDistanceFromEdgeToCenter(x: x, y: y)

        let point = CGPoint(x: x, y: y)
        let result = distanceBetweenPoints(p1: center, p2: point)



        let total = min(abs(result - maxDistanceToCenter), maxDistanceToCenter*0.7)

        let finalResult = total/(maxDistanceToCenter) * 1.4

        return finalResult
    }

    //distance2
    func getDistanceFromEdgeToCenter(x: CGFloat, y: CGFloat) -> CGFloat {
        // This needs to be updated every time we rotate.
        let center: CGPoint = CGPoint(
            x: UIScreen.main.bounds.size.width*0.5,
            y: UIScreen.main.bounds.size.height*0.5
        )

        let m = (center.y - y)/(center.x - x)
        let angle = abs(atan(m) * 180 / .pi)

        let ipadAngle: CGFloat = 35

        if angle > ipadAngle {
            let yEdge = (y > center.y) ? center.y*2 : 0
            let xEdge = (yEdge - y)/m + x
            let edgePoint = CGPoint(x: xEdge, y: yEdge)

            return distanceBetweenPoints(p1: center, p2: edgePoint)
        } else {
            let xEdge = (x > center.x) ? center.x*2 : 0
            let yEdge = m * (xEdge - x) + y
            let edgePoint = CGPoint(x: xEdge, y: yEdge)
            return distanceBetweenPoints(p1: center, p2: edgePoint)
        }
    }

    func distanceBetweenPoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDistance = abs(p2.x - p1.x)
        let yDistance = abs(p2.y - p1.y)

        return CGFloat(
            sqrt(
                pow(xDistance, 2) + pow(yDistance, 2)
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppleWatchView()
    }
}