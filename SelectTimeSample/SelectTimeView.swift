//
//  SelectTimeView.swift
//  SelectTimeSample
//
//  Created by Cafe on 2023/02/24.
//

import SwiftUI

struct SelectTimeView: View {
    // 保存される時間
    @AppStorage("start_hour1") var startHour : Int = 8
    @AppStorage("start_min1") var startMin : Int = 15
    @AppStorage("end_hour1") var endHour : Int = 17
    @AppStorage("end_min1") var endMin : Int = 15
    // Pickerを開け閉めするための状態変数
    @State var isOpenStartSet: Bool = false
    @State var isOpenEndSet: Bool = false
    
    var body: some View{
        List{
            // 開始・終了セクション
            Section {
                // （１）開始ボタン
                Button {
                    // アニメーションをつけてニュッと開く
                    withAnimation {
                        isOpenStartSet.toggle()
                        isOpenEndSet = false
                    }
                } label: {
                    HStack {
                        Text("開始")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(numToString(startHour)):\(numToString(startMin))")
                            .foregroundColor(isOpenStartSet ? .blue : .secondary)
                    }
                }
                // isOpenStartSetがtrueの時、表示
                isOpenStartSet ? SelectTimeWheelView(
                    hour: $startHour, minute: $startMin,
                    isOpen: $isOpenStartSet) : nil
                // （２）終了ボタン
                Button {
                    // アニメーションをつけてニュッと開く
                    withAnimation {
                        isOpenEndSet.toggle()
                        isOpenStartSet = false
                    }
                } label: {
                    HStack {
                        Text("終了")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(numToString(endHour)):\(numToString(endMin))")
                            .foregroundColor(isOpenEndSet ? .blue : .secondary)
                    }
                }
                // isOpenSEndSetがtrueの時、表示
                isOpenEndSet ? SelectTimeWheelView(
                    hour: $endHour, minute: $endMin,
                    isOpen: $isOpenStartSet) : nil
            }
            Section(header:Text("ここに説明とか入れるとそれっぽいですね。").font(.caption)){}
        } // List
    }// body
    
    // Int型の"2"を"02"とか0埋めしてくれる処理
    private func numToString(_ num: Int) -> String {
        return String(format: "%02d", num)
    }
}

struct SelectTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimeView()
    }
}
