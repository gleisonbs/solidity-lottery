// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address public manager;
    uint constant public fee = 0.1 ether;
    uint constant public minAmountPlayers = 3;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == fee);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager, "Only the manager can pick a winner");
        require(players.length >= minAmountPlayers, "At least 3 players must be in the lottery before picking a winner");

        uint winnerIndex = random() % players.length;
        address payable winner = players[winnerIndex];

        winner.transfer(getBalance());
    }
}
