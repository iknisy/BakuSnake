//
//  ContentView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/10/31.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    @State private var level = 1
    @State private var buffX = (UIScreen.main.bounds.width - 230)/2
    @State private var buffY = (UIScreen.main.bounds.height - 450)/2 - (UIScreen.main.bounds.height / 10)
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Path { path in
    //                S
                    path.move(to: CGPoint(x: 100+buffX, y: 50+buffY))
                    path.addLine(to: CGPoint(x: 50+buffX, y: 0+buffY))
                    path.addLine(to: CGPoint(x: 0+buffX, y: 50+buffY))
                    path.addLine(to: CGPoint(x: 100+buffX, y: 100+buffY))
                    path.addLine(to: CGPoint(x: 50+buffX, y: 150+buffY))
                    path.addLine(to: CGPoint(x: 0+buffX, y: 100+buffY))
    //                N
                    path.move(to: CGPoint(x: 150+buffX, y: 200+buffY))
                    path.addLine(to: CGPoint(x: 150+buffX, y: 100+buffY))
                    path.addLine(to: CGPoint(x: 225+buffX, y: 200+buffY))
                    path.addLine(to: CGPoint(x: 225+buffX, y: 100+buffY))
    //                A
                    path.move(to: CGPoint(x: 0+buffX, y: 300+buffY))
                    path.addLine(to: CGPoint(x: 50+buffX, y: 200+buffY))
                    path.addLine(to: CGPoint(x: 100+buffX, y: 300+buffY))
    //                K
                    path.move(to: CGPoint(x: 162.5+buffX, y: 250+buffY))
                    path.addLine(to: CGPoint(x: 162.5+buffX, y: 350+buffY))
                    path.move(to: CGPoint(x: 225+buffX, y: 250+buffY))
                    path.addLine(to: CGPoint(x: 150+buffX, y: 300+buffY))
                    path.addLine(to: CGPoint(x: 225+buffX, y: 350+buffY))
    //                E
                    path.move(to: CGPoint(x: 100+buffX, y: 350+buffY))
                    path.addLine(to: CGPoint(x: 0+buffX, y: 350+buffY))
                    path.addLine(to: CGPoint(x: 0+buffX, y: 450+buffY))
                    path.addLine(to: CGPoint(x: 100+buffX, y: 450+buffY))
                    path.move(to: CGPoint(x: 100+buffX, y: 400+buffY))
                    path.addLine(to: CGPoint(x: 25+buffX, y: 400+buffY))
                    path.addLine(to: CGPoint(x: 100+buffX, y: 400+buffY))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .bevel))
                
                Picker("Level", selection: $level) {
                    Text("Easy").tag(1)
                    Text("Normal").tag(2)
                    Text("Hard").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, UIScreen.main.bounds.width / 10)
                
                Button{
                    self.isPresented.toggle()
                } label: {
                    Text("START")
                        .foregroundColor(.black)
                        .bold()
                }
                NavigationLink(destination: GameView(lv: level), isActive: $isPresented) {
                    EmptyView()
                }
//                .fullScreenCover(isPresented: $isPresented){
//                    GameView(level: $level)
//                }
            }
            .padding(.bottom, (UIScreen.main.bounds.height / 15))
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
