//
//  GameView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/12.
//

import SwiftUI

struct GameView: View {
    private let level: Int
    private let snakeVM: GameViewModel
//    遊戲畫面的範圍
    private let maxX: CGFloat
    private let maxY: CGFloat
//    遊戲邊界
    private let edgeUp: CGFloat
    private let edgeDown: CGFloat
    private let edgeRight: CGFloat
    private let edgeLeft: CGFloat
    @State private var snakeBody: [(Int, Int)]
//    表示是否遊戲結束
    @State private var gameoverFlag = false
//    表示是否要回到最初畫面
    @State private var restartFlag = false
//    回到最初畫面所需要的環境變數
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
//            繪製遊戲畫面
            ZStack{
//                遊戲邊界
                Path {path in
                    path.move(to: CGPoint(x: edgeLeft, y: edgeUp))
                    path.addLine(to: CGPoint(x: edgeLeft, y: edgeDown))
                    path.addLine(to: CGPoint(x: edgeRight, y: edgeDown))
                    path.addLine(to: CGPoint(x: edgeRight, y: edgeUp))
                    path.addLine(to: CGPoint(x: edgeLeft, y: edgeUp))
                }.stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .square, lineJoin: .miter))
//                蛇的身體
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
//                食物
                Path {path in
                    for food in snakeVM.gameFoods {
                        path.move(to: CGPoint(x: food.x + Int(edgeLeft) + 1, y: food.y + Int(edgeUp) + 1))
                        path.addLine(to: CGPoint(x: food.x + Int(edgeLeft) + 1, y: food.y + Int(edgeUp) + 1))
                    }
                }.stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                戰爭迷霧
                if snakeVM.warFogLayer != 0 {
                    Path {path in
//                        內圈，會隨著蛇的移動及難度而變化
//                        先算出蛇的頭跟中心點的距離
                        let snakeDiffX = CGFloat(snakeBody.last!.0) - maxX/2
                        let snakeDiffY = CGFloat(snakeBody.last!.1) - maxY/2
//                        內圈邊界＝蛇頭跟中心的距離＋戰爭迷霧的層數
                        var insideLeft = snakeDiffX  + maxX * CGFloat(snakeVM.warFogLayer) / 100 / 2
//                        內圈不能超過牆壁
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
//                        外圈
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
//                每過一定時間(預設0.1秒，隨難度變快)就會執行一次
                Timer.scheduledTimer(withTimeInterval: (0.1 / (1 + Double(snakeVM.score) * 0.05)), repeats: true){_ in
//                    通知蛇前進
                    self.snakeVM.snakeMove()
//                    獲得蛇的身體完整的座標
                    snakeBody = snakeVM.getSnakeBody()
//                    確認是否要重新開始
                    if restartFlag {
//                        回到初始畫面
                        self.presentaion.wrappedValue.dismiss()
                    }else{
//                        確認是否遊戲結束
                        if snakeVM.gameoverFlag {gameoverFlag = true}
                    }
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded{value in
//                發生拖曳事件後判斷要換至哪個方向
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
//            遊戲結束跳出GameOverView
            GameOverView(score: snakeVM.score, gameOverFlag: $gameoverFlag, restartFlag: $restartFlag)
        })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{GameView(lv: 3)}
    }
}
