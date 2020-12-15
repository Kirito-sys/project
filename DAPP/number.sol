// SPDX-License-Identifier: yewenlong
pragma solidity >=0.5.0 <=0.7.3;
contract gameChain{
function rand(uint256 _length) public view returns(uint256) {
    uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty,block.timestamp)));
    return random%_length;
}
}