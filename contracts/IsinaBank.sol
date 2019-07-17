pragma solidity^0.5.0;

//import "https://github.com/provable-things/ethereum-api/blob/master/oraclizeAPI_0.5.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
import "contracts/provable/oraclize_api.sol";
import "contracts/open-zeppelin/contracts/ownership/Ownable.sol";
import "contracts/open-zeppelin/contracts/math/SafeMath.sol";
import "./IsinaToken.sol";

contract IsinaBank is usingOraclize, Ownable {
    using SafeMath for uint256;

    uint256 constant public TIME_AFTER_12_MONTHS = 1598918400; // 01.09.2020

    IsinaToken public token;

    struct Queries {
        address payable seller;
        uint256 tokens;
        uint256 time;
    }
    mapping(bytes32 => Queries) public queries;
    mapping(address => uint256) public tokens_for_sell;

    function () external payable {}

    function sell_tokens() external {
        require(tokens_for_sell[msg.sender] > 0);
        uint256 tokens = tokens_for_sell[msg.sender];
        tokens_for_sell[msg.sender] = 0;
        get_ethusd_price(msg.sender, tokens);
    }

    function set_token_address(address token_address) external onlyOwner {
        token = IsinaToken(token_address);
    }

    function send_ether(
        address payable recipient,
        uint256 tokens
    )
        public
        returns (bool)
    {
        require(msg.sender == address(token));
        get_ethusd_price(recipient, tokens);
        return true;
    }

    function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == oraclize_cbAddress());
        uint256 ethusd_price = string_to_uint(_result);
        uint256 eth_amount = get_eth_value(
            queries[_myid].tokens,
            ethusd_price,
            queries[_myid].time
        );
        if (eth_amount > 0 && address(this).balance >= eth_amount) {
            queries[_myid].seller.transfer(eth_amount);
        } else {
            tokens_for_sell[queries[_myid].seller] =
                tokens_for_sell[queries[_myid].seller].add(
                    queries[_myid].tokens
                );
        }
    }

    function get_ethusd_price
    (
        address payable recipient,
        uint256 tokens
    )
        private
        returns (bool)
    {
        require(address(this).balance > oraclize_getPrice("URL"));
        bytes32 query_id = oraclize_query(
            "URL",
            "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price"
        );
        queries[query_id].seller = recipient;
        queries[query_id].tokens = tokens;
        queries[query_id].time = block.timestamp;
    }

    function get_eth_value
    (
        uint256 tokens,
        uint256 ethusd_price,
        uint256 time
    )
        private
        pure
        returns (uint256 sell_eth_price)
    {
        uint256 usd_buy_amount = tokens.mul(3).div(10 ** 2);
        uint256 sell_usd_price;
        if (time < TIME_AFTER_12_MONTHS) {
            sell_usd_price = usd_buy_amount.div(2).add(usd_buy_amount);
        } else {
            sell_usd_price = usd_buy_amount.mul(2);
        }
        sell_eth_price = sell_usd_price.div(ethusd_price);
    }

    function string_to_uint
    (
        string memory s
    )
        private
        pure
        returns (uint256 result)
    {
        bytes memory b = bytes(s);
        uint256 i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            } else {
                break;
            }
        }
    }
}
