pragma solidity ^0.4.19;

import "./Ownable.sol";

contract Iddaa is Ownable {
    
    struct Gambler {
         address _address;    // voter address
         uint bet;           // ether amount of the voter
         uint ratio;         // ratio for the total amount of bets
     }
     
     mapping(uint => Gambler) public up_gamblers;
     mapping(uint => Gambler) public down_gamblers;
                                                                                                                                                                                                                                                                                                                                                                  
     uint up_count = 0;
     uint down_count = 0;
     
     uint up_ratio_count = 0;
     uint down_ratio_count = 0;
     
     //Minimum price to vote for any
     uint private minVotePrice = 0.2 ether;
     
     uint private paidForUp = 0;
     uint private paidForDown = 0;
     

    constructor() payable public {
        
    }
    
    function voteUp() external payable{
       Gambler memory g;
       
       g._address=msg.sender;
       g.bet=msg.value;
       g.ratio=g.bet/minVotePrice;
       
       paidForUp+=g.bet;
       
       up_gamblers[up_count]=g;
       
       up_count++;
       up_ratio_count +=g.ratio;
    }
    
    function voteDown() external payable{
       Gambler memory g;
       
       g._address=msg.sender;
       g.bet=msg.value;
       g.ratio=g.bet/minVotePrice;

       paidForDown+=g.bet;

       down_gamblers[down_count]=g;
       
       down_count++;
       down_ratio_count +=g.ratio;

    }
    
    function withdrawToOwner() private onlyOwner {
       owner.transfer(address(this).balance/4);
    }
    
   
    function giveRewards(string winner) external payable onlyOwner{
        withdrawToOwner();
        uint totalReward = 3*(paidForDown + paidForUp)/4;
        uint i;
        uint paymentForUnit;
        if(keccak256(winner) == keccak256("up")){
             paymentForUnit = totalReward/up_ratio_count;
            for( i=0; i<up_count; i++){
                up_gamblers[i]._address.transfer(paymentForUnit * up_gamblers[i].ratio);
            }
        }
        else if (keccak256(winner) == keccak256("down")){
             paymentForUnit = totalReward/down_ratio_count;
            for( i=0; i<down_count; i++){
                down_gamblers[i]._address.transfer(paymentForUnit * down_gamblers[i].ratio);
            }
        }
        
        


    }
 
}