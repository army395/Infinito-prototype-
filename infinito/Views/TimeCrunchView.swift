//
//  TimeCrunchView.swift
//  infinito
//
//  Created by Armando Visini on 17/11/2020.
//

import SwiftUI

struct TimeCrunchView: View {
    
    @State var percentageState: CGFloat = 0
    
    @State var timeRemaining: CGFloat = 60
    
    var selectedTimeRemaining: CGFloat = 60
    
    @State var isActive: Bool = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Spacer()
                
                Text("Current Task")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack{
                    ZStack{
                        //design//
                        Track()
                        CLabel(minutes: timeRemaining)
                        Outline(percentage: percentageState)
                    }
                }
     
            
                Spacer()
                
                    HStack {
                        switch isActive{
                        case false:
                        Image(systemName: "play")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                        
                        Text("Execute task")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                            
                        case true:
                            Image(systemName: "pause")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                            
                            Text("Pause")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                        }
                    }.onTapGesture{
                        self.isActive.toggle()
                    }
                    
                    Spacer()
                
                HStack(spacing: 70) {
                    Button(action: {}) {
                        Image(systemName: "highlighter")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding()
                            .foregroundColor(.orange)
                    }
                    Button(action: {}){
                        Image(systemName: "timelapse")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding()
                            .foregroundColor(.gray)
                        
                    }
                    
                    Button(action:{}) {
                        Image(systemName: "alarm")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding()
                            .foregroundColor(.red)
                    }
                }
                .padding(25.0)
                .background(Color(.white))
            }
            .onReceive(timer, perform: { _ in
                guard isActive else {return}
                if timeRemaining > 0{
                    timeRemaining -= 1
                    
                    percentageState = timeRemaining/selectedTimeRemaining
                }else{
                    self.isActive = false
                    timeRemaining = 60
                }
            })
            .edgesIgnoringSafeArea(.bottom)
        }
        

        }
    }


struct TimeCrunchView_Previews: PreviewProvider {
    static var previews: some View {
        TimeCrunchView()
    }
}

//structs to create circles and all//
struct CLabel: View{
    
    var minutes: CGFloat
    
    var body: some View{
        ZStack{
            Text(String(format: " %.0f", minutes))
                .font(.system(size: 65))
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.trailing, 10.0)
            Outline()
        }
    }
}

struct Outline: View{
    
    var percentage: CGFloat = 0
    var colors: [Color] = [Color.outlineColor]
    
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
                ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
                    
        }
    }
}

struct Track: View {
    var colors: [Color] = [Color.progressColor]
    
    var body: some View{
        ZStack{
            Circle()
                .fill(Color(.white))
                .frame(width: 250, height: 250)
                .overlay(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .fill(AngularGradient(gradient: .init(colors: colors), center: .center))
                )
        }
    }
    
    
}
