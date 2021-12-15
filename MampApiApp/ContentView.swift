import SwiftUI



struct ContentView: View {
    @State private var result = ""
    
    var body: some View {
        ZStack {
            Text(result)
        }
        .onAppear() {
            loadData()
        }

        
    }//body
    
    /// データ読み込み処理
        func loadData() {

            /// URLの生成
            guard let url = URL(string: "http://192.168.1.5:8888/?arg1=11111&arg2=poipi") else {
                /// 文字列が有効なURLでない場合の処理
                return
            }

            /// URLリクエストの生成
            let request = URLRequest(url: url)

            /// URLにアクセス
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    guard let stringdata = String(data: data, encoding: .utf8) else {
                        print("Json decode エラー")
                        return
                    }
                    DispatchQueue.main.async {
                        result = stringdata
                    }
                } else {
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }

            }.resume()      // タスク開始処理（必須）
        }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
