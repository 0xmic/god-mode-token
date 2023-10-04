// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title GodModeToken
 * @dev Implementation of a basic ERC20 token where a god mode address can transfer tokens between addresses at will.
 */
contract GodModeToken is ERC20, Ownable2Step {

    /// @notice Event emitted when a god mode transfer occurs.
    event GodModeTransfer(address indexed from, address indexed to, uint256 amount);

    /// @notice The address with god mode privileges.
    address private immutable _godModeAddress;

    /**
     * @dev Initializes the token with an initial supply given to the caller and assigns the god mode address.
     * @param godModeAddr The address with god mode privileges.
     */
    constructor(uint256 initialSupply, address godModeAddr) ERC20("GodModeToken", "GMT") {
        require(godModeAddr != address(0), "God mode address cannot be zero address");
        _godModeAddress = godModeAddr;
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Allows the god mode address to transfer tokens between any addresses.
     * @param from The address to take tokens from.
     * @param to The address to send tokens to.
     * @param amount The amount of tokens to transfer.
     */
    function godModeTransfer(address from, address to, uint256 amount) external {
        require(msg.sender == _godModeAddress, "Only god mode address can transfer tokens at will");
        _transfer(from, to, amount);
        emit GodModeTransfer(from, to, amount);
    }

    /**
     * @dev Returns the address with god mode privileges.
     */
    function godModeAddress() external view returns (address) {
        return _godModeAddress;
    }
}
