// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/openzeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Real is ERC20 {
    using SafeMath for uint;

   // uint pid;
    address public owner;
    //string pname;
    uint  amount;
    
    uint internal accumulated;

    address[] public tokenholders;

    mapping (address => uint256) public tokens;


    constructor (address _owner, string memory _name ,string memory _tokenname , uint _area)  ERC20(_name,_tokenname) {
        _mint(_owner,_area);
        tokens[_owner] = _area; 
        owner =_owner;
        }

        event Addedtokenholder(address TokenholderAdded);
        event Removedtokenholder( address TokenholderRemoved);
        event TokenTransfer(address from, address to, uint256 tokens);
        
       modifier onlyOwner {
      require(msg.sender == owner);
      _;
   }

//Check wether someone is token holder

        function istokenholder(address _address) public view returns(bool , uint256) {      
            for (uint256 s = 0; s < tokenholders.length; s += 1){
                if (_address == tokenholders[s]) return (true,s);
            }
        return (false ,0);
        } 

//To add tokenholder

        function addtokenholder(address _tholder)  public onlyOwner returns (bool)  {
            (bool _istholder, ) = istokenholder(_tholder);
            if (!_istholder) tokenholders.push(_tholder);
            emit Addedtokenholder(_tholder);
            return true;
            }


//Function to remove the token holder
        function removetholder(address _tholder) public onlyOwner {
            (bool _istholder, uint256 s) = istokenholder(_tholder);
            if (_istholder)
            { tokenholders[s] = tokenholders[tokenholders.length - 1];
            tokenholders.pop();
            emit Removedtokenholder(_tholder);
            }
            
        }

//Transfering of  tokens 
        function ttransfer(address _recipient, uint256 _amount) public  {      
            require(tokens[owner] >= _amount);
            tokens[owner] -= _amount;
            tokens[_recipient] += _amount;
            emit TokenTransfer(msg.sender, _recipient, _amount);
            }

//Check the amount of tokens each token holder holds
        function showTokens(address _owner) public view returns (uint256 balance) {
            return tokens[_owner];
        }
    }
