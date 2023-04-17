// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract propertyTransfer{
    address public DA;
    uint256 public totalNoOfProperty;

    constructor(){
        DA = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == DA);
        _;
    }

    struct Property{
        string name;
        bool isSold;
    }

    mapping(address=> mapping(uint256=>Property)) public propertiesOwner;
    mapping(address=>uint256) individualCountOfPropertyPerOwner;

    // Events for front end 
    event PropertyAlloted(address indexed _verifiedOwner, uint256 indexed _totalNoOfPropertyCurrently, string _nameOfProperty,
    string _msg);

    event PropertyTransferred(address indexed _from, address indexed _to , string _propertyName, string _msg);

    //Get property count of person using his/her address
    function GetPropertyCountOfAnyAddress(address _ownerAddress) public view returns(uint256){
        uint count = 0;
        for(uint i= 0; i<individualCountOfPropertyPerOwner[_ownerAddress];i++){
            if(propertiesOwner[_ownerAddress][i].isSold != true)
            count++;
        }
        return count;
    }

    //Allocate property to person
    function allocateProperty(address _verifiedOwner, string memory _propertyName) public onlyOwner{
        propertiesOwner[_verifiedOwner][individualCountOfPropertyPerOwner[_verifiedOwner]++].name = _propertyName;
        totalNoOfProperty++;
        emit
        PropertyAlloted(_verifiedOwner, individualCountOfPropertyPerOwner[_verifiedOwner], _propertyName, "property alloted successfully");
    }

    //Validate the owner of the property
    function isOwner(address _checkOwnerAddress, string memory _propertyName) public view returns(uint){
        uint i;
        bool flag;
        for(i=0; i<individualCountOfPropertyPerOwner[_checkOwnerAddress]; i++){
            if(propertiesOwner[_checkOwnerAddress][i].isSold == true){
                break;
            }
            flag = stringsEqual(propertiesOwner[_checkOwnerAddress][i].name, _propertyName);
            if(flag == true){
                break;
            }
        }
        if(flag == true){
            return i;
        }
        else{
            return 999999999;
        }
    }

    // String Equal function
    function stringsEqual(string memory a1, string memory a2) public pure returns(bool){
        return(keccak256(abi.encodePacked(a1)) == keccak256(abi.encodePacked(a2))? true:false);
    }

    // Transfer the property Ownership
    function transferProperty(address _to, string memory _propertyName) public returns(bool, uint){
        uint256 checkOwner = isOwner(msg.sender, _propertyName);
        bool flag;
        if(checkOwner != 999999999 && propertiesOwner[msg.sender][checkOwner].isSold == false){
            propertiesOwner[msg.sender][checkOwner].isSold = true;
            propertiesOwner[msg.sender][checkOwner].name = "Sold";
            propertiesOwner[_to][individualCountOfPropertyPerOwner[_to]++].name = _propertyName;
            flag = true;
            emit PropertyTransferred(msg.sender, _to, _propertyName, "Owner has been changed.");
        }
        else{
            flag = false;
            emit PropertyTransferred(msg.sender , _to, _propertyName, "Owner doesn't own the property. ");
        }
        return(flag, checkOwner);
    }
}