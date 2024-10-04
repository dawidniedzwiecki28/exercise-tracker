import SwiftUI

struct ExerciseEditorView: View {
    @Binding var exercise: Exercise?
    var onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var date = Date()
    @State private var duration = "1"
    @State private var selectedActivity: Activity?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .onChange(of: date) { _ in
                    }
                TextField("Duration", text: $duration)
                    .keyboardType(.numberPad)
                
                Picker("Activity", selection: $selectedActivity) {
                    ForEach(DataManager.shared.getAllActivities(), id: \.self) { activity in
                        Text(activity.name ?? "Unnamed Activity").tag(activity as Activity?)
                    }
                }
            }
            .navigationBarTitle(exercise == nil ? "Create Exercise" : "Edit Exercise")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if validateInputs() {
                        if let exercise = exercise {
                            DataManager.shared.updateExercise(exercise: exercise, date: date, duration: Int(duration) ?? 0, activity: selectedActivity!)
                        } else {
                            DataManager.shared.createExercise(date: date, duration: Int(duration) ?? 0, activity: selectedActivity!)
                        }
                        onSave()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        // Show error message if validation fails
                        showAlert = true
                    }
                }
            )
            .onAppear {
                if let exercise = exercise {
                    date = exercise.date ?? Date()
                    duration = String(exercise.duration)
                    selectedActivity = exercise.activity
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard let durationValue = Int(duration) else {
            alertMessage = "Duration should be a valid number."
            return false
        }
        if durationValue < 1 {
            alertMessage = "Duration should be at least 1."
            return false
        }
        if selectedActivity == nil {
            alertMessage = "Please select an activity."
            return false
        }
        if date > Date() {
            alertMessage = "Date cannot be in the future."
            return false
        }
        return true
    }
}

struct ExerciseEditorView_Previews: PreviewProvider {
    @State static var exercise: Exercise? = nil

    static var previews: some View {
        ExerciseEditorView(exercise: $exercise, onSave: {})
    }
}

