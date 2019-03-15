pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;


contract Prontuario {
    address public criador;
    
    constructor () public {
        criador = msg.sender;
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

    // Todos podem consultar a quantidade de exames de um paciente.
    function getQtdExame(address _paciente) payable public returns (uint) {
        return pacientesLista[_paciente].exames.length;   
    }
    
    //Somente o criador pode adicionar novos pacientes.
    function addPaciente(address _paciente, string memory _nome, int _idade) eCriador() public {
        pacientesLista[_paciente].paciente = _paciente; 
        pacientesLista[_paciente].nome = _nome;
        pacientesLista[_paciente].idade = _idade;
    }

    //Somente medicos com acesso podem adicionar novos exames.
    function addExames(address _paciente, string memory _nome, string memory _resultado) temAcesso(_paciente) public {
        Exame memory _exame;

        _exame.nome = _nome;
        _exame.resultado = _resultado;
        pacientesLista[_paciente].exames.push(_exame);
    }
    
    //Somente o paciente ou medicos com acesso podem consultar exames.
    function getExames(address _paciente) TemAcessoOuPaciente(_paciente) public view returns (Exame[] memory) {
        return pacientesLista[_paciente].exames;  
    }
    
    //Somente o paciente ou medicos com acesso podem consultar as informaçoes pessoais.
    function getPaciente(address _paciente) TemAcessoOuPaciente(_paciente) public view returns (string memory _nome, int _idade) {
        Paciente memory __paciente;
        __paciente = pacientesLista[_paciente];  
        return (__paciente.nome, __paciente.idade);
    }
    
    //Somente o paciente pode adicionar um novo acesso.
    function addAcesso (address _paciente, address _medico) ePaciente(_paciente) public{
        pacientesLista[_paciente].roles[_medico] = true;
    }

    //Somente o paciente pode remover um acesso.
    function removeAcesso (address _paciente, address _medico) ePaciente(_paciente) public{
        pacientesLista[_paciente].roles[_medico] = false;
    }
    
    //Verifica se é o criador.
    modifier eCriador () {
        if (msg.sender != criador) {
            revert();
        }
        _;
    }

    //Verifica se possui acesso.
    modifier temAcesso (address _paciente) {
        if (!pacientesLista[_paciente].roles[msg.sender]) {
            revert();
        }
        _;
    }

    //Verificar se é o paciente.
    modifier ePaciente (address _paciente) {
        if ( msg.sender != _paciente) {
            revert();
        }
        _;
    }
    
    //Verifica se é o paciente ou se possui acesso.
    modifier TemAcessoOuPaciente (address _paciente) {
        if ( msg.sender != _paciente && !pacientesLista[_paciente].roles[msg.sender]) {
            revert();
        }
        _;
    }
}