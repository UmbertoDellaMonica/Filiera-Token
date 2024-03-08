// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Filieratoken is ERC20 {

  // Nome del token
  string private constant _name = "FilieraToken";

  // Simbolo del token
  string private constant _symbol = "FLT";

  // Fornitura totale di token
  uint256 private constant _totalSupply = 1000000000; 

  constructor() ERC20(_name, _symbol) {
    // Assegna la fornitura totale al deployer
    _mint(address(this), _totalSupply);
  }

    /**
   * @dev Restituisce il numero di token Filiera posseduti dall'utente specificato.
   *
   * @param account L'indirizzo dell'utente di cui si desidera conoscere il saldo.
   *
   * @return Il saldo dell'utente in token Filiera.
   */
  function balanceOf(address account) public view override returns (uint256) {
      return super.balanceOf(account);
  }


    /**
   * @dev Trasferisce `amount` token Filiera dall'account del mittente all'account del destinatario.
   *
   * @param to L'indirizzo del destinatario dei token.
   * @param amount Il numero di token Filiera da trasferire.
   *
   * @return `true` se il trasferimento ha avuto successo, `false` in caso contrario.
   */
  function transfer(address to, uint256 amount) public override returns (bool) {
    super._transfer(address(this), to, amount);
    return true;
  }



  /**
   * @dev Brucia `balance` token Filiera dall'account dell'utente specificato.
   *
   * @param user L'indirizzo dell'utente i cui token devono essere bruciati.
   * @param balance Il numero di token Filiera da bruciare.
   *
   * @return `true` se il burn ha avuto successo, `false` in caso contrario.
   */
  function burnToken(address user, uint256 balance) public returns (bool) {
      super._burn(user, balance);
      return true;
  }


  /**
   * @dev Imposta `spender` come spender con una allowance di `amount` token Filiera.
   *
   * @param spender L'indirizzo dello spender che viene autorizzato.
   * @param amount L'ammontare massimo di token Filiera che lo spender può trasferire.
   *
   * @return `true` se l'approvazione ha avuto successo, `false` in caso contrario.
   */
  function approve(address spender, uint256 amount) public override returns (bool) {
      return super.approve(spender, amount);
  }

  /**
   * @dev Trasferisce `amount` token Filiera dall'account del mittente all'account del destinatario per l'acquisto di un prodotto.
   *
   * @param from L'indirizzo del mittente dei token.
   * @param to L'indirizzo del destinatario dei token.
   * @param amount Il numero di token Filiera da trasferire.
   *
   * @return `true` se il trasferimento ha avuto successo, `false` in caso contrario.
   */
  function transferTokenBuyProduct(address from, address to, uint256 amount) public returns (bool) {
      require(from != address(this) && to != address(this), "Transazione non valida per acquisto prodotto");
      super._transfer(from, to, amount);
      return true;
  }


  /**
   * @dev Assegna `amount` token Filiera all'account dell'utente specificato come incentivo alla registrazione.
   *
   * @param to L'indirizzo dell'utente che viene registrato.
   * @param amount Il numero di token Filiera da assegnare all'utente.
   *
   * @return `true` se la registrazione ha avuto successo, `false` in caso contrario.
   */
  function registerUserWithToken(address to, uint256 amount) public returns (bool) {
      require(msg.sender != address(this), "Solo il contratto FilieraToken puo' registrare utenti");
      super._transfer(address(this), to, amount);
      return true;
  }


}
