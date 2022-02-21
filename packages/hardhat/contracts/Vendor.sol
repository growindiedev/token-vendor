pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {


  YourToken yourToken;
  

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  uint public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfEth, uint256 amountOfTokens);
  event SellTokens(address seller, uint amountOfTokens, uint amountOfEth);

  function buyTokens() external payable {
    uint amountOfTokens = msg.value * tokensPerEth;
    (bool sent) = yourToken.transfer(msg.sender, amountOfTokens);
    require(sent, "Failed to transfer tokens");
    emit BuyTokens(msg.sender, msg.value , amountOfTokens);
  }


  function withdraw() external onlyOwner {
    (bool sent, ) = msg.sender.call{value: address(this).balance}("");
    require(sent, "withdraw failure");

  }

  function sellTokens(uint theAmount) external  {
    uint256 allowance = yourToken.allowance(msg.sender, address(this));
    require(allowance >= theAmount, "You don't have the enough allowance");

    bool tokenSuccess = yourToken.transferFrom(msg.sender, address(this), theAmount); 
    require(tokenSuccess, "token transfer failed");

    uint256 backEth = theAmount / tokensPerEth;
    (bool ethSuccess, ) = msg.sender.call{value: backEth}("");
    require(ethSuccess, "transfer eth back failed");
    emit SellTokens(msg.sender, backEth, theAmount);

  }


}