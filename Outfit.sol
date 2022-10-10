//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";

contract CharacterOutfit{

    Outfit[] outfits; //The array that hiddes every outfit we uploaded
    uint public count; //Every time we create a outfit, the count will increase
    address owner; //Owner of the outfits
    
    event Launch(uint id, address indexed creator,  string outfitName, string redeemLink, uint raretiy, uint payment); 
    event Buy(uint indexed id, address indexed caller, uint amount);

    mapping(address => string) public boughtOutfits; //Buyers can see what outfit they bought

    struct Outfit{
        uint id; //ID of the outfit
        address creator;//Creator of the outfit
        string outfitName; //The name of the outfit
        string redeemLink; //Redeem link of the outfit for the game 
        uint raretiy; //Raretiy of the outfit
        uint payment; //How much cost its needed
    }


    constructor(){ // To initialize state variables
        owner = msg.sender;
    }

    modifier onlyOwner { //To check if the address is owner of the outfits or not
      require(msg.sender == owner, "You are not the owner");
      _; 
    }

    
    function lauchOutfit(string calldata _redeemLinkOfOutfit, string calldata _nameOfOutfit, uint _raretiy, uint _payment ) external onlyOwner{
        count += 1;
        outfits.push(Outfit({
            id: count,
            creator: msg.sender,
            outfitName: _nameOfOutfit,
            redeemLink: _redeemLinkOfOutfit,
            raretiy: _raretiy,
            payment: _payment
        }));
        emit Launch(count, msg.sender, _nameOfOutfit, _redeemLinkOfOutfit, _raretiy, _payment);
    } //The function which launch the outfit to the blockchain

    function buyOutfit(uint _id, uint _money) external returns (string memory){
        Outfit memory outfit = outfits[_id];

        require(_money == outfit.payment, "Wrong amount sended");

        emit Buy(_id, msg.sender, _money);
        boughtOutfits[msg.sender] = string.concat("Outfit Name: ", outfit.outfitName, " | Outfit Redeem Link: ", outfit.redeemLink, " || ", boughtOutfits[msg.sender]);
        return string (outfit.redeemLink);
    } //The function let users the buy the outfit

    function lookAtOutfits() external view returns (string memory){
        string memory AllOutfits;
        string memory name;
        string memory raretiy;
        string memory payment;
        Outfit memory outfit;
        for(uint id = 0; id < outfits.length; id++){
            outfit = outfits[id];
            name = outfit.outfitName;
            raretiy = Strings.toString(outfit.raretiy);
            payment = Strings.toString(outfit.payment);
            AllOutfits = string.concat(AllOutfits, " Name of the outfit: ", name , "| Outfit raretiy: ",raretiy, 
            "| Fee of the outfit: ",payment, "| ID number of the outfit: ", Strings.toString(id), "|| ");
        }
        return string (AllOutfits);
    } //Returns the name, raretiy, cost of the outfit, and index number
    
}
