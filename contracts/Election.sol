//Declaramos la versión para que no se intente compilar con una versión más actualizada
pragma solidity ^0.4.24;

//Así se declara el contrato, de forma parecida a una clase 
contract Election {

    //Los structs se usan para definir estructuras de elementos
    //antes de poder guardarlo en la memoria tenemos que inicializar sus valores, así como un lugar donde poder almacenarlos.
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    //EVENTO:
    event votedEvent (uint indexed candidateId );
 
    //Los almacenamos en un mapping que tiene Key => Value
    // Por tener el caracter 'public' se crea un getter automaticamente para poder acceder al valor desde fuera de la blockchain
    //no hay forma aun de saber cual es el tamaño del mapping, por lo qye necesitamos algo que guarde y cuente el numero de candidatos
    mapping(uint => Candidate) public candidates;
    //cuenta y si ha votado o no
    mapping(address => bool) public voters;

    //para llevar la cuenta de los candidatos.
    uint public candidatesCount;
    
     /*El constructor solo es llamado una vez (la primera en la que se despliega el contrato) y sirve para inicializar las variables
    tiene el mismo nombre que el contrato*/
    constructor () public {
        addCandidate("Equipo 1");
        addCandidate("Equipo 2");
        addCandidate("Equipo 3");
    }
    //con esta función creo candidatos asociandoles el indice correcto segun cuando llegan a la lista
    //private porque solo queremos poder llamarla desde dentro del contrato
    function addCandidate (string _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    //publico, porque queremos que una cuenta externa le llame.
    function vote (uint _candidateId) public {
        //solo deja si no habian votado antes
        require(!voters[msg.sender]);
        
        //requiere que sea un candidato valido
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        //guarda que el votante que ha llamado al contrato ya ha votado
        voters[msg.sender] = true;

        //actualizamos la cuenta de votantes
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        votedEvent(_candidateId);
    }
}
   
     

