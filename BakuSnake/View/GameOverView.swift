//
//  GameOverView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import SwiftUI

struct GameOverView: View {
    @Binding var gameOverFlag: Bool
    @Binding var restartFlag: Bool
    @State private var name: String = ""
    @State private var rankings = RankingViewModel()
    private let score: Int
    
    init(score: Int, gameOverFlag: Binding<Bool>, restartFlag: Binding<Bool>) {
        self.score = score
        self._gameOverFlag = gameOverFlag
        self._restartFlag = restartFlag
        rankings.fetchRanking(score: score)
    }
    
    var body: some View {
        VStack{
            Text("Your score: \(score)")
            if rankings.ableUpdate {
                TextField("Your name:", text: $name)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                Button{
                    rankings.updateRanking(name: name, score: score)
                } label: {
                    Text("Upload score")
                }
            }
            VStack{
                Text("Best Ranking:")
                Text("NAME      SCORE")
                VStack(alignment: .leading){
                    ForEach(rankings.ranking, id: \.rank){
                        Text("\($0.name)    :   \($0.score)")
                    }
                }
            }
            Button{
                gameOverFlag = false
            } label: {
                Text("Restart").bold()
            }
        }
        .onDisappear{
            restartFlag = !gameOverFlag
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 10, gameOverFlag: .constant(true), restartFlag: .constant(false))
    }
}
