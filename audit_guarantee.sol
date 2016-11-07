pragma solidity ^0.4.2;

// one possible implementation of EIP 149
// https://github.com/ethereum/EIPs/issues/149
// by Simon Janin. Feel free to fork/pull-request/comment

contract audit_guarantee {
    
    struct auditer {
        string auditerName;
        uint depositAmount;
        uint depositStartBlock;
        uint depositEndBlock;
    }
    
    struct evaluation {
        bytes32 auditHash; // hash of the article (also corresponds to its IPFS address)
        uint auditNote; // 0<=x<=100
    }
    
    struct audits {
        string contractName;
        mapping (address => evaluation) evaluationsList;
    }
    
    mapping (address => audits) contractsList;
    mapping (address => auditer) auditersList;

    function add_auditor(string name, uint depositStartBlock, uint depositEndBlock) {
        // TODO: add bound checking
        
        auditersList[msg.sender].auditerName = name;
        auditersList[msg.sender].depositAmount = msg.value;
        auditersList[msg.sender].depositStartBlock = depositStartBlock;
        auditersList[msg.sender].depositEndBlock = depositEndBlock;
    }
    
    function add_contract(address contractAddress, string contractName) {
        // TODO: verify that the contract was indeed created by the caller <!>
        // http://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed
        // https://github.com/ethereum/wiki/wiki/RLP
        
        contractsList[contractAddress].contractName = contractName;
    }
    
    function add_audit(address contractAddress, bytes32 auditHash, uint auditNote) {
        // TODO: check the caller is in the auditersList and that he is still bounded
        if (auditersList[msg.sender].depositEndBlock != 0
            && auditersList[msg.sender].depositEndBlock <= block.number) {}
        else throw;
        
        contractsList[contractAddress].evaluationsList[msg.sender].auditHash = auditHash;
        contractsList[contractAddress].evaluationsList[msg.sender].auditNote = auditNote;
        
    }
    
    function get_auditNote() {}
    function get_auditHash() {}
}
