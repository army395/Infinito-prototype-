//
//  ContentView.swift
//  infinito
//
//  Created by Armando Visini on 31/10/2020.
//

import SwiftUI

struct ContentView: View {
//MARK: -Properties
    //CoreData enviroment and fetchRequest//
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    //sheet view..need to find a way to close view using the confirm button//
    @State var isPresented = false
 //MARK: -View
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    //List with delete with swipe functionality//
                    List{
                        ForEach(tasks, id: \.id){ task in
                            CellView(completionState: task.completionState, title: task.title ?? "")
                        }
                        .onDelete{IndexSet in
                            let deleteItem = self.tasks[IndexSet.first!]
                            self.moc.delete(deleteItem)
                            
                            do{
                               try moc.save()
                            }catch{
                                print(error)
                            }
                        }
                    }
                    .padding(.horizontal, -25.0)
                    
                    //go to EditView//
                    Button(action: {
                        self.isPresented.toggle()
                        print(isPresented)
                    }) {
                        CircleView()
                    }.offset(x: 158, y: 250)
                    
                }
                .navigationBarTitle("Infinito")
                .sheet(isPresented: $isPresented, content: {
                    EditView()
                        .environment(\.managedObjectContext, self.moc)
                    //edit view with MOC passed//
                })
            }
            //tool bar//
            HStack(alignment: .center, spacing: 97) {
                Button(action: {}) {
                    Image(systemName: "highlighter")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding()
                        .foregroundColor(.orange)
                }.offset(x: 10)
                Button(action: {}){
                    Image(systemName: "timelapse")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .offset(x: 4, y: 0)
                        .padding()
                        .foregroundColor(.green)
                }.offset(x: -7)
                .padding(.trailing, 20.0)
                Button(action: {}){
                    Image(systemName: "alarm")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.red)
                }.offset(x: -24)
            }
        }
        
    }

//MARK: -Preview
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            return ContentView().environment(\.managedObjectContext, context)
        }
    }
}
//MARK: -CellView
struct CellView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State var completionState: Bool
    @State var title: String

    var body: some View {
        HStack{
           //Mark task complete//
            Button(action: {
                completionState.toggle()
            }) {
                switch completionState{
                case false:
                    Image(systemName: "square")
                        .resizable()
                    
                    
                case true:
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .foregroundColor(.green)
                }
                
            }
            .frame(width: 30, height: 30, alignment: .center)
            
                Text(title)
                    .foregroundColor(.black)
            
                
            }
        }
    }

