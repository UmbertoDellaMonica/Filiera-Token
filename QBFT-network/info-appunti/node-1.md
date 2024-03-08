### Commad to Activate the first node 
```sh
besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all"
```

* Per verificare l'url del nodo dobbiamo vedere effettivamente l'attributo di : 
- Enode URL :enode://b15ae155fe4a2836ec9bc4cdd2038fb53482c0fb7ef4eb39c7049897480408960ed26d073fd253838b91f73d94820bebbc740db8d7f8a8075b970b87a831cbdb@127.0.0.1:30303

**NB** : Il enode URL viene visualizzato dopo il peer discovery  
