// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract propertyTransferApp is ERC721{

    constructor() ERC721 ("Property", "PRP"){}
    address public contractOwner;
    struct property{
        uint256 id;
        string name;
        address owner;
        uint256 value;
        uint256 area;
    }

    mapping(uint256 => property) public properties;
    function addProperty(
        uint256 _id, string memory _name, uint256 _value, uint256 _area) public {
            properties[_id].name = _name;
            properties[_id].owner = msg.sender;
            properties[_id].value = _value;
            properties[_id].area = _area;
            _mint(msg.sender, _id); //creation of new unique NFT
        }
    //function 2 to read the data
    function queryPropertyById(uint256 _id) public view returns(string memory name, address owner, uint256 area,
    uint256 value){
        return (properties[_id].name, 
        ownerOf(_id), 
        properties[_id].value, 
        properties[_id].area);
    }

    //function 3 updating the data
    function transferPropertyByOwner(uint256 _id, address _newOwner) public {

        require(msg.sender == ownerOf(_id));
        transferFrom(msg.sender, _newOwner, _id);
        //properties[_id].owner = _newOwner;
    }

}