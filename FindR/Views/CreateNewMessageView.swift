//
//  CreateNewMessageView.swift
//  FindrR
//
//  Created by Devang Papinwar on 31/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject
{
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    var currentUser = ChatUser(data: .init())
    
    init()
    {
        fetchAllUsers()
    }
    
    func fetchCurrentUser(typeText : String = "")
    {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error
            {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
            
            self.currentUser = .init(data: data)
            print("Success fetching current user : \(data)")
            self.fetchAllUsers(typeText: typeText)
        }
    }
    
    func fetchAllUsers(typeText : String)
    {
        guard let currentUser = FirebaseManager.shared.auth.currentUser?.uid  else { return }
        
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error
                {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                print("User : \(self.currentUser.email) \(self.currentUser.type) ")
                
                self.users.removeAll()
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid
                    {
                        
                        print("\(user.email) \(user.type) \(user.type == self.currentUser.type)")
                        if user.type == typeText
                        {
                            self.users.append(.init(data: data))
                        }
                    }
                })
            }
    }
    
    private func fetchAllUsers()
    {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid
                    {
                        self.users.append(.init(data: data))
                    }
                    
                })
            }
    }
    
    func handleSend(typeText : String)
    {
        fetchCurrentUser(typeText: typeText)
    }
}

struct CreateNewMessageView: View
{
    let didSelectNewUser: (ChatUser) -> ()
    @State var typeText = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                Text("Explore People")
                    .font(.headline)
                    .padding()
                
                chatBottomBar
                    .background(Color(.init(white: 0.95, alpha: 1)))
                
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button
                    {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                        vm.handleSend(typeText: "")
                    } label:
                    {
                        HStack(spacing: 16)
                        {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 2)
                                )
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                
            }//.navigationTitle("Explore People")
            .navigationBarHidden(true)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading)
                    {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }

        }
    }
    var chatBottomBar: some View
    {
        HStack(spacing: 16)
        {
            ZStack
            {
                TextField("Enter Personality Traits", text: $typeText)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                    .opacity(1)
                
            }
            .frame(height: 40)
            
            Button
            {
                vm.handleSend(typeText: self.typeText)
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct CreateNewMessageView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MainMessagesView()
    }
}
