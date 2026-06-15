#include <iostream>
#include <vector>
#include <string>
#include <stdexcept>

class BankAccount {
private:
    std::string holderName;
    double balance;
    std::vector<std::string> history;

public:
    BankAccount(std::string name, double initialDeposit) {
        holderName = name;
        balance = initialDeposit;
        history.push_back("Account opened with: $" + std::to_string(initialDeposit));
    }

    // Deposit Money
    void deposit(double amount) {
        if (amount <= 0) {
            throw std::invalid_argument("Deposit must be a positive amount.");
        }
        balance += amount;
        history.push_back("Deposited: $" + std::to_string(amount));
    }

    // Withdraw Money (This is where the logic gets important!)
    void withdraw(double amount) {
        if (amount > balance) {
            throw std::runtime_error("Insufficient funds! Your balance is only $" + std::to_string(balance));
        }
        if (amount <= 0) {
            throw std::invalid_argument("Withdrawal must be a positive amount.");
        }
        balance -= amount;
        history.push_back("Withdrew: $" + std::to_string(amount));
    }

    void showHistory() {
        std::cout << "\n--- Transaction History for " << holderName << " ---\n";
        for (const std::string& record : history) {
            std::cout << record << std::endl;
        }
    }
};

int main() {
    BankAccount myAccount("User1", 500.0);

    try {
        myAccount.deposit(200);
        std::cout << "Successfully deposited $200." << std::endl;

        std::cout << "Attempting to withdraw $1000..." << std::endl;
        myAccount.withdraw(1000); 

    } 
    catch (const std::exception& e) {
        std::cout << "BANK ERROR: " << e.what() << std::endl;
    }

    myAccount.showHistory();

    return 0;
}
