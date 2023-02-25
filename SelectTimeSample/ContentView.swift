//
//  ContentView.swift
//  SelectTimeSample
//
//  Created by Cafe on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    
    // シンプルな方
    @AppStorage("start_hour1") var startHour1 : Int = 8
    @AppStorage("start_min1") var startMin1 : Int = 15
    @AppStorage("end_hour1") var endHour1 : Int = 17
    @AppStorage("end_min1") var endMin1 : Int = 15
    // エラー付きの方
    @AppStorage("start_hour2") var startHour2 : Int = 8
    @AppStorage("start_min2") var startMin2 : Int = 15
    @AppStorage("end_hour2") var endHour2 : Int = 17
    @AppStorage("end_min2") var endMin2 : Int = 15


    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink{
                    SelectTimeView()
                } label: {
                    HStack {
                        Text("シンプル")
                        Spacer()
                        Text("\(numToString(startHour1)):\(numToString(startMin1))-\(numToString(endHour1)):\(numToString(endMin1))")
                    }
                    .foregroundColor(.secondary)
                }
                NavigationLink{
                    SelectTimeViewWithError()
                } label: {
                    HStack {
                        Text("エラー付き")
                        Spacer()
                        Text("\(numToString(startHour2)):\(numToString(startMin2))-\(numToString(endHour2)):\(numToString(endMin2))")
                    }
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("時間選択サンプル")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func numToString(_ num: Int) -> String {
        return String(format: "%02d", num)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
