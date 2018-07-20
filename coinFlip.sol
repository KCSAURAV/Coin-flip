pragma solidity ^0.4.0;
contract coinFlip{
  string outcome;
  mapping (address => uint) tokens;
  Game[] players;
  
  struct Game{
    string guess;
    uint token;
  }
  
  function placeBet( string _guess, uint _bet ) public{
    // uint rand = keccak256(str);
    require( _bet > 0 && _bet < 340282366920938463463374607431768211455); // 2^128 - 1
    
    address id_ = msg.sender; // address of player
    uint index = players.push(Game(_guess,_bet));
    tokens[id_] = index;
  }
  
  function getLastBet()public view returns(uint){
    address owner = msg.sender;
    uint id_ = tokens[owner]; // id of the mapped user
    return players[id_ - 1].token; // since arrays start at 0
  }
 
  function getSummary() public view returns (uint){
    for(uint i = 0; i<players.length;i++){
      return players[i].token;
    }
  }
  
  function coinToss() internal view returns(string){
    uint rand = uint(blockhash(block.number-1)) % 10 + 1; // Generates a random uint
    if( rand%2 == 0 ) return "H";
    else return "T";
  }
  
  function evaluate() public{
    outcome = coinToss();
    for(uint i = 0; i<players.length;i++){
    if(keccak256(abi.encodePacked( outcome )) == keccak256( abi.encodePacked( players[i].guess ))){
      players[i].token *= 2; // double it
    } else players[i].token = 0; // make it zero
    }
  }
  
}
