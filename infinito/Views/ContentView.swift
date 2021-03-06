//
//  ContentView.swift
//  infinito
//
//  Created by Armando Visini on 31/10/2020.
//

import SwiftUI

//VERY IMPORTANT NOTE//



struct ContentView: View {
    //MARK: -Properties and Methods
    //CoreData enviroment and fetchRequest//
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: [ NSSortDescriptor(
                                                                keyPath: \Task.userOrder,
                                                                ascending: true),
                                                            NSSortDescriptor(
                                                                keyPath:\Task.title,
                                                                ascending: true )]) var tasks: FetchedResults<Task>
    //sheet view..need to find a way to close view using the confirm button//
    @State private var isPresented = false
    @State private var isEditing = false
   
    
    func move( from source: IndexSet, to destination: Int){
        // Make an array of items from fetched results
        var taskItems: [ Task ] = tasks.map{ $0 }
        
        // change the order of the items in the array
        taskItems.move(fromOffsets: source, toOffset: destination )
        
        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride( from: taskItems.count - 1,
                                    through: 0,
                                    by: -1 )
        {
            taskItems[ reverseIndex ].userOrder =
                Int16( reverseIndex )
        }
    }

    //MARK: -View
    var body: some View {
            NavigationView {
                VStack {
                    ZStack {
                        //List with delete with swipe functionality//
                        List{
                            ForEach(tasks, id: \.id){ task in
                                CellView(completionState: task.completionState, title: task.title!, priority: task.priority ?? "")
                            }
                            .onMove(perform: move)
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
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    self.isPresented.toggle()
                                    print(isPresented)
                                }) {
                                    CircleView()
                                }
                            }
                        }.offset(x: -10, y: -10)
                        
                    }
                    
                    HStack(spacing: 70) {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Image(systemName: "highlighter")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding()
                                .foregroundColor(isEditing ? .green : .orange)
                        }
                        Button(action: {}){
                            Image(systemName: "timelapse")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding()
                                .foregroundColor(.gray)
                            
                        }
                        
                        NavigationLink(destination: TimeCrunchView()) {
                            Image(systemName: "alarm")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding()
                                .foregroundColor(.red)
                        }
                        
                    }
                    .background(Color(.white))
                    .navigationBarTitle("Infinito")
                }
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
            }
            .sheet(isPresented: $isPresented, content: {
                EditView()
                    .environment(\.managedObjectContext, self.moc)
                //edit view with MOC passed//
            })
            //tool bar//

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
    
    @State  var completionState: Bool
    @State  var title: String
    @State  var priority: String
    @State  var actionSheetPresented = false
    
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
            .buttonStyle(PlainButtonStyle())
            
            Text(title)
                .foregroundColor(.black)
            
            Spacer()
            
            switch priority {
            case "Dorment":
                
                Button(action: {self.actionSheetPresented.toggle()}) {
                    Image(systemName: "zzz")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 10.0)
                
                
                
            default:
                Button(action: {self.actionSheetPresented.toggle()}) {
                    
                    Text(priority)
                        .background(Image("buttonBackground")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                        .cornerRadius(30.0))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing)
                
            }
            
        }
        .actionSheet(isPresented: $actionSheetPresented, content: {
            ActionSheet(title: Text("Change the priority"), message: nil, buttons: [
                .default(Text("A")) {priority = "A"},
                .default(Text("B")) {priority = "B"},
                .default(Text("C")) {priority = "C"},
                .default(Text("Dorment")) {priority = "Dorment"}
            ])
        })
    }
}

