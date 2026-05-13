#include <iostream>
#include <vector>
using namespace std;

// ?? Student Class
class Student {
public:
    string name;
    int id;
    double marks;

    // Constructor
    Student(string name, int id, double marks) {
        this->name = name;
        this->id = id;
        this->marks = marks;
    }

    // Display method
    void display() {
        cout << "ID: " << id << ", Name: " << name << ", Marks: " << marks << endl;
    }
};

// ?? Global list of students
vector<Student> students;

// ?? Add Student
void addStudent() {
    string name;
    int id;
    double marks;

    cout << "Enter Name: ";
    cin.ignore(); // clear buffer
    getline(cin, name);

    cout << "Enter ID: ";
    cin >> id;

    cout << "Enter Marks: ";
    cin >> marks;

    students.push_back(Student(name, id, marks));
    cout << "Student Added Successfully!\n\n";
}

// ?? Display Students
void displayStudents() {
    if (students.empty()) {
        cout << "No students found.\n\n";
        return;
    }

    for (auto &s : students) {
        s.display();
    }
    cout << endl;
}

// ?? Search by ID
void searchById() {
    int id;
    cout << "Enter ID to search: ";
    cin >> id;

    for (auto &s : students) {
        if (s.id == id) {
            cout << "Student Found:\n";
            s.display();
            cout << endl;
            return;
        }
    }

    cout << "Student not found.\n\n";
}

// ?? Calculate Average
void calculateAverage() {
    if (students.empty()) {
        cout << "No students to calculate average.\n\n";
        return;
    }

    double sum = 0;
    for (auto &s : students) {
        sum += s.marks;
    }

    double avg = sum / students.size();
    cout << "Average Marks: " << avg << "\n\n";
}

// ?? Main Menu
int main() {

    while (true) {
        cout << "===== Student System =====\n";
        cout << "1. Add Student\n";
        cout << "2. Display Students\n";
        cout << "3. Search by ID\n";
        cout << "4. Calculate Average\n";
        cout << "5. Exit\n";

        cout << "Choose option: ";
        int choice;
        cin >> choice;

        switch (choice) {
            case 1: addStudent(); break;
            case 2: displayStudents(); break;
            case 3: searchById(); break;
            case 4: calculateAverage(); break;
            case 5: cout << "Exiting...\n"; return 0;
            default: cout << "Invalid choice\n\n";
        }
    }
}
