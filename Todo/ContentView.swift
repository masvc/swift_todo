import SwiftUI

// 本来はModiferを別のファイルを使ってクラス化してインスタンスで呼び出して書くことが多い。あと、import使わなくても同じモジュール内であればlinkされてるよ

struct ContentView: View {
  @State var displayedTodos: [Todo] = [] // 追記: List表示用。デフォルトは空。
  @State var todoValue = ""
  
  let fileURL: URL = .documentsDirectory.appending(component: "todos.json")
  //    let seasons = ["spring","summer","fall","winter"]

  @State var showAlert = false // アラート表示用のState

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Todo", text: $todoValue) // 後ろ側追記: 同上
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 5))
        Button("Enter") {
            let trimmedTodoValue = todoValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedTodoValue.isEmpty {
              showAlert = true // 追加
              return
            } // 空であればここで処理が止まる
            do {
                try saveTodo(value: trimmedTodoValue) // 綺麗に整形した方をsave
                displayedTodos = try loadTodos()
                todoValue = ""
            } catch {
                print(error.localizedDescription)
            }
        }
        .buttonStyle(.bordered)
        .background(.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      .padding()
      .background(.yellow)
      //            Spacer()
//      List(displayedTodos, id: \.id) {
//        todo in // idにはTodo構造体のidプロパティをわたします。「\.」はKeypathといって、要素の中身にアクセスできる
//          Text(todo.value)
//      }
      List {
          ForEach(displayedTodos) { todo in // ForEachで配列の要素を回す
              Text(todo.value)
          }
          .onDelete { indexSet in
                            do {
                                try deleteTodo(at: indexSet) // 削除関数呼び出し
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
      }
    }
    .onAppear {
        do {
            displayedTodos = try loadTodos()
        } catch {
            print(error.localizedDescription)
//          エラーハンドリングはアラートが多い
        }
    }

    .alert("入力エラー", isPresented: $showAlert) {
//        Button("OK", role: .cancel) {}
    } message: {
        Text("Todoを入力してください")
    }
  }

  func saveTodo(value: String) throws { // throwsを追記
      let todo = Todo(id: UUID(), value: value)
      displayedTodos.append(todo)
      let data = try JSONEncoder().encode(displayedTodos)
      try data.write(to: fileURL)
  }

  func loadTodos() throws -> [Todo] {
      let data = try Data(contentsOf: fileURL)
      return try JSONDecoder().decode([Todo].self, from: data)
  }

  func deleteTodo(at offsets: IndexSet) throws { // IndexSet型のデータを受け取る
      displayedTodos.remove(atOffsets: offsets) // 配列から指定されたインデックスのデータを削除
      let data = try JSONEncoder().encode(displayedTodos)
      try data.write(to: fileURL)
  }

}

#Preview {
    ContentView()
}
