pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {


  YourToken public yourToken;
  uint256 constant public tokensPerETH = 100;
  event BuyTokens(address buyer, uint amountOfETH, uint amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() external payable {
    uint256 amountOfTokens = msg.value * tokensPerETH;
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value , amountOfTokens);

  }


  function withdraw() external onlyOwner {
    // address payable owner = payable(owner());
    // require(msg.sender == owner);
    // owner.transfer(address(this).balance);
    (bool sent, ) = msg.sender.call{value: address(this).balance}("");
    require(sent, "withdraw failure");

  }

  function sellTokens(uint theAmount) external  {
    uint256 allowance = yourToken.allowance(msg.sender, address(this));
    require(allowance >= theAmount, "You don't have the enough allowance");

    bool tokenSuccess = yourToken.transferFrom(msg.sender, address(this), theAmount); 
    require(tokenSuccess, "token transfer failed");

    uint256 backEth = theAmount / tokensPerETH;
    (bool ethSuccess, ) = msg.sender.call{value: backEth}("");
    require(ethSuccess, "transfer eth back failed");
    //payable(msg.sender).transfer(theAmount / tokensPerETH);
    emit SellTokens(msg.sender, backEth, theAmount);

  }



  // ToDo: create a payable buyTokens() function:

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  // ToDo: create a sellTokens() function:

}
