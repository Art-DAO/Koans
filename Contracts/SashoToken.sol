// SashoToken.sol
// This contract represents the Sasho Token and includes improvements based on the provided suggestions.

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// SashoToken contract inherits from the OpenZeppelin ERC20 contract.
contract SashoToken is ERC20 {
    using SafeMath for uint256;

    // Constructor to initialize the SashoToken with its name, symbol, and initial supply.
    constructor(uint256 initialSupply) public ERC20("Sasho Token", "SASHO") {
        _mint(msg.sender, initialSupply);
    }

    // Function to transfer tokens from the sender to the recipient.
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "SashoToken: transfer to the zero address");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // Function to approve a spender to spend tokens on behalf of the owner.
    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "SashoToken: approve to the zero address");
        _approve(_msgSender(), spender, amount);
        return true;
    }

    // Function to transfer tokens from one address to another on behalf of the owner.
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(sender != address(0), "SashoToken: transfer from the zero address");
        require(recipient != address(0), "SashoToken: transfer to the zero address");
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "SashoToken: transfer amount exceeds allowance"));
        return true;
    }

    // Internal function to handle token transfers.
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(sender != address(0), "SashoToken: transfer from the zero address");
        require(recipient != address(0), "SashoToken: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount, "SashoToken: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    // Internal function to handle token approvals.
    function _approve(address owner, address spender, uint256 amount) internal override {
        require(owner != address(0), "SashoToken: approve from the zero address");
        require(spender != address(0), "SashoToken: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}