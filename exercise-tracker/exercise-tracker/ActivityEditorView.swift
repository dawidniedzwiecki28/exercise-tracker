
import SwiftUI

struct ActivityEditorView: View {
    var onSave: () -> Void

    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var activities: [Activity] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Create Activity")) {
                        TextField("Activity Name", text: $name)
                    }
                    
                    Section(header: HStack {
                        Text("Existing Activities")
                        Spacer()
                        EditButton()
                    }) {
                        List {
                            ForEach(activities, id: \.self) { activity in
                                Text(activity.name ?? "Unnamed Activity")
                            }
                            .onDelete(perform: deleteActivity)
                            .onMove(perform: moveActivity)
                        }
                    }
                }
                .navigationBarTitle("Create Activity")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Save") {
                        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            alertMessage = "Activity name cannot be empty."
                            showAlert = true
                        } else {
                            DataManager.shared.createActivity(name: name)
                            loadActivities()
                            onSave()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
                .onAppear {
                    loadActivities()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
                
                Image("activity_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    private func loadActivities() {
        activities = DataManager.shared.getAllActivities()
    }

    private func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            let activity = activities[index]
            if hasAssociatedExercises(activity: activity) {
                alertMessage = "Cannot delete activity with associated exercises."
                showAlert = true
            } else {
                DataManager.shared.deleteActivity(activity: activity)
                loadActivities()
            }
        }
    }

    private func moveActivity(from source: IndexSet, to destination: Int) {
        activities.move(fromOffsets: source, toOffset: destination)
        saveActivityOrder()
    }

    private func saveActivityOrder() {
        for (index, activity) in activities.enumerated() {
            activity.orderIndex = Int16(index)
        }
        DataManager.shared.saveContext()
    }

    private func hasAssociatedExercises(activity: Activity) -> Bool {
        return DataManager.shared.getAllExercisesWith(activity: activity).count > 0
    }
}

struct ActivityEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditorView(onSave: {})
    }
}
