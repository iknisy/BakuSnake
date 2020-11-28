//
//  GameView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/12.
//

import SwiftUI

struct GameView: View {
//    @Binding var level: Int
    private let level: Int
    private let snakeVM: GameViewModel
    private let maxX: CGFloat
    private let maxY: CGFloat
    private let edgeUp: CGFloat
    private let edgeDown: CGFloat
    private let edgeRight: CGFloat
    private let edgeLeft: CGFloat
    @State private var snakeBody: [(Int, Int)]
    @State private var gameoverFlag = false
    @State private var restartFlag = false
    @Environment(\.presentationMode) var presentaion
    
    init(lv: Int) {
        level = lv
        maxX = UIScreen.main.bounds.width * 0.9
        maxY = UIScreen.main.bounds.height * 0.6
        edgeUp = UIScreen.main.bounds.height * 0.1-1
        edgeDown = UIScreen.main.bounds.height * 0.7+1
        edgeLeft = UIScreen.main.bounds.width * 0.05-1
        edgeRight = UIScreen.main.bounds.width * 0.95+1
        snakeVM = GameViewModel(maxX: Int(maxX), maxY: Int(maxY), level: level)
//        init @State var must like this
        _snakeBody = State(initialValue: snakeVM.getSnakeBody())
    }
    
    var body: some View {
        VStack{
            Text("Level: \(level)")
            ZStack{
//                edge
                Path {path in
                    path.move(to: CGPoint(x: edgeLeft, y: edgeUp))
                    path.addLine(to: CGPoint(x: edgeLeft, y: edgeDown))
                    path.addLine(to: CGPoint(x: edgeRight, y: edgeDown))
                    path.addLine(to: CGPoint(x: edgeRight, y: edgeUp))
                    path.addLine(to: CGPoint(x: edgeLeft, y: edgeUp))
                }.stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .square, lineJoin: .miter))
//                snake
                Path {path in
                    path.move(to: CGPoint(x: Int(edgeLeft) + 1 + snakeBody[0].0, y: Int(edgeUp) + 1 + snakeBody[0].1))
                    for i in 0..<snakeBody.count {
                        if snakeBody[i] == (-1, -1) {
                            path.move(to: CGPoint(x: Int(edgeLeft) + 1 + snakeBody[i+1].0, y: Int(edgeUp) + 1 + snakeBody[i+1].1))
                            continue
                        }
                        path.addLine(to: CGPoint(x: Int(edgeLeft) + 1 + snakeBody[i].0, y: Int(edgeUp) + 1 + snakeBody[i].1))
                    }
                }.stroke(Color.gray, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                foods
                Path {path in
                    for food in snakeVM.gameFoods {
                        path.move(to: CGPoint(x: food.x + Int(edgeLeft) + 1, y: food.y + Int(edgeUp) + 1))
                        path.addLine(to: CGPoint(x: food.x + Int(edgeLeft) + 1, y: food.y + Int(edgeUp) + 1))
                    }
                }.stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                fog of war
                if snakeVM.warFogLayer != 0 {
                    Path {path in
//                        inside
                        let snakeDiffX = CGFloat(snakeBody.last!.0) - maxX/2
                        let snakeDiffY = CGFloat(snakeBody.last!.1) - maxY/2
                        var insideLeft = snakeDiffX  + maxX * CGFloat(snakeVM.warFogLayer) / 100 / 2
                        insideLeft = (insideLeft < 0) ? edgeLeft : insideLeft + edgeLeft
                        var insideRight = snakeDiffX + maxX * (1 - (CGFloat(snakeVM.warFogLayer) / 100 / 2))
                        insideRight = (insideRight > maxX) ? maxX + edgeLeft : insideRight + edgeLeft
                        var insideUp = snakeDiffY + maxY * CGFloat(snakeVM.warFogLayer) / 100 / 2
                        insideUp = (insideUp < 0) ? edgeUp : insideUp + edgeUp
                        var insideDown = snakeDiffY + maxY * (1 - (CGFloat(snakeVM.warFogLayer) / 100 / 2 ))
                        insideDown = (insideDown > maxY) ? edgeUp + maxY : insideDown + edgeUp
                        path.move(to: CGPoint(x: insideLeft, y: insideUp))
                        path.addLine(to: CGPoint(x: insideLeft, y: insideDown))
                        path.addLine(to: CGPoint(x: insideRight, y: insideDown))
                        path.addLine(to: CGPoint(x: insideRight, y:  insideUp))
                        path.addLine(to: CGPoint(x: insideLeft, y: insideUp))
//                        outside
                        path.addLine(to: CGPoint(x: edgeLeft, y: edgeUp))
                        path.addLine(to: CGPoint(x: edgeRight, y: edgeUp))
                        path.addLine(to: CGPoint(x: edgeRight, y: edgeDown))
                        path.addLine(to: CGPoint(x: edgeLeft, y: edgeDown))
                        path.addLine(to: CGPoint(x: edgeLeft, y: edgeUp))
                    }
                    .fill(Color(red: 0.93, green: 0.93, blue: 0.93, opacity: 1.0))
                }
            }
            .onAppear{
                Timer.scheduledTimer(withTimeInterval: (0.1 / (1 + Double(snakeVM.score) * 0.05)), repeats: true){_ in
                    self.snakeVM.snakeMove()
                    snakeBody = snakeVM.getSnakeBody()
                    if restartFlag {
                        self.presentaion.wrappedValue.dismiss()
                    }
                    if snakeVM.gameoverFlag {gameoverFlag = true}
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded{value in
                if abs(value.translation.height) > abs(value.translation.width) {
                    if value.translation.height > 0 {
                        snakeVM.gameSnake.changeDirection(to: .SnakeFacingDown)
                    }else{
                        snakeVM.gameSnake.changeDirection(to: .SnakeFacingUp)
                    }
                }else{
                    if value.translation.width > 0 {
                        snakeVM.gameSnake.changeDirection(to: .SnakeFacingRight)
                    }else{
                        snakeVM.gameSnake.changeDirection(to: .SnakeFacingLeft)
                    }
                }
            })
            Text("Scope: \(snakeVM.score)")
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $gameoverFlag , content: {
            GameOverView(score: snakeVM.score, gameOverFlag: $gameoverFlag, restartFlag: $restartFlag)
        })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{GameView(lv: 3)}
    }
}
