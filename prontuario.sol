pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;


contract Prontuario {
    
    address public creator;
    
    constructor () public {
        creator = msg.sender;
    }
    
    struct Exame {
        string nome;
        string resultado;
    }
    
    struct Paciente {
        address paciente;
        string nome;
        int idade;
        Exame[] exames;
        address[] acessos;
        mapping(address => bool) roles;
    }

    mapping(address => Paciente) private pacientesLista;

    function getQtdExame(address _paciente ) public view returns (uint) {
        uint _qtdexame;
        
        // Verifica se o usuario possui acesso ao paciente solicitado.
        if(isAssignedRole(_paciente, msg.sender)){
            _qtdexame = pacientesLista[_paciente].exames.length;   
        }else{//caso nao possua acesso é retornado somente a quantidade de exames do prorpio usuario
            _qtdexame = pacientesLista[msg.sender].exames.length;   
        }
        return _qtdexame;
    }
    
    //Somente o criador pode adicionar novos pacientes.
    function addPaciente(address _paciente, string memory _nome, int _idade) hasCreator() public {
        pacientesLista[_paciente].paciente = _paciente; 
        pacientesLista[_paciente].nome = _nome;
        pacientesLista[_paciente].idade = _idade;
    }

    function addExames(address _paciente, string memory _nome, string memory _resultado) public {
        Exame memory _exame;
        
        //Verifica se o usuario possui acesso ao paciente solicitado.
        if(isAssignedRole(_paciente, msg.sender)){
            _exame.nome = _nome;
            _exame.resultado = _resultado;
            pacientesLista[_paciente].exames.push(_exame);
        }
    }
    
    function getExames(address _paciente) public view returns (Exame[] memory) {
        Exame[] memory _exames;
        
        //Verifica se o usuario ossui acesso ao paciente solicitado.
        if(isAssignedRole(_paciente, msg.sender)){
            _exames = pacientesLista[_paciente].exames;  
        }else{//caso nao possua acesso é retornado somente os exames do prorpio usuario
            _exames = pacientesLista[msg.sender].exames;   
        }
        
        return _exames;
    }
    
    function getPaciente(address _paciente) public view returns (string memory _nome, int _idade) {
        Paciente memory __paciente;
        
        //Verifica se o usuario ossui acesso ao paciente solicitado.
        if(isAssignedRole(_paciente, msg.sender)){
            __paciente = pacientesLista[_paciente];  
        }else{//caso nao possua acesso é retornado somente os exames do prorpio usuario
            __paciente = pacientesLista[msg.sender];   
        }
        
        return (__paciente.nome, __paciente.idade);
    }
    
    //Somente o criador pode adicionar acesso ao paciente solicitado.
    function assignRole (address _paciente, address entity) hasCreator() public{
        pacientesLista[_paciente].roles[entity] = true;
    }

    //Somente o criador pode remover acesso ao paciente solicitado.
    function unassignRole (address _paciente, address entity) hasCreator() public{
        pacientesLista[_paciente].roles[entity] = false;
    }
    
    //Verificação se o usuario possui acesso ao paciente solicitado.
    function isAssignedRole (address _paciente, address entity) public view returns (bool){
        return pacientesLista[_paciente].roles[entity];
    }
    
    //Função para verificar se possui acesso.
    modifier hasRole (address _paciente) {
        if (!pacientesLista[_paciente].roles[msg.sender] && msg.sender != creator) {
            revert();
        }
        _;
    }
    
    //Função para verificar se é o criador.
    modifier hasCreator () {
        if (msg.sender != creator) {
            revert();
        }
        _;
    }

}