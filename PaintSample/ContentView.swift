//
//  ContentView.swift
//  PaintSample
//
//  Created by hiraoka on 2022/03/21.
//

import SwiftUI

struct ContentView: View {
    private struct Line {
        var points: [CGPoint] = []
        var color: Color
        var lineWidth: Double
    }

    private static let defaultColor: Color = .gray
    private static let defaultLineWidth: Double = 4
    private let colors: [Color] = [defaultColor, .red, .orange, .green, .blue, .purple]

    @State private var lines: [Line] = []

    @State private var currentLine: Line = .init(color: defaultColor, lineWidth: defaultLineWidth)
    @State private var currentColor: Color = defaultColor
    @State private var currentLineWidth: Double = defaultLineWidth

    var body: some View {
        VStack {
            Button(action: { lines = [] }) {
                Label("Clear", systemImage: "xmark.circle")
                    .padding()
            }

            Canvas { context, size in

                for line in lines {
                    var path = Path()
                    path.addLines(line.points)

                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
                }
            }
            .frame(minWidth: 400, minHeight: 400)
            .gesture(
                DragGesture(minimumDistance: .zero, coordinateSpace: .local)
                    .onChanged({ value in
                        let newPoint = value.location
                        currentLine.points.append(newPoint)

                        self.lines.append(currentLine)

                    })
                    .onEnded({ value in
                        self.currentLine = Line(points: [], color: currentColor, lineWidth: currentLineWidth)

                    })
            )

            HStack {
                Slider(value: $currentLineWidth, in: 1...20) {}
                .onChange(of: currentLineWidth) { newValue in
                    currentLine.lineWidth = newValue
                }
                .padding(.horizontal)

                Divider()


                ColorPicker(selection: $currentColor) {
                    HStack {
                        ForEach(colors,id: \.self) { color in
                            color
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .strokeBorder(lineWidth: 4, antialiased: true)
                                        .foregroundColor(self.currentColor == color ? .white : .clear)
                                )
                                .onTapGesture {
                                    self.currentColor = color
                                }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 300)
                .onChange(of: currentColor) { newValue in
                    currentLine.color = newValue
                }
            }
            .frame(maxHeight: 48)
            .padding()
            .background(
                Capsule()
                    .fill(Color(uiColor: .systemGray4))
            )
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
