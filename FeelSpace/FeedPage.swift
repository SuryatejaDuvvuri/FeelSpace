//
//  FeedPage.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Post: Identifiable
{
    var id = UUID()
    var title:String
    var paragraph:String
    var number:Int
    init(title: String, paragraph: String, number: Int) {
        self.title = title
        self.paragraph = paragraph
        self.number = number
    }
}

struct PostPage: View {
//    @ObservedObject private var feed = DataViewModel()
//    @State var number:Int
    var post: Post
    var body: some View {
        Text("\(post.title)").font(.title3)
            .foregroundStyle(.white)
            .navigationTitle("Posts")
            .frame(width: 70)
            .padding()
        VStack
        {
            VStack
            {
                Text("\(post.paragraph)").font(.body)
                    .foregroundStyle(.white)
                    .navigationTitle("Posts")
                    .frame(width: 350)
                    .padding()
            }
        }.navigationTitle("Posts")
    }
}

class DataViewModel: ObservableObject {
   
    @Published var post: [Post] = []
    init()
    {
        fetchData()
    }
    
    private func fetchData()
    {
        
       Firestore.firestore().collection("users").getDocuments{
            snapshot, error in
            if let error = error
            {
                print("Failed to fetch data")
                return
            }
            
//            print("no error")
           for data in snapshot!.documents
           {
               let title = data["heading"] as? String ?? "title"
               let paragraph = data["body"] as? String ?? "paragraph"
               let number = data["number"] as? Int ?? 0
   //            print(title)
   //            print(paragraph)
               self.post.append( Post(title: title, paragraph: paragraph, number: number))
           }
//            print(data)
            
           
        }
        
//        db.getDocument {
//            (document, error) in
//            if let doc = document {
//                if doc.exists {
//                    title = doc.data()!["heading"] as! String
//                    paragraph = doc.data()!["body"] as! String
//                    print("Document data: \(title)")
//                    print("Document data: \(paragraph)")
//                }
//            }
//        }
    }
    
}


struct FeedPage: View {
    
    @ObservedObject private var feed = DataViewModel()
    var body: some View {
        Text("Feed").font(.title)
        ForEach(feed.post) {
            post in
            NavigationLink{
                PostPage(post:post)
            } label:
            {
                ZStack(alignment: .topLeading)
                {
                    VStack(alignment:.leading, spacing: 2)
                    {
                        Text(post.title).font(.title3)
                            .foregroundStyle(.black)
//                            .navigationTitle("Posts")
                            .frame(width: 70)
                            .padding()
                        VStack
                        {
                            Text(post.paragraph).font(.body)
                            .foregroundStyle(.black)
//                            .navigationTitle("Posts")
                            .frame(width: 350)
                            .lineLimit(2)
                            .padding()
                        }
                        
                            
                    }.background(RoundedRectangle(cornerRadius: 25.0).fill(.gray).frame(width: 370, height: 130))
                        
                }.navigationTitle("Posts").navigationBarBackButtonHidden()
                   
            }
        }
       
       
        
        NavigationLink
        {
            ContentView()
        } label : {
            VStack(spacing:20)
            {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                ZStack
                {
                    Circle().fill(.white).frame(width: 80, height: 80)
                    
                    Image(systemName: "plus").foregroundColor(.black)
                        .font(.system(size: 25))
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            
        }.navigationTitle("Posts").navigationBarBackButtonHidden()
    }
    
    private var PostView : some View
    {
        ZStack(alignment: .topLeading)
        {
            VStack(alignment:.leading, spacing: 1)
            {
                //.font(.system(.title, design: .rounded))
                
                
                
                    
            }.background(RoundedRectangle(cornerRadius: 25.0).fill(.gray).frame(width: 370, height: 130))
        }.navigationTitle("Posts")
    }
}


#Preview {
    FeedPage()
}

