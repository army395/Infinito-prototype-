//
//  EditView.swift
//  Infinito
//
//  Created by Armando Visini on 28/10/2020.
//
import SwiftUI

struct EditView: View{
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State var titleOfTask: String = ""
    @State var priority1: Bool = false
    @State var priority2: Bool = false
    @State var priority3: Bool = false
    
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
            VStack(alignment: .leading){
                Text("Title of task")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    TextField("Enter name of task here...", text: $titleOfTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                Text("Priority")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 50.0)
                    .padding(.bottom, 35.0)
                    
                HStack (spacing: 100) {
                    Button(action: {
                        self.priority1.toggle()
                        
                        priorityCheck()
                        }) {
                        Text("A")
                            .font(.title)
                            .background(Image("buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        self.priority2.toggle()
                        
                        priorityCheck()
                    }) {
                        Text("B")
                            .font(.title)
                            .background(Image("buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        self.priority3.toggle()
                        
                        priorityCheck()
                    }) {
                        Text("C")
                            .font(.title)
                            .background(Image("buttonBackground")
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .cornerRadius(50.0))
                            .foregroundColor(.white)
                    }
                }.offset(x: 50)
                
                Button(action: {
                    //This button saves data in CoreData//
                    
                    if titleOfTask == ""{
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
                    }
                    
                    try? self.moc.save()
                    
                    UIApplication.shared.endEditing()
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
                .padding(.horizontal, 140.0)
                .offset( y: 100)
                
            }
            .padding()
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
