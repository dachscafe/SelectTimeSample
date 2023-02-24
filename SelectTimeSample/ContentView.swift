//
//  ContentView.swift
//  SelectTimeSample
//
//  Created by Cafe on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink{
                    SelectTimeView()
                } label: {
                    Text("時間を選択（シンプル）")
                }
                NavigationLink{
                    SelectTimeViewWithError()
                } label: {
                    Text("時間を選択（エラー付き）")
                }
            }
            .navigationTitle("時間選択サンプル")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
