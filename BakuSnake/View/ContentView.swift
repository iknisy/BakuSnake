//
//  ContentView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/10/31.
//

import SwiftUI

struct ContentView: View {
//    為了顯示下一頁所用的
    @State private var isPresented = false
//    預設遊戲難度等級1
    @State private var level = 1
//    在畫面周圍留白的尺寸
    @State private var buffX = (UIScreen.main.bounds.width - 230)/2
    @State private var buffY = (UIScreen.main.bounds.height - 450)/2 - (UIScreen.main.bounds.height / 10)
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
//                標題
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
//                遊戲難度
                Picker("Level", selection: $level) {
                    Text("Easy").tag(1)
                    Text("Normal").tag(2)
                    Text("Hard").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, UIScreen.main.bounds.width / 10)
//                遊戲開始的按鈕
                Button{
                    self.isPresented.toggle()
                } label: {
                    Text("START")
                        .foregroundColor(.black)
                        .bold()
                }
//                跳至下一頁的Navigation
                NavigationLink(destination: GameView(lv: level), isActive: $isPresented) {
                    EmptyView()
                }
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
