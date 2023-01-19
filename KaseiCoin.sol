pragma solidity 0.5.5;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE

    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate,
        address payable  wallet,
        KaseiCoin token
    ) Crowdsale(rate, wallet, token) public{
    }
}



contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;


    // Add the constructor.
    constructor(
        uint rate,
        address payable  wallet,
        string memory name,
        string memory symbol,
        uint  initial_supply
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin keiserCoin = new KaseiCoin(name, symbol, initial_supply);

        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(keiserCoin);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kaseiCoinCrowdsale = new KaseiCoinCrowdsale(rate, wallet, keiserCoin);

        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseiCoinCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        keiserCoin.addMinter(kasei_crowdsale_address);

        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        keiserCoin.renounceMinter();
    }
}
