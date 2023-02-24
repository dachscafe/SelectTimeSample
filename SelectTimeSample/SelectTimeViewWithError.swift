//
//  SelectTimeView.swift
//  SelectTimeSample
//
//  Created by Cafe on 2023/02/24.
//

import SwiftUI

struct SelectTimeViewWithError: View {
    // 保存される時間
    @AppStorage("start_hour2") var startHour : Int = 8
    @AppStorage("start_min2") var startMin : Int = 15
    @AppStorage("end_hour2") var endHour : Int = 17
    @AppStorage("end_min2") var endMin : Int = 15
    // 変更１：選択した時間を追加。保存前に一旦ここへ入れる。
    @State var startHourSelected : Int = 0
    @State var startMinSelected : Int = 0
    @State var endHourSelected : Int = 0
    @State var endMinSelected : Int = 0
    // Pickerを開け閉めするための状態変数
    @State var isOpenStartSet: Bool = false
    @State var isOpenEndSet: Bool = false
    // アラートポップを出す状態変数
    @State var isError: Bool = false
    
    var body: some View{
        List{
            // 開始・終了セクション
            // 変更２：全てのstartHourをstartHourSelectedに変更。他のも同様。
            Section {
                // （１）開始ボタン
                Button {
                    withAnimation {
                        isOpenStartSet.toggle()
                        isOpenEndSet = false
                    }
                } label: {
                    HStack {
                        Text("開始")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(numToString(startHourSelected)):\(numToString(startMinSelected))")
                            .foregroundColor(isOpenStartSet ? .blue : .secondary)
                    }
                }
                isOpenStartSet ? SelectTimeWheelView(
                    hour: $startHourSelected, minute: $startMinSelected,
                    isOpen: $isOpenStartSet) : nil
                // （２）終了ボタン
                Button {
                    withAnimation {
                        isOpenEndSet.toggle()
                        isOpenStartSet = false
                    }
                } label: {
                    HStack {
                        Text("終了")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(numToString(endHourSelected)):\(numToString(endMinSelected))")
                            .foregroundColor(isOpenEndSet ? .blue : .secondary)
                    }
                }
                isOpenEndSet ? SelectTimeWheelView(
                    hour: $endHourSelected, minute: $endMinSelected,
                    isOpen: $isOpenStartSet) : nil
            }
            Section(header:Text("開始と終了の前後をおかしくするとエラーを吐きます").font(.caption)){}
        } // List
        // 変更３：全ての時・分が変更されるたびにエラーチェックをする
        .onChange(of: startHourSelected) {_ in
            errorCheck()
        }
        .onChange(of: startMinSelected) {_ in
            errorCheck()
        }
        .onChange(of: endHourSelected) {_ in
            errorCheck()
        }
        .onChange(of: endMinSelected) {_ in
            errorCheck()
        }
        // この画面が表示された時、値をセットする
        .onAppear() {
            setInfo()
        }
        // この画面を去るとき、値を保存する
        .onDisappear {
            saveInfo()
        }
        // 開始＞終了になったらアラートを出す
        .alert(isPresented: $isError) {
            Alert(title: Text("エラー"), message: Text("開始は終了よりも前の時刻にしてください"))
        }
    } // body
    
    private func numToString(_ num: Int) -> String {
        return String(format: "%02d", num)
    }
    // 値をセット
    private func setInfo() {
        startHourSelected = startHour
        startMinSelected = startMin
        endHourSelected = endHour
        endMinSelected = endMin
    }
    // 値を保存
    private func saveInfo() {
        startHour = startHourSelected
        startMin = startMinSelected
        endHour = endHourSelected
        endMin = endMinSelected
    }
    // 時間の前後関係エラーチェック
    private func errorCheck() {
        if startHourSelected > endHourSelected
            || (startHourSelected==endHourSelected && startMin > endMin) {
            // エラーだったら一旦値を戻す
            setInfo()
            // アラートを出す状態変数をtrue
            isError = true
        }
    }
    
} // View


struct SelectTimeViewWithError_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimeViewWithError()
    }
}
