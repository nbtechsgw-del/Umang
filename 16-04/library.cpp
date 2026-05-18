#include <iostream>
#include <string>
#include <vector>

class Book {
public:
    std::string title;
    bool isIssued;
    std::string dueDate;

    Book(std::string t) {
        title = t;
        isIssued = false;
        dueDate = "N/A";
    }
};

class Library {
private:
    std::vector<Book> shelf;

public:
    // Add a book to the vector
    void addBook(std::string name) {
        shelf.push_back(Book(name));
        std::cout << "Book Added: " << name << std::endl;
    }

    // Issue a book
    void issueBook(std::string name) {
        for (int i = 0; i < shelf.size(); i++) {
            if (shelf[i].title == name && !shelf[i].isIssued) {
                shelf[i].isIssued = true;
                shelf[i].dueDate = "14 Days From Today"; 
                std::cout << name << " has been issued. Due in 14 days." << std::endl;
                return;
            }
        }
        std::cout << "Error: Book is already issued or doesn't exist." << std::endl;
    }

    // Return a book
    void returnBook(std::string name) {
        for (int i = 0; i < shelf.size(); i++) {
            if (shelf[i].title == name && shelf[i].isIssued) {
                shelf[i].isIssued = false;
                shelf[i].dueDate = "N/A";
                std::cout << name << " has been returned successfully." << std::endl;
                return;
            }
        }
        std::cout << "Error: This book wasn't out on loan." << std::endl;
    }
};

int main() {
    Library myLibrary;

    // 1. Fill the library
    myLibrary.addBook("C++ Basics");
    myLibrary.addBook("OOP Principles");

    // 2. Try issuing a book
    myLibrary.issueBook("C++ Basics");

    // 3. Try issuing it again (Should show error)
    myLibrary.issueBook("C++ Basics");

    // 4. Return the book
    myLibrary.returnBook("C++ Basics");

    return 0;
}
