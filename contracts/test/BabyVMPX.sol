// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

// TODO: TEST ONLY !!!
contract BabyVMPX is ERC20("VMPX", "VMPX"), ERC20Capped(108_624 ether) {

    uint256 public constant BATCH = 1_000 ether;
    uint256 public immutable cycles; // depends on a network block side, set in constructor

    uint256 public counter;
    mapping(uint256 => bool) private _work;

    constructor(uint256 cycles_) {
        require(cycles_ > 0, 'bad limit');
        cycles = cycles_;
    }

    function _doWork() internal {
        for(uint i = 0; i < cycles; i++) {
            _work[++counter] = true;
        }
    }

    function _mint(address account, uint256 amount) internal override (ERC20, ERC20Capped) {
        super._mint(account, amount);
    }

    function mint() external {
        require(tx.origin == msg.sender, 'sorry folks, only EOAs');
        _doWork();
        _mint(msg.sender, BATCH);
    }
}
