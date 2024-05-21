//
//  newAccountView.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 20/05/24.


import SwiftUI
import CoreData
struct NewAccountView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var name = ""
    @State var email_number = ""
    @State var password = ""
    @State var showPassword = false
    @State var validEmailNum = false
    @State var validity = ""
    @State var userCorrespondingInfo: UserInfo = UserInfo()
    @State var passwordValidity = ""
    var body: some View {
        ZStack {
            Color.mint
            .rotationEffect(.degrees(112))
            VStack {
                TextField("Name", text: $name).modifier(FieldStyle())
                TextField("Email\\Mobile Number", text: $email_number).modifier(FieldStyle())
                Text(validity)
                if showPassword {
                    TextField("password", text: $password).modifier(FieldStyle())
                        .overlay {
                            HStack {
                                Spacer().frame(width: 300)
                                Button(action: {showPassword.toggle()}) {
                                    Image(systemName: showPassword ? "eye": "eye.slash")
                                        .font(.title2)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                } else {
                    SecureField("password", text: $password).modifier(FieldStyle())
                        .overlay {
                            HStack {
                                Spacer().frame(width: 300)
                                Button(action: {showPassword.toggle()}) {
                                    Image(systemName: showPassword ? "car": "eye.slash")
                                        .font(.title2)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                }
                Text(passwordValidity)
                NavigationLink(destination: {
                    LoggedInPage(isAuthenticated: $validEmailNum, userCorrespondingInfo: $userCorrespondingInfo)
                }, label: {
                    Text("sign-up").font(.title2)
                        .frame(width: 95, height: 35)
                        .foregroundStyle(.mint.opacity(0.7))
                        .background(.white.opacity(0.7))
                        .cornerRadius(20)
                })
                .simultaneousGesture(TapGesture() .onEnded({ _ in
                    addItem(name: name, email_num: email_number, password: password)
                }))
                .disabled(!validEmailNum && !passwordValidity.isEmpty)
                .onDisappear(perform: {
                    name = ""
                    email_number = ""
                    password = ""
                })
                
            }
            // To check the email or phone number is valid or not
            .onChange(of: email_number) {
                validEmailNum = validEmailNumber(email_number)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if !email_number.isEmpty {
                        validity =  validEmailNum ? "" : "invalid email or number"
                    } else {
                        validity = ""
                    }
                    
                }
            }
            .onChange(of: password) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    passwordValidity = password.isEmpty ? "" : passwordValidation(name: name, password: password)
                }
            }
            .navigationTitle("Create Account")
        }
    }
    func validEmailNumber(_ entry: String) -> Bool {
        let Regex = #"(^(\d|\w)*@gmail.com$)|^\d{10}$"#
        let message = entry
        if let _ = message.range(of: Regex, options: .regularExpression, range: message.startIndex..<message.endIndex) {
            return true
        } else {
            return false
        }
    }
    private func addItem(name: String, email_num: String, password: String) {
        withAnimation {
            let addingInfo = UserInfo(context: viewContext)
            addingInfo.emailOrNum = email_num
            addingInfo.password = password
            addingInfo.name = name
            userCorrespondingInfo = addingInfo
            do {
                try viewContext.save()
            } catch {
                fatalError("Error while adding new data!")
            }
        }
    }
    
    // check the validity of the password
    func passwordValidation(name: String, password: String) -> String {
        var upperCaseLetters = 0
        for i in password {
            if i.isUppercase {
                upperCaseLetters += 1
            }
        }
        if password.contains(name) {
            return "password should not contain name"
        }
        else if password.first?.isUppercase ?? false {
            return "first letter should be lowercase"
        }
        else if password.count < 8 && password.count > 15 {
            return "check range of password"
        }
        else if upperCaseLetters < 2 {
            return "password contains atleast 2 uppercases"
        }
        else if password.compactMap({Int(String($0))}).count < 2 {
            return "password should contains atleast 2 digits"
        }
        else if !containsSpecialCharacter(password) {
            return "password should contains atleast 1 special character"
        }
        else {
            return ""
        }
    }

    func containsSpecialCharacter(_ str: String) -> Bool {
        let specialCharacterSet = CharacterSet.punctuationCharacters.union(.symbols)
        return str.rangeOfCharacter(from: specialCharacterSet) != nil
    }
}

#Preview {
    NewAccountView()
}

