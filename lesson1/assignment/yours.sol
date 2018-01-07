pragma solidity ^0.4.0;

contract Payroll {
    uint constant PAY_DURATION = 10 seconds;

    address employer = 0x0;
    address employee = 0x0;
    uint salary = 1 ether;
    uint nextPayTime = now + PAY_DURATION;

    event salaryChanged();
    event employeeChanged();

    function addFund() public payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function updateEmployee(address _employee) public {
        require(msg.sender == employer);
        require(_employee != 0x0 && _employee != employee);

        payAllUnpaidSalaries();
        employee = _employee;

        employeeChanged();
    }

    function updateSalary(uint _salary) public {
        require(msg.sender == employer);
        require(_salary != salary);

        payAllUnpaidSalaries();
        salary = _salary;

        salaryChanged();
    }

    function getPaid() public {
        require(msg.sender == employee);
        require(now >= nextPayTime);

        nextPayTime += PAY_DURATION;
        employee.transfer(salary);
    }

    function payAllUnpaidSalaries() private {
        uint lastPayTime = nextPayTime - PAY_DURATION;
        uint workingDuration = now - lastPayTime;
        if (workingDuration <= 0) {
            return;
        }

        nextPayTime = now + PAY_DURATION;
        employee.transfer(salary * workingDuration / PAY_DURATION);
    }
}
