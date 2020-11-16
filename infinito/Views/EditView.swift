//
//  EditView.swift
//  Infinito
//
//  Created by Armando Visini on 28/10/2020.
//
import SwiftUI
import UIKit
struct EditView: View{
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State var titleOfTask: String = ""
    @State var priority1: Bool = false
    @State var priority2: Bool = false
    @State var priority3: Bool = false
    
    @State var isPressed: Bool = false
    @State var isPressed1: Bool = false
    @State var isPressed2: Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    func priorityCheck(){
        if priority1 == true {
            priority2 = false
            priority3 = false
        }else if priority2 == true{
            priority1 = false
            priority3 = false
        }else if priority3 == true{
            priority2 = false
            priority1 = false
        }
    }
   
    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                
                Text("Chose task importance:")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 50.0)
                    .padding(.bottom, 35.0)
                    
                HStack (spacing: 100) {
                    Button(action: {
                        self.priority1.toggle()
                        
                        self.isPressed.toggle()
                        self.isPressed1 = false
                        self.isPressed2 = false
                        
                        priorityCheck()
                        }) {
                        Text("A")
                            .font(.title)
                            .background(
                                Image(isPressed ? "buttonBackgroundPressed" : "buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        self.priority2.toggle()
                        
                        self.isPressed1.toggle()
                        self.isPressed = false
                        self.isPressed2 = false
                        
                        priorityCheck()
                    }) {
                        Text("B")
                            .font(.title)
                            .background(Image(isPressed1 ? "buttonBackgroundPressed" : "buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        self.priority3.toggle()
                        
                        self.isPressed2.toggle()
                        self.isPressed = false
                        self.isPressed1 = false
                        
                        priorityCheck()
                    }) {
                        Text("C")
                            .font(.title)
                            .background(Image(isPressed2 ? "buttonBackgroundPressed" : "buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                    
                }.padding()
                
                Text("If the task doesn't have a priority, don't press any buttons")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, alignment: .center)
                    .padding(.top, 20.0)
                    .background(Rectangle().fill(Color.white)
                                    .shadow(radius: 3)
                                    .padding(.top, 20.0))
                
                VStack {
                    Text("Title of task:")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TextField("Enter name of task here...", text: $titleOfTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
                .padding(.top, 50)
                
                
                Button(action: {
                    //This button saves data in CoreData//
                    
                    if titleOfTask == ""{
                        //to be changed//
                        print("No task name or priority")
                    } else{
                    
                    let task = Task(context: self.moc)
                    
                    task.id = UUID()
                    task.title = titleOfTask
                    task.completionState = false
                    
                    if priority1 == true{
                        task.priority = "A"
                    }else if priority2 == true{
                        task.priority = "B"
                    }else if priority3 == true{
                        task.priority = "C"
                    }else{
                        task.priority = "Dorment"
                    }
    
                    try? self.moc.save()
                    
                    UIApplication.shared.endEditing()
                        
                    self.presentation.wrappedValue.dismiss()
                }
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .frame(height: 50.0)
                        .background(Image("buttonBackground")
                                        .resizable()
                                        .frame(width: 100, height: 70))
                        .cornerRadius(6.0)
                        
                }
                .padding(.horizontal, 140)
                .offset( y: 100)
                
            }
            .padding(.all)
            .offset(y: -200.0)
        }
    }
    
    struct EditView_Previews: PreviewProvider {
        static var previews: some View {
            EditView()
        }
    }
}


extension UIApplication{
    func endEditing() {
            sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
