// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/openzeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Real is ERC20 {
    using SafeMath for uint;

    uint pid;
    address public propertyowner;
    string propertname;
    uint  amount;
    
    uint internal accumulated;

    address[] public tokenholders;

    mapping (address => uint256) public tokens;

    constructor (uint intialsupply, address _propertyowner, string memory _name ,string memory _token , uint _area)  ERC20(_name,_token) {
        _mint(msg.sender,intialsupply);
        tokens[_propertyowner] = _area; 
        propertyowner =_propertyowner;
        }

        event Addedtokenholder(address TokenholderAdded);
        event Removedtokenholder( address TokenholderRemoved);
        event TokenTransfer(address from, address to, uint256 tokens);
        
        function accept ()  external  payable  {
            accumulated += msg.value;
            }

//To add tokenholder

        function addtokenholder(address _tholder)  public   onlyowner {
            (bool _istholder, ) = istokenholder(_tholder);
            if (!_istholder) tokenholders.push(_tholder);
            emit Addedtokenholder(_tholder);
            }

//Check wether someone is token holder

        function istokenholder(address _address) public view returns(uint256) {      
            for (uint256 s = 0; s < tokenholders.length; s += 1){
                if (_address == tokenholders[s]) return (s);
            }
        return (0);
        }       


//Function to remove the token holder
        function removetholder(address _tholder) public  onlyowner {
            (bool _istokenholder, uint256 s) = _istokenholder(_tholder);
            if (_istokenholder){ tokenholders[s] = tokenholders[tokenholders.length - 1];
            tokenholders.pop();
            emit Removedtokenholder(_tholder);
            }

//Transfering of the tokens 
        function transfer(address _recipient, uint256 _amount) public  {      
            require(tokens[msg.sender] >= _amount);
            tokens[msg.sender] -= _amount;
            tokens[_recipient] += _amount;
            emit TokenTransfer(msg.sender, _recipient, _amount);
            }

//Check the amount of tokens each token holder holds
        function showTokens(address _owner) public view returns (uint256 balance) {
            return tokens[_owner];
        }
    }
