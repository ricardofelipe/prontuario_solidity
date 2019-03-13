pragma solidity >=0.5.1;
pragma experimental ABIEncoderV2;


contract Prontuario {
    
    address public system;
    
    constructor () public {
        system = msg.sender;
    }
    
    struct Exame {
        string nome;
        string resultado;
    }
    struct Paciente {
        address addr;
        string nome;
        Exame[] exames;
        address[] acessos;
    }

    mapping(address => Paciente) private pacientesLista;

    function getQtd(address _address )  public view returns (uint) {
        uint _qtdexame;
        
        if(msg.sender == system){
            _qtdexame = pacientesLista[_address].exames.length;   
        }else{
            _qtdexame = pacientesLista[msg.sender].exames.length;   
        }
        return _qtdexame;
    }
    
    function addPaciente(address _address, string memory _nome) public {
        if(msg.sender == system){
            pacientesLista[_address].addr     = _address; 
            pacientesLista[_address].nome     = _nome;
        }
    }

    function addExames(address _address, string memory _nome, string memory _resultado) public {
        Exame memory _exame;
        
        _exame.nome      = _nome;
        _exame.resultado = _resultado;
         
        if (msg.sender == system) {
            pacientesLista[_address].exames.push(_exame);
        }
    }
    
    function getExames(address _address) public view returns (Exame[] memory) {
        Exame[] memory _exames;
        
        if(msg.sender == system){
            _exames = pacientesLista[_address].exames;  
        }else{
            _exames = pacientesLista[msg.sender].exames;   
        }
        
        return _exames;
    }
    
    function addAcesso(address _address, address _acesso) public {
        if (msg.sender == system) {
            pacientesLista[_address].acessos.push(_acesso);
        }
    }
    
    function getAcesso(address _address) public view returns (address[] memory) {
        address[] memory _acesso;
        
        if(msg.sender == system){
            _acesso = pacientesLista[_address].acessos;  
        }else{
            _acesso = pacientesLista[msg.sender].acessos;   
        }
        
        return _acesso;
    }
    
}