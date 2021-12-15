
import SwiftUI
//APIから取得する戻り値の型
struct Response: Codable{
    var results: [Result]
}
//個々の書籍情報の型
struct Result: Codable{
    var trackId: Int           // 書籍データのID
    var trackName:String?      // 書籍タイトル
    var artistName:String?     // 著者名
    var formattedPrice:String? // 価格（テキスト形式）
}

struct ShosekiApiView: View {
    @State private var results = [Result]() // 空の書籍情報配列を生成
    var body: some View {

        NavigationView{
            List(results,id: \.trackId){ item in
                VStack(alignment: .leading){
                    Text(item.trackName ?? "").font(.headline) // 書籍タイトル
                    Text(item.artistName ?? "")                // 著者名
                    Text(item.formattedPrice ?? "")            // 価格
                }
            }//List
            .navigationTitle("SwiftUI書籍リスト")
        }.onAppear(perform: loadData)  // データ読み込み処理
    
    }
    /// データ読み込み処理
    func loadData(){
        ///URLの生成
        guard let url = URL(string: "https://itunes.apple.com/search?term=swiftui&country=jp&media=ebook")
        else{
            //文字列が有効なURLでない場合の処理
            return
        }
        ///URLリクエストの生成
        let request = URLRequest(url: url)
        ///URLにアクセス
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {  //①データ取得チェック
                ///②JSON →Responseオブジェクト変換
                let decoder = JSONDecoder()
                guard let decoderResponse = try? decoder.decode(Response.self,from: data)
                else {
                    print("JSON decode エラー")
                    return
                }
                /// ③書籍情報をUIに適用
                DispatchQueue.main.async {
                    results = decoderResponse.results
                }
            } else {
                ///④データが取得できなかった場合の処理
                print("Feth faild :\(error?.localizedDescription ?? "Unknown error ")")
            }
        }.resume()   //タスク開始処理
    }
    
}

struct ShosekiApiView_Previews: PreviewProvider {
    static var previews: some View {
        ShosekiApiView()
    }
}
