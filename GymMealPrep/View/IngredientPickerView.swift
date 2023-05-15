//
//  IngredientPickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import SwiftUI
import Combine

struct IngredientPickerView: View {
    @StateObject var viewModel = IngredientPickerViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Type in ingredient name", text: $viewModel.searchTerm)
                    .textFieldStyle(.roundedBorder)
                Button {
                    viewModel.getPosts()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
            }
            List {
                ForEach(viewModel.ingredients) { ingredient in
                    Text(ingredient.food.name)
                }
            }
        }
        .padding()
    }
}

struct IngredientPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPickerView()
    }
}
class IngredientPickerViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    @Published var posts: [PostModel] = []
    @Published var ingredients: [Ingredient] = []
    @Published var searchTerm: String = String()
    
    init() {
//        getPosts()
    }
    func getPosts() {
        let urlString: String = "https://jsonplaceholder.typicode.com/posts"
        
        guard let url = URL(string: urlString) else { return }
        
        // create publisher
        URLSession.shared.dataTaskPublisher(for: url)
        // sub on background, default for data task publisher
            .subscribe(on: DispatchQueue.global(qos: .background))
        // recive on main thread
            .receive(on: DispatchQueue.main)
        // tryMap to check if data is good
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            // decode data into post models
            .decode(type: EdamamParserResponse.self , decoder: JSONDecoder())
        // use the item
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (response) in
                print(response)
            }
            .store(in: &subscriptions)

    }
    
}
