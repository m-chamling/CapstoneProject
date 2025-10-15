import SwiftUI

// MARK: - Explore Existing Reports
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

// MARK: - List Screen
struct ReportListView: View {
    let category: ReportCategory
    
    // Start empty — later you can fill this from Core Data, JSON, etc.
    @State private var reports: [Report] = []
    
    var body: some View {
        if reports.isEmpty {
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
            List(reports.filter { $0.category == category }) { report in
                NavigationLink {
                    ReportDetailView(report: report)
                } label: {
                    ReportRow(report: report)
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Row & Detail
struct ReportRow: View {
    let report: Report
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(report.title)
                    .font(.headline)
                Spacer()
                Text(report.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.gray.opacity(0.15)))
            }
            Text(report.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct ReportDetailView: View {
    let report: Report
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(report.title).font(.title2).bold()
            Text("Location: \(report.location)")
            Text("Status: \(report.status.rawValue)")
        }
        .padding()
        .navigationTitle("Report")
    }
}

// MARK: - Minimal Report Model
struct Report: Identifiable {
    enum Status: String { case open = "Open", inProgress = "In Progress", resolved = "Resolved" }
    let id = UUID()
    var title: String
    var location: String
    var status: Status
    var category: ReportCategory
}

// MARK: - Preview
struct ExploreReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { ExploreReportsView() }
    }
}
