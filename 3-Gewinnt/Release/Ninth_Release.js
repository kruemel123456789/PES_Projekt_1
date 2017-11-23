var browser_ballot_sol_gameContract = web3.eth.contract([{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"hash","type":"bytes32"}],"name":"join_game","outputs":[{"name":"s","type":"string"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"tipNumber","type":"uint256"},{"name":"passphrase","type":"string"}],"name":"unlockTips","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"checkTime","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"number","type":"uint256"},{"name":"passphrase","type":"string"}],"name":"greateHash","outputs":[{"name":"hash","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"player","type":"address"}],"name":"join_success","type":"event"},{"anonymous":false,"inputs":[],"name":"pleaseUnlock","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"player","type":"address"}],"name":"Unlock_success","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"win","type":"uint256"}],"name":"winTheGame","type":"event"}]);
var browser_ballot_sol_game = browser_ballot_sol_gameContract.new(
   {
     from: web3.eth.accounts[0],
     data: '0x606060405260018055600060025560006003556000601255336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550610d27806100666000396000f30060606040526004361061006d576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806341c0e1b51461007257806343feb55b14610087578063515413721461011c578063e0c6190d14610177578063e744ef111461018c575b600080fd5b341561007d57600080fd5b61008561020e565b005b6100a16004808035600019169060200190919050506102a2565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100e15780820151818401526020810190506100c6565b50505050905090810190601f16801561010e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b610175600480803590602001909190803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509190505061062f565b005b341561018257600080fd5b61018a610831565b005b341561019757600080fd5b6101f0600480803590602001909190803590602001908201803590602001908080601f01602080910402602001604051908101604052809392919081815260200183838082843782019150505050505091905050610930565b60405180826000191660001916815260200191505060405180910390f35b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561029d576000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b600080fd5b6102aa610ca8565b6000806064915060008014156102be573491505b600090505b60015481111515610395573373ffffffffffffffffffffffffffffffffffffffff166004826003811015156102f457fe5b0160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141561038857600080141561034057600080fd5b600160001415610387576040805190810160405280601881526020017f537069656c6572207363686f6e20766f7268616e64656e2100000000000000008152509250610628565b5b80806001019150506102c3565b6002546001541080156103af5750670de0b6b3a764000082105b156104355760016000141561042257606060405190810160405280602581526020017f5a752077656e696720537069656c657220756e64207a752077656e696720456981526020017f6e7361747a0000000000000000000000000000000000000000000000000000008152509250610628565b600080141561043057600080fd5b610503565b670de0b6b3a764000082101561049f5760016000141561048c576040805190810160405280601881526020017f5a752077656e69672045696e7361747a2067657a61686c7400000000000000008152509250610628565b600080141561049a57600080fd5b610502565b6002546001541015610501576001600014156104f2576040805190810160405280601081526020017f5a75207669656c6520537069656c6572000000000000000000000000000000008152509250610628565b600080141561050057600080fd5b5b5b5b33600460025460038110151561051557fe5b0160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555083600a60025460038110151561056657fe5b018160001916905550610578826109e8565b7f01fea2c837fb44a6dd1c8b7efba4f15b2eaaed3e1a8afe2bcfb6e580b2354f6f33604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390a1600254600154141561061b577feec7004152ce130fb507d95f099898b0a937c847c3c3bf9025202373fe7e033360405160405180910390a1426013819055505b6001600254016002819055505b5050919050565b600080600254600154111561064d57600080141561064c57600080fd5b5b60639150600090505b600154811115156106d6573373ffffffffffffffffffffffffffffffffffffffff1660048260038110151561068757fe5b0160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614156106c9578091505b8080600101915050610656565b60638214156106ee5760008014156106ed57600080fd5b5b81600d60006003811015156106ff57fe5b015414158061071f575081600d600160038110151561071a57fe5b015414155b8061073b575081600d600260038110151561073657fe5b015414155b156108045761075b8484600a8560038110151561075457fe5b0154610a05565b60078360038110151561076a57fe5b0181905550600160036000828254019250508190555081600d60035460038110151561079257fe5b01819055506107a082610ae7565b7f4ea96a7addf2536681ae50cffa761ec2703e7617cf3bd259c0f0c8af5926c12633604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390a15b6001805401600354141561082b5761081a610b62565b610822610bb5565b61082a610c64565b5b50505050565b60008060018054016003541015610927574260b460135401141561091d57600254600354600154036706f05b59d3b20000026012540181151561087057fe5b049150600090505b60035481111515610910576004600d8260038110151561089457fe5b01546003811015156108a257fe5b0160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc839081150290604051600060405180830381858888f19350505050151561090357600080fd5b8080600101915050610878565b610918610c64565b610922565b600080fd5b61092c565b600080fd5b5050565b60008282336040518084815260200183805190602001908083835b602083101515610970578051825260208201915060208101905060208303925061094b565b6001836020036101000a0380198251168184511680821785525050505050509050018273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166c0100000000000000000000000002815260140193505050506040518091039020905092915050565b6706f05b59d3b20000810360126000828254019250508190555050565b6000808484336040518084815260200183805190602001908083835b602083101515610a465780518252602082019150602081019050602083039250610a21565b6001836020036101000a0380198251168184511680821785525050505050509050018273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166c01000000000000000000000000028152601401935050505060405180910390209050826000191681600019161415610ad057849150610adf565b6000801415610ade57600080fd5b5b509392505050565b600481600381101515610af657fe5b0160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6706f05b59d3b200009081150290604051600060405180830381858888f193505050501515610b5f57600080fd5b50565b60008060009150600090505b60015481111515610b9b57600781600381101515610b8857fe5b0154820191508080600101915050610b6e565b600180540182811515610baa57fe5b066010819055505050565b6004601054600381101515610bc657fe5b0160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6012549081150290604051600060405180830381858888f193505050501515610c2957600080fd5b7f90dc51cdd2730e06e02acd62182516732887db45681c48903f82e595f3e77fa66010546040518082815260200191505060405180910390a1565b6000600281905550600060038190555060046000610c829190610cbc565b60076000610c909190610cd1565b600a6000610c9e9190610ce6565b6000601281905550565b602060405190810160405280600081525090565b50600081556001016000815560010160009055565b50600081556001016000815560010160009055565b506000815560010160008155600101600090555600a165627a7a723058202fd4996fe0a2c98169c0033634decd8983125761f76a03b573e5ab435344c8820029',
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
    var spiel = browser_ballot_sol_gameContract.at(contract.address);

    var event_join_success = spiel.join_success();
    event_join_success.watch(function(error, result){
            if(!error){
                console.log('Erfolgreiche Anmeldung'  + '( Spieler Adresse: ' + result.args.player + ' )' );
            }
            else{
                console.log(error);
            }

        });

    var event_pleaseUnlock = spiel.pleaseUnlock()
    event_pleaseUnlock.watch(function(error, result){
            if(!error){
                console.log('Unlock bitte jetzt!');
            }
            else{
                console.log(error);
            }

        });

    var event_Unlock_success = spiel.Unlock_success()
    event_Unlock_success.watch(function(error, result){
            if(!error){
                console.log('Unlock war erfolgreich.'   + '( Spieler Adresse: ' + result.args.player + ' )' );
            }
            else{
                console.log('Unlock war nicht erfolgreich');
            }

        });

    var event_winTheGame = spiel.winTheGame()
    event_winTheGame.watch(function(error, result){
            if(!error){
                console.log('Spieler ' + result.args.win +' hat gewonnen.');
            }
            else{
                console.log('Fehler !');
            }

        });

 })
