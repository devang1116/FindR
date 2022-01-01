//
//  UserInfoView.swift
//  FindrR
//
//  Created by Devang Papinwar on 31/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserInfoView: View
{
    var userInfo : ChatUser?
    var username : String {
        userInfo?.email.components(separatedBy: "@").first ?? userInfo?.email as! String
    }
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View
    {
        Group
        {
            VStack
            {
                Spacer()
                
                ZStack
                {
                    WebImage(url: URL(string: userInfo?.profileImageUrl ?? "" ))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(200)
                        .overlay(RoundedRectangle(cornerRadius: 200)
                                    .stroke(Color(.label), lineWidth: 2))
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                
                VStack
                {
                    Text(username)
                        .font(.title)
                    
                    Text("UID : \(userInfo?.uid ?? "" )")
                        .font(.headline)

                }
                .padding(.horizontal)
                
                Divider()
                
                Button
                {
                    presentationMode.wrappedValue.dismiss()
                } label:
                {
                    VStack
                    {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                }
                .padding()
                
                Text("Personality : \(userInfo?.type ?? "")")
                    .font(.headline)

                Spacer()
                Spacer()
            }
        }
        //.background(Color(.init(white: 0.95, alpha: 1)))
        
    }
    

}

struct UserInfoView_Previews: PreviewProvider
{
    static var previews: some View
    {
        UserInfoView(userInfo: .init(data: ["type" : "Basketball", "uid": "R8ZrxIT4uRZMVZeWwWeQWPI5zUE3", "email": "waterfall1@gmail.com" , "profileImageUrl" : "https://firebasestorage.googleapis.com:443/v0/b/chat-6765b.appspot.com/o/POi5bg8lCjUnC0OOORJELxSp3OC2?alt=media&token=a4e4f4b1-e89c-43ea-b379-0d5e65713ecb"]))
    }
}
