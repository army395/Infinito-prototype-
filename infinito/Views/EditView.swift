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
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("Title of task")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    TextField("Enter name of task here...", text: $titleOfTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        //This button saves data in CoreData//
                        
                        //Implement if/else statement to check if data is actually inserted//
                        let task = Task(context: self.moc)
                        
                        task.id = UUID()
                        task.title = titleOfTask
                        task.completionState = false
                        
                        try? self.moc.save()
                        
                        UIApplication.shared.endEditing()
                    }) {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .background(Image("buttonBackground")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 70))
                            .cornerRadius(6.0)
                    }
                }

                
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
