import SwiftUI
import WidgetKit

struct TodoContentView: View {
    @State private var todos = [TodoItem]()
    @State private var newTodoTitle = ""
    
    let defaults = UserDefaults(suiteName: "group.io.justpixel.WidgetExplore")!
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("New Todo", text: $newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        guard !newTodoTitle.isEmpty else { return }
                        let newTodo = TodoItem(title: newTodoTitle)
                        todos.append(newTodo)
                        newTodoTitle = ""
                        saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 8)
                }
                .padding()
                
                
                List {
                    TodoView(todos: todos) { index in
                        deleteTodos(at: index)
                    }
                }
                
                Button(action: {
                    deleteAllTodos()
                }, label: {
                    Label(
                        title: { Text("Delete All") },
                        icon: { Image(systemName: "trash.fill") }
                    )
                })
            }
        }
        .navigationBarTitle("Todos")
        .onAppear(perform: loadTodos)
    }
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        let newTodo = TodoItem(title: newTodoTitle)
        todos.append(newTodo)
        newTodoTitle = ""
        saveTodos()
    }
    
    private func saveTodos() {
        let encoder = PropertyListEncoder()
        guard let encoded = try? encoder.encode(todos) else {
            fatalError("Unable to encode todos")
        }
        defaults.set(encoded, forKey: "todos")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func loadTodos() {
        guard let savedTodos = defaults.data(forKey: "todos") else { return }
        let decoder = PropertyListDecoder()
        guard let loadedTodos = try? decoder.decode([TodoItem].self, from: savedTodos) else { return }
        todos = loadedTodos
    }
    
    private func deleteTodos(at indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
        saveTodos()
    }
    
    private func deleteAllTodos() {
        todos.removeAll()
        saveTodos()
    }
}
