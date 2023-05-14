//
//  DownloadWithCombine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import SwiftUI
import Combine

struct DownloadWithCombine: View {
    
    
    @StateObject var viewModel = DownloadWithCombineViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.posts) { post in
                VStack {
                    Text(post.title)
                        .font(.largeTitle)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct DownloadWithCombine_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombine()
    }
}

class DownloadWithCombineViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    @Published var posts: [PostModel] = []
    
    init() {
        getPosts()
    }
    func getPosts() {
        let urlString: String = "https://jsonplaceholder.typicode.com/posts"
        
        guard let url = URL(string: urlString) else { return }
        
        // sign up for subsription
        // make the package
        // deliver the package
        // make sure the box is ok
        // open and make sure its ok
        // use the item
        // cancelable at any time
        
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
            .decode(type: [PostModel].self , decoder: JSONDecoder())
        // use the item
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedPosts) in
                self?.posts = returnedPosts
            }
            .store(in: &subscriptions)

    }
    
}

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

