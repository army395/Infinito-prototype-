//
//  ContentView.swift
//  infinito
//
//  Created by Armando Visini on 31/10/2020.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State var isPresented = false
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    List{
                        ForEach(tasks, id: \.id){ task in
                            CellView(completionState: task.completionState, title: task.title!)
                        }
                    }.padding(.horizontal, -25.0)
                    
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
                })
            }
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
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            return ContentView().environment(\.managedObjectContext, context)
        }
    }
}

struct CellView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    var completionState: Bool
    var title: String
    
    var body: some View {
        HStack{
            switch completionState{
            case false:
                Image(systemName: "square")
                
            case true:
                Image(systemName: "checkmark.square")
                    .foregroundColor(.green)}
                
                Text(title)
                    .foregroundColor(.black)
                
            }
        }
    }

