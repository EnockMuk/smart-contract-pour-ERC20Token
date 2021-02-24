pragma solidity ^0.7.0;


library calculator {
    
    function add(uint i, uint j)pure internal returns(uint){
        uint k=(i+j);
        require(k>i,"k doit etre superieur a i");
        return k;
    }
    
    function sous(uint a, uint b) pure internal returns(uint){
        
        uint c= a-b;
        require(a>b,"a doit etre superieur a b");
        return c;
    }
}
contract MyToken {
    using calculator for uint;
    
    string public nom; //"ENOCK"
    string public symbol; // "ENCK" total bitcoin: 210000000
    uint internal decimals;
    uint256 public totalSupply; // total supply: 1000000
    
    mapping(address=>uint)public balanceOf;
    
    mapping(address=>mapping(address=>uint))internal autorization;
    
    event Transfer(address indexed expeditaire, address indexed beneficiaire,uint montant);
    
    event Approval(address indexed proprietaire,address indexed revendeur, uint montant);
    
    constructor(string memory _nom,string memory _symbol,uint _decimal, uint _totalSupply){
        nom=_nom;
        symbol=_symbol;
        decimals=_decimal;
        totalSupply=_totalSupply;
        balanceOf[msg.sender]=totalSupply;
    }
    
    
    function transfer(address _beneficiaire, uint _montant)public returns(bool success){
        require(balanceOf[msg.sender]>=_montant,"tu n'as assez de fond");
        balanceOf[msg.sender]=balanceOf[msg.sender].sous(_montant);
        balanceOf[_beneficiaire]=balanceOf[_beneficiaire].add(_montant);
        emit Transfer(msg.sender,_beneficiaire,_montant);
        return true;
        
    }
    
    function approve(address _revendeur,uint montant) public returns(bool succes){
        
        autorization[msg.sender][_revendeur]=montant;
        emit Approval(msg.sender,_revendeur,montant);
        return true;
        
    }
    
    function autorise(address _proprietaire, address _revendeur)public view returns(uint remaining){
        return autorization[_proprietaire][_revendeur];
    }
    
    function transferFrom(address _proprietaire, address beneficiaire,uint _montant)public returns(bool success){
        require(balanceOf[_proprietaire]>=_montant,"on a pas assez de token pour te servir");
        require(autorization[_proprietaire][msg.sender]>=_montant,"pas autorise");
        balanceOf[_proprietaire]=balanceOf[_proprietaire].sous(_montant);
        balanceOf[beneficiaire]= balanceOf[beneficiaire].add(_montant);
        autorization[_proprietaire][msg.sender]=autorization[_proprietaire][msg.sender].sous(_montant);
        emit Transfer(_proprietaire,beneficiaire,_montant);
        return true;
        
    }
    
}