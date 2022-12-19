// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;


contract Lottery {
    address payable[] public participats;
    address public manager;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether,"1 ether transfer to participate in lotery!");
        participats.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint256){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participats.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager,"Only Manager can select Winner!");
        require(participats.length>=3,"Minimum 3 Participats Required for select winner!");
        uint256 winnerIndex = random()%participats.length;
        address payable winner;
        winner = participats[winnerIndex];
        winner.transfer(getBalance());
        participats = new address payable[](0);
    }

}