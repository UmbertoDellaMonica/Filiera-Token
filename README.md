# FilieraToken
Il sistema proposto si concentra sulla gestione della filiera lattiero-casearia attraverso un'applicazione distribuita (DApp) basata su tecnologia blockchain. Gli attori coinvolti nella filiera sono il Centro di Raccolta e Trasformazione del Latte, il Produttore di Formaggio, il Retailer e il Consumatore.


# QBFT - Net 

    - [QBFT-Configuration] https://besu.hyperledger.org/stable/private-networks/tutorials/qbft

- 2 Modalità di configurazione : 
    - Smart contract Validator : Utilizziamo gli Smart Contract per effettuare le configurazioni sulla rete 
    - Header Validator : utilizziamo API di Besu per effettuare le configurazioni sulla rete besu 

1. Utilizziamo il comando di Besu API : 

```sh
besu operator generate-blockchain-config --config-file=qbftConfigFile.json --to=networkFiles --private-key-file-name=key
```
- Produciamo il file di genesis.json con la relativa networkFile/ con le chiavi del BootNode e degli altri nodi che vi sono all'interno dell'applicazione 

2. Start degli altri nodi con la stessa sequenza di comandi : 
- besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all"


- besu --data-path=data --genesis-file=../genesis.json --bootnodes=<Node-1 Enode URL> --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546


- besu --data-path=data --genesis-file=../genesis.json --bootnodes=<Node-1 Enode URL> --p2p-port=30305 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8547



- besu --data-path=data --genesis-file=../genesis.json --bootnodes=<Node-1 Enode URL> --p2p-port=30306 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8548 

3. Eseguire il bootnode e ti salvi nel file di .env l'url e poi esegui l'applicazione 

4. Una volta che abbiamo settato l'ID o l'url del nodo di Environment eseguiamo il docker-compose up -d per settare tutti i container della rete di Besu QBFT nella cartella di 

-> besu_private...docker/

```sh
docker-compose up -d 
```

5. Verificare la modalità di Utilizzo : 
 - Gateway 
 - Multiparty * 


6. Creare la cartella per il deploy dello smart contract : 
```sh
truffle init 
```

7. Prendiamo lo smart contract di Firefly.sol 

6. Compiliamo e deployamo il contratto e salvare il Contract Address 

7. Verificare la configurazione di Truffle nel file truffle-config.json 

```js
const PrivateKeyProvider = require("@truffle/hdwallet-provider");
const privateKey = "ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f";
const privateKeyProvider = new PrivateKeyProvider(
  privateKey,
  "http://localhost:8545",
);

module.exports = {
  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
    
    besuWallet: {
      provider: privateKeyProvider,
      network_id: "*",
      gasPrice: 0,
      gas: 4500000,
    },
  },
  mocha: {
    timeout: 100000
  },
  compilers: {
    solc: {
      version: "^0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
      evmVersion: "constantinople"
    }
  }
}

```



8. Inizializzo la rete di FireFly multiparty : 

```sh
 ff init ethereum filiera-token 4 --block-period 2 --blockchain-connector "evmconnect" --blockchain-node "remote-rpc" --chain-id 1337 --contract-address "0xb9A219631Aed55eBC3D998f17C3840B7eC39C0cc" --remote-node-url "http://host.docker.internal:8545" --org-name MilkHub_Org --node-name MilkHub_Node --org-name CheeseProducer_Org --node-name CheeseProducer_Name --org-name Retailer_Org --node-name Retailer_Node --org-name Consumer_Org --node-name Consumer_Node
```


9. Effettuare un PinBatch delle Organizzazioni e dei Nodi delle Organizzazioni 

- * Effettuare la chiamata per tutte le organizzazioni definite precedentemente 

```sh
 curl -X POST http://localhost:5000/api/v1/network/organizations/self   -H "Content-Type: application/json" -d '{"name":"MilkHub_Org","key":"019382"}'
```
```sh
 curl -X POST http://localhost:5000/api/v1/network/organizations/self   -H "Content-Type: application/json" -d '{"name":"CheeseProducer_Org","key":"019382"}'
```
```sh
 curl -X POST http://localhost:5000/api/v1/network/organizations/self   -H "Content-Type: application/json" -d '{"name":"Retailer_Org","key":"019382"}'
```
```sh
 curl -X POST http://localhost:5000/api/v1/network/organizations/self   -H "Content-Type: application/json" -d '{"name":"Consumer_Org","key":"019382"}'
```

- * Effettuare la chiamata per tutte i nodi delle Organizzazioni  definite precedentemente 


```sh
 curl -X POST http://localhost:5000/api/v1/network/nodes/self   -H "Content-Type: application/json" -d '{"name":"MilkHub_Node"}'
```
```sh
 curl -X POST http://localhost:5001/api/v1/network/nodes/self   -H "Content-Type: application/json" -d '{"name":"CheeseProducer_Node","key":"019382"}'
```
```sh
 curl -X POST http://localhost:5002/api/v1/network/nodes/self   -H "Content-Type: application/json" -d '{"name":"Retailer_Node","key":"019382"}'
```
```sh
 curl -X POST http://localhost:5003/api/v1/network/nodes/self   -H "Content-Type: application/json" -d '{"name":"Consumer_Node","key":"019382"}'
```


