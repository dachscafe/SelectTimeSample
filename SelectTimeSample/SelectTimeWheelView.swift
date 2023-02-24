//
//  SettingTimeWheelView.swift
//  SelectTimeSample
//
//  Created by Cafe on 2023/02/24.
//

import SwiftUI

struct SelectTimeWheelView: View {
    // バインド変数
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var isOpen: Bool
    // 時・分の選択肢
    let HourList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                           13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let minuteList: [Int] = [0, 15, 30, 45]
    
    var body: some View {
        HStack {
            // 時
            Picker(selection: $hour) {
                ForEach(0..<Int(HourList.count), id: \.self) { index in
                    Text(String(format: "%02d", HourList[index]) + "時")
                        .tag(HourList[index])
                }
            } label: {}
            // 分
            Picker(selection: $minute) {
                ForEach(0..<Int(minuteList.count), id: \.self) { index in
                    Text(String(format: "%02d", minuteList[index]) + "分")
                        .tag(minuteList[index])
                }
            } label: {}
        }
        // ホイールスタイル
        .pickerStyle(.wheel)
    }
}

struct SettingTimeWheelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimeWheelView(hour: .constant(10), minute: .constant(10), isOpen: .constant(true))
    }
}
