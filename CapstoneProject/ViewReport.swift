import SwiftUI

// MARK: - Explore Existing Reports (unchanged UI)
struct ExploreReportsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Back Button
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height:30)
                        .font(.title)
                    Text("Back")
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
            
            Spacer(minLength: 40)
            
            // Title
            VStack(spacing: 8) {
                Text("View Report")
                    .font(.custom("Helvetica-Bold", size: 27))
                    .padding(.top, 10)
                    .foregroundColor(Color(hex: "#312F30"))
                    .kerning(0.2)
                    .lineSpacing(30)
                    .padding(.top, 100)
                
                Text("Pick a category to see the full list.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 10)
            
            // Categories
            VStack(spacing: 12) {
                ForEach(ReportCategory.allCases) { category in
                    NavigationLink {
                        ReportListView(category: category)
                    } label: {
                        Text(category.rawValue)
                            .font(.custom("Helvetica-Bold", size: 18))
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .buttonStyle(PillOutlineButtonStyle())
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, 150)
        .background(Color(.systemBackground))
        .padding()
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Supabase-backed List Screen
struct ReportListView: View {
    let category: ReportCategory
    
    @State private var items: [ReportsAPI.NetReport] = []
    @State private var isLoading = false
    @State private var errorText: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading…").padding()
            } else if let errorText {
                VStack(spacing: 8) {
                    Text("Failed to load").font(.headline)
                    Text(errorText).font(.caption).foregroundStyle(.secondary)
                    Button("Retry") { Task { await load() } }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "#312F30"))
                    Text("No reports yet")
                        .font(.custom("Helvetica-Bold", size: 20))
                        .padding(.top, 10)
                        .foregroundColor(Color(hex: "#312F30"))
                        .kerning(0.2)
                        .lineSpacing(30)
                        .padding(.top, 0)
                    Text("Check back later or pick another category.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List(items, id: \.id) { r in
                    NavigationLink {
                        ReportDetailViewNet(report: r)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(r.animalType ?? "Animal")
                                    .font(.headline)
                                Spacer()
                                Text(r.status ?? "Unknown")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(.gray.opacity(0.15)))
                            }
                            Text(r.nearestLandmark ?? "Unknown location")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable { await load() }
            }
        }
        .task { await load() }
        .navigationTitle(category.rawValue)
    }

    private func load() async {
        isLoading = true
        errorText = nil
        do {
            items = try await ReportsAPI.fetch(category: category)
        } catch {
            items = []
            errorText = "\(error)"
        }
        isLoading = false
    }
}

// MARK: - Supabase-backed Detail + Status Update
struct ReportDetailViewNet: View {
    let report: ReportsAPI.NetReport
    @State private var currentStatus: String
    @State private var saving = false
    @State private var saveMsg: String?

    // Simple demo statuses for community updates
    private let statuses = ["Unknown", "Open", "In Progress", "Resolved"]

    init(report: ReportsAPI.NetReport) {
        self.report = report
        _currentStatus = State(initialValue: report.status ?? "Unknown")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(report.animalType ?? "Animal").font(.title2).bold()
            Text("Location: \(report.nearestLandmark ?? "Unknown")")
            Text("Status: \(currentStatus)")

            Picker("Update Status", selection: $currentStatus) {
                ForEach(statuses, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.segmented)
            .padding(.top, 8)

            Button {
                Task {
                    saving = true; defer { saving = false }
                    do {
                        try await ReportsAPI.updateStatus(id: report.id, status: currentStatus)
                        saveMsg = "Updated!"
                    } catch {
                        saveMsg = "Update failed: \(error)"
                    }
                }
            } label: {
                Text(saving ? "Saving…" : "Save")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)

            if let created = report.created_at {
                Text("Created: \(created.formatted())").foregroundStyle(.secondary)
            }
            if let saveMsg { Text(saveMsg).foregroundStyle(.secondary) }

            Spacer()
        }
        .padding()
        .navigationTitle("Report")
    }
}

// MARK: - Preview
struct ExploreReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { ExploreReportsView() }
    }
}
