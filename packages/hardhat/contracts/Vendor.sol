pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 constant public tokensPerETH = 100;
  event BuyTokens(address buyer, uint amountOfETH, uint amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() payable public {
    uint256 amountOfETH = msg.value;
    uint256 amountOfTokens = amountOfETH * tokensPerETH;
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, amountOfETH, amountOfTokens);

  }

  function withdraw() payable public {
    address payable owner = payable(owner());
    require(msg.sender == owner);
    owner.transfer(address(this).balance);
    //yourToken.transfer(, yourToken.balanceOf(msg.sender));
  }
     // yourToken.transfer(owner(), address(this).balance);

  



  // ToDo: create a payable buyTokens() function:

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  // ToDo: create a sellTokens() function:

}
