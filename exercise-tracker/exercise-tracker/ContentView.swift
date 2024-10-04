//
//  ContentView.swift
//  exercise-tracker
//
//  Created by Dawid Niedźwiecki on 09/06/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var exercises: [Exercise] = []
    @State private var selectedActivity: Activity?
    @State private var showingExerciseEditor = false
    @State private var showingActivityEditor = false
    @State private var exerciseToEdit: Exercise?

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter by Activity", selection: $selectedActivity) {
                    Text("All Activities").tag(Activity?.none)
                    ForEach(DataManager.shared.getAllActivities(), id: \.self) { activity in
                        Text(activity.name ?? "Unnamed Activity").tag(activity as Activity?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedActivity) { _ in
                    loadExercises()
                }
                
                List {
                    ForEach(exercises, id: \.self) { exercise in
                        VStack(alignment: .leading) {
                            Text("Date: \(exercise.date ?? Date(), formatter: dateFormatter)")
                            Text("Duration: \(exercise.duration) minutes")
                            Text("Activity: \(exercise.activity?.name ?? "No Activity")")
                        }
                        .onTapGesture {
                            exerciseToEdit = exercise
                            showingExerciseEditor = true
                        }
                    }
                    .onDelete(perform: deleteExercise)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        exerciseToEdit = nil
                        showingExerciseEditor = true
                    }) {
                        Text("Create Exercise")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Exercises")
            .navigationBarItems(trailing: Button(action: {
                showingActivityEditor = true
            }) {
                Text("Create Activity")
            })
            .onAppear {
                loadExercises()
            }
            .sheet(isPresented: $showingExerciseEditor) {
                ExerciseEditorView(exercise: $exerciseToEdit, onSave: loadExercises)
            }
            .sheet(isPresented: $showingActivityEditor) {
                ActivityEditorView(onSave: loadExercises)
            }
        }
    }

    private func loadExercises() {
        if let activity = selectedActivity {
            exercises = DataManager.shared.getAllExercisesWith(activity: activity)
        } else {
            exercises = DataManager.shared.getAllExercises()
        }
    }

    private func deleteExercise(at offsets: IndexSet) {
        for index in offsets {
            DataManager.shared.deleteExercise(exercise: exercises[index])
        }
        loadExercises()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    ContentView()
}
