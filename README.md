# 概要
- よくある、ホイールで時間選択するやつを作りたかった
- しかも、`List`のViewの中で使えるようなやつ
- 「シンプルver.」と、「エラー付きver.」のやつと２種類作りました。
- ここでは主に前者の仕組みを解説します。
- 後者は、`@AppStrage`に保存される前に、バリデーションチェックしてくれる仕組みが入ってます。

# 環境
- macOS: 13.0.1
- iOS: 16.1
- XCode: 14.1

# 完成品（２種類）
1. シンプルな方
    - <img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2918864/e12b4b69-a93b-864a-4c21-eff1134c16a7.gif" width=300px>
1. エラー付きの方
    - <img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2918864/2398ab27-6f66-8249-cee3-080d6871e321.gif" width=300px>

# GitHub
https://github.com/dachscafe/SelectTimeSample

# ソースコード1（シンプルな方）
1. まず、時間選択する画面は以下のようになってます。保存される時間を`@AppStrage`で定義して、後述する`SelectTimeWheelView()`でバインドさせています。
    ```swift: SelectTimeView.swift
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
    ```
1. 次に、ホイールの`SelectTimeWheelView()`の部分です。最初に時間と分の配列を定義させています（以下の例は15分刻みです）。それを`Picker`使って`ForEach`で繰り返す感じ（配列をForEachで繰り返す際は` id: \.self`を忘れずに）。



    ```swift: SelectTimeWheelView.swift

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

    ```

# ソースコード2（エラー付きの方）
1. あまり解説しませんが、以下の通りです。一旦`@State`で状態変数に持たせてから、画面が遷移するタイミングで`@AppStrage`に保存させてます。で、その状態変数が変更されたタイミングでバリデーションチェックをかけてます（これでいいのかはあまり自信ありません・・・）。


# ソースコード2（おまけ）
1. 最後に一応`ContentView()`を載せときます。シンプルな方とエラー付きな方を見比べることができます。
    ```swift: ContentView.swift
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
    ```


以上


# 参考
https://www.choge-blog.com/programming/swiftuiforeachusearray/

https://yamatooo.blog/entry/2021/07/23/083000