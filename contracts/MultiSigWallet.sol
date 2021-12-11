// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSigWallet
{
    address private _owner;
    mapping(address => uint8) private _owners;

    mapping (uint => Transaction) private _transactions;
    uint[] private _pendingTransactions;

    // auto incrememnting transaction ID
    uint private _transactionIndex;
    // constant: we need x amount of signatures to sign Transaction
    uint constant MIN_SIGNATURES = 2;

    struct Transaction
    {
        address source;
        address destination;
        uint value;
        //add how many people signed and who
        uint signatureCount;
        //need to keep record of who signed
        mapping (address => uint8) signatures;
    }

    modifier isOwner()
    {
        require(msg.sender == _owner);
        _;
    }

    modifier validOwner()
    {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }

    /// @dev logged events
    event DepositFunds(address source, uint amount);
    /// @dev full sequence of the transaction event logged
    event TransactionCreated(address source, address destination, uint value, uint transactionID);
    event TransactionCompleted(address source, address destination, uint value, uint transactionID);
    /// @dev keeps track of who is signing the transactions
    event TransactionSigned(address by, uint transactionID);


    /// @dev Contract constructor sets initial owners
    constructor()
    {
        _owner = msg.sender;
    }

    /// @dev add new owner to have access, enables the ability to create more than one owner to manage the wallet
    function addOwner(address newOwner)
    isOwner public
    {
        _owners[newOwner] = 1;
    }

    /// @dev remove suspicious owners
    function removeOwner(address existingOwner)
    isOwner public
    {
        _owners[existingOwner] = 0;
    }

    /// @dev Fallback function, which accepts ether when sent to contract
    receive() external payable {
        emit DepositFunds(msg.sender, msg.value);
    }

    function withdraw(uint _amount)
    public
    {
      require(address(this).balance >= _amount);
      //YOUR CODE HERE
      transferTo(msg.sender, _amount);
    }

    /// @dev Send ether to specific a transaction
    /// @param _destination Transaction target address.
    /// @param _value Transaction ether value.
    ///
    /// Start by creating your transaction. Since we defined it as a struct,
    /// we need to define it in a memory context. Update the member attributes.
    ///
    /// note, keep transactionID updated
    function transferTo(address _destination, uint _value)
    validOwner public
    {
      require(address(this).balance >= _value);
      //YOUR CODE HERE
      Transaction storage transaction = _transactions[_transactionIndex];
      //create the transaction
      //YOUR CODE HERE
      transaction.source = msg.sender;
      transaction.destination = _destination;
      transaction.value = _value;
      transaction.signatureCount = 0;
      transaction.signatures[msg.sender] = 0;
      //add transaction to the data structures
      //YOUR CODE HERE
//      _transactions[_transactionIndex] = transaction;
      _pendingTransactions.push(_transactionIndex);
      //log that the transaction was created to a specific address
      //YOUR CODE HERE
      emit TransactionCreated(msg.sender, _destination, _value, _transactionIndex);
      _transactionIndex++;
    }

    //returns pending transcations
    function getPendingTransactions()
    view validOwner public
    returns (uint[] memory)
    {
      return _pendingTransactions;
    }

    /// @dev Allows an owner to confirm a transaction.
    /// @param _transactionID Transaction ID.
    /// Sign and Execute transaction.
    function signTransaction(uint _transactionID) validOwner public {
      //Use Transaction Structure. Above in TransferTo function, because
      //we created the structure, we had to specify the keyword memory.
      //Now, we are pulling in the structure from a storage mechanism
      //Basically, 'storage' will stop the EVM from duplicating the actual
      //object, and instead will reference it directly.

      //Create variable transaction using storage (which creates a reference point)
      //YOUR CODE HERE
      Transaction storage transaction = _transactions[_transactionID];
      
      // Transaction must exist, note: use require(), but can't do require(transaction), .
      //YOUR CODE HERE
      require(transaction.source != address(0x0));
      
      // Creator cannot sign the transaction, use require()
      //YOUR CODE HERE
      require(transaction.source != msg.sender);
      
      // Cannot sign a transaction more than once, use require()
      //YOUR CODE HERE
      require(transaction.signatures[msg.sender] == 0);
      
      // assign the transaction = 1, so that when the function is called again it will fail
      //YOUR CODE HERE
      transaction.signatures[msg.sender] = 1;
      
      // increment signatureCount
      //YOUR CODE HERE
      transaction.signatureCount++;
      
      // log transaction
      //YOUR CODE HERE
      emit TransactionSigned(msg.sender, _transactionID);
      
      //  check to see if transaction has enough signatures so that it can actually be completed
      // if true, make the transaction. Don't forget to log the transaction was completed.
      if (transaction.signatureCount >= MIN_SIGNATURES)
      {
        require(address(this).balance >= transaction.value); //validate transaction
        //YOUR CODE HERE
        payable(transaction.source).transfer(transaction.value);
        //log that the transaction was complete
        //YOUR CODE HERE
        emit TransactionCompleted(transaction.source, transaction.destination,
         transaction.value, _transactionID);
        //end with a call to deleteTransaction
        deleteTransaction(_transactionID);
      }
    }

    /// @dev clean up function
    function deleteTransaction(uint transactionId) validOwner public {
      uint8 replace = 0;
      for(uint i = 0; i < _pendingTransactions.length; i++) {
        if (1 == replace) {
          _pendingTransactions[i-1] = _pendingTransactions[i];
        } else if (transactionId == _pendingTransactions[i]) {
          replace = 1;
        }
      }
      delete _pendingTransactions[_pendingTransactions.length - 1];
//      _pendingTransactions.length--;
      delete _transactions[transactionId];
    }

    /// @return Returns balance
    function walletBalance() view public returns (uint) {
      //YOUR CODE HERE
      return address(this).balance;
    }

 }
