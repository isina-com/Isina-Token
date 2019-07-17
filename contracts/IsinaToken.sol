pragma solidity^0.5.0;

// import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Detailed.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol";
import "contracts/open-zeppelin/contracts/token/ERC20/ERC20.sol";
import "contracts/open-zeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "contracts/open-zeppelin/contracts/ownership/Ownable.sol";
import "./IsinaBank.sol";

contract IsinaToken is ERC20, ERC20Detailed, Ownable {
    using SafeMath for uint256;

    uint256 constant public UNLOCK_TIME = 1583020800; // 01.03.2020
    uint256 constant public STOP_ALL_LOCKS_TIME = 1764547200; // 01.12.2025
    uint256 constant public STOP_SELL_TIME = 1646092800; // 01.03.2023

    uint256 public team_tokens;
    uint256 public marketing_tokens;
    uint256 public reserve_tokens;
    uint256 public seed_tokens;
    uint256 public private_tokens;
    uint256 public launchpad_tokens;

    address public tokens_holder;
    address public team;
    address public marketing;
    address public reserve;

    IsinaBank public bank;

    mapping(address => uint256) public seed_balance;
    mapping(address => uint256) public private_balance;
    mapping(address => uint256) public seed_bonus;
    mapping(address => uint256) public private_bonus;
    mapping(address => bool) public seed_locked;
    mapping(address => bool) public private_locked;
    mapping(address => uint256) public tokens_for_sell;

    modifier only_tokens_holder() {
        require(
            msg.sender == tokens_holder,
            "Sender must be a tokens holder"
        );
        _;
    }

    modifier after_unlock_time() {
        require(
            block.timestamp >= UNLOCK_TIME,
            "The time must be longer than the unlock time"
        );
        _;
    }

    modifier before_stop_sell_time() {
        require(
            block.timestamp < STOP_SELL_TIME,
            "The time must be less than the stop sell time"
        );
        _;
    }

    constructor(
        address _tokens_holder,
        address _team,
        address _marketing,
        address _reserve
    )
        public
        ERC20Detailed("Isina Token", "ISN", 18)
    {
        tokens_holder = _tokens_holder;
        seed_tokens = 102203100 * (10 ** uint256(decimals()));
        private_tokens = 163524960 * (10 ** uint256(decimals()));
        launchpad_tokens = 81762480 * (10 ** uint256(decimals()));
        _mint(tokens_holder, seed_tokens + private_tokens + launchpad_tokens);
        team = _team;
        team_tokens = 28616868 * (10 ** uint256(decimals()));
        _mint(team, team_tokens);
        marketing = _marketing;
        marketing_tokens = 4088124 * (10 ** uint256(decimals()));
        _mint(marketing, marketing_tokens);
        reserve = _reserve;
        reserve_tokens = 28616868 * (10 ** uint256(decimals()));
        _mint(reserve, reserve_tokens);
    }

    function transfer_from_bank(
        address recipient,
        uint256 amount
    )
        external
        onlyOwner
    {
        super._transfer(address(bank), recipient, amount);
    }

    function unlock_seed()
        external
        after_unlock_time
        before_stop_sell_time
    {
        require(
            seed_locked[msg.sender],
            "Tokens must be unlocked"
        );
        seed_locked[msg.sender] = false;
        tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
            seed_balance[msg.sender].sub(
                get_available_seed_balance(msg.sender)
            )
        );
        seed_balance[msg.sender] = 0;
        tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
            seed_bonus[msg.sender].sub(
                get_available_seed_bonus(msg.sender)
            )
        );
        seed_bonus[msg.sender] = 0;
    }

    function unlock_private()
        external
        after_unlock_time
        before_stop_sell_time
    {
        require(
            private_locked[msg.sender],
            "Tokens must be unlocked"
        );
        private_locked[msg.sender] = false;
        tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
            private_balance[msg.sender].sub(
                get_available_private_balance(msg.sender)
            )
        );
        private_balance[msg.sender] = 0;
        tokens_for_sell[msg.sender] = tokens_for_sell[msg.sender].add(
            private_bonus[msg.sender].sub(
                get_available_private_bonus(msg.sender)
            )
        );
        private_bonus[msg.sender] = 0;
    }

    function burn_seed_tokens() external only_tokens_holder {
        _burn(tokens_holder, seed_tokens);
        seed_tokens = 0;
    }

    function burn_private_tokens() external only_tokens_holder {
        _burn(tokens_holder, private_tokens);
        private_tokens = 0;
    }

    function burn_launchpad_tokens() external only_tokens_holder {
        _burn(tokens_holder, launchpad_tokens);
        launchpad_tokens = 0;
    }

    function set_bank(address payable bank_address) external onlyOwner {
        bank = IsinaBank(bank_address);
    }

    function transfer(
        address recipient,
        uint256 amount
    )
        public
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    )
        public
        returns (bool)
    {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            allowance(sender, msg.sender).sub(amount)
        );
        return true;
    }

    function send_seed_tokens(
        address recipient,
        uint256 amount
    )
        public
        only_tokens_holder
        returns (bool)
    {
        require(
            seed_tokens > 0,
            "Tokens are over or sale is ended"
        );
        seed_balance[recipient] = seed_balance[recipient].add(amount);
        uint256 bonus_amount = amount.mul(1496).div(10000);
        seed_bonus[recipient] = seed_bonus[recipient].add(bonus_amount);
        seed_locked[recipient] = true;
        seed_tokens = seed_tokens.sub(amount).sub(bonus_amount);
        return super.transfer(recipient, amount.add(bonus_amount));
    }

    function send_private_tokens(
        address recipient,
        uint256 amount
    )
        public
        only_tokens_holder
        returns (bool)
    {
        require(
            private_tokens > 0,
            "Tokens are over or sale is ended"
        );
        private_balance[recipient] = private_balance[recipient].add(amount);
        uint256 bonus_amount = amount.mul(99).div(1000);
        private_bonus[recipient] = private_bonus[recipient].add(bonus_amount);
        private_locked[recipient] = true;
        private_tokens = private_tokens.sub(amount).sub(bonus_amount);
        return super.transfer(recipient, amount.add(bonus_amount));
    }

    function send_launchpad_tokens(
        address recipient,
        uint256 amount
    )
        public
        only_tokens_holder
        returns (bool)
    {
        require(
            launchpad_tokens > 0,
            "Tokens are over or sale is ended"
        );
        launchpad_tokens = launchpad_tokens.sub(amount);
        return super.transfer(recipient, amount);
    }

    function get_available_balance(
        address sender
    )
        public
        view
        returns (uint256)
    {
        uint256 available_balance = balanceOf(sender);
        if (sender == team) {
            available_balance = available_balance.sub(
                team_tokens.sub(
                    get_available_team_balance()
                )
            );
        }
        if (sender == marketing) {
            available_balance = available_balance.sub(
                marketing_tokens.sub(
                    get_available_marketing_balance()
                )
            );
        }
        if (sender == reserve) {
            available_balance = available_balance.sub(
                    reserve_tokens.sub(
                        get_available_reserve_balance()
                    )
            );
        }
        if (seed_locked[sender]) {
            available_balance = available_balance.sub(
                seed_balance[sender].sub(
                    get_available_seed_balance(sender)
                )
            );
            available_balance = available_balance.sub(
                seed_bonus[sender].sub(
                    get_available_seed_bonus(sender)
                )
            );
        }
        if (private_locked[sender]) {
            available_balance = available_balance.sub(
                private_balance[sender].sub(
                    get_available_private_balance(sender)
                )
            );
            available_balance = available_balance.sub(
                private_bonus[sender].sub(
                    get_available_private_bonus(sender)
                )
            );
        }
        available_balance = available_balance.sub(tokens_for_sell[sender]);
        return (available_balance);
    }

    function get_available_team_balance()
        public
        view
        returns (uint256)
    {
        if (block.timestamp < 1590969600) { // 01.06.2020
            return 0;
        } else if (block.timestamp < 1614556800) { // 01.03.2021
            return team_tokens.mul(10).div(100);
        } else if (block.timestamp < 1646092800) { // 01.03.2022
            return team_tokens.mul(20).div(100);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return team_tokens.mul(30).div(100);
        } else if (block.timestamp < 1677628800) { // 01.03.2023
            return team_tokens.mul(35).div(100);
        } else if (block.timestamp < 1690848000) { // 01.08.2023
            return team_tokens.mul(40).div(100);
        } else if (block.timestamp < 1706745600) { // 01.02.2024
            return team_tokens.mul(45).div(100);
        } else if (block.timestamp < 1711929600) { // 01.04.2024
            return team_tokens.mul(50).div(100);
        } else if (block.timestamp < 1722470400) { // 01.08.2024
            return team_tokens.mul(55).div(100);
        } else if (block.timestamp < 1727740800) { // 01.10.2024
            return team_tokens.mul(60).div(100);
        } else if (block.timestamp < 1733011200) { // 01.12.2024
            return team_tokens.mul(65).div(100);
        } else if (block.timestamp < 1740787200) { // 01.03.2025
            return team_tokens.mul(70).div(100);
        } else if (block.timestamp < 1751328000) { // 01.07.2025
            return team_tokens.mul(80).div(100);
        } else if (block.timestamp < 1764547200) { // 01.12.2025
            return team_tokens.mul(90).div(100);
        } else {
            return team_tokens;
        }
    }

    function get_available_marketing_balance()
        public
        view
        returns (uint256)
    {
        if (block.timestamp < 1588291200) { // 01.05.2020
            return 0;
        } else if (block.timestamp < 1614556800) { // 01.03.2021
            return marketing_tokens.mul(10).div(100);
        } else if (block.timestamp < 1648771200) { // 01.04.2022
            return marketing_tokens.mul(20).div(100);
        } else if (block.timestamp < 1656633600) { // 01.07.2022
            return marketing_tokens.mul(30).div(100);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return marketing_tokens.mul(35).div(100);
        } else if (block.timestamp < 1682899200) { // 01.05.2023
            return marketing_tokens.mul(40).div(100);
        } else if (block.timestamp < 1690848000) { // 01.08.2023
            return marketing_tokens.mul(50).div(100);
        } else if (block.timestamp < 1711929600) { // 01.04.2024
            return marketing_tokens.mul(55).div(100);
        } else if (block.timestamp < 1722470400) { // 01.08.2024
            return marketing_tokens.mul(60).div(100);
        } else if (block.timestamp < 1733011200) { // 01.12.2024
            return marketing_tokens.mul(65).div(100);
        } else if (block.timestamp < 1743465600) { // 01.04.2025
            return marketing_tokens.mul(70).div(100);
        } else if (block.timestamp < 1754006400) { // 01.08.2025
            return marketing_tokens.mul(80).div(100);
        } else if (block.timestamp < 1764547200) { // 01.12.2025
            return marketing_tokens.mul(90).div(100);
        } else {
            return marketing_tokens;
        }
    }

    function get_available_reserve_balance()
        public
        view
        returns (uint256)
    {
        if (block.timestamp < 1598918400) { // 01.09.2020
            return 0;
        } else if (block.timestamp < 1619827200) { // 01.05.2021
            return reserve_tokens.mul(10).div(100);
        } else if (block.timestamp < 1630454400) { // 01.09.2021
            return reserve_tokens.mul(15).div(100);
        } else if (block.timestamp < 1654041600) { // 01.06.2022
            return reserve_tokens.mul(20).div(100);
        } else if (block.timestamp < 1664582400) { // 01.10.2022
            return reserve_tokens.mul(25).div(100);
        } else if (block.timestamp < 1682899200) { // 01.05.2023
            return reserve_tokens.mul(30).div(100);
        } else if (block.timestamp < 1690848000) { // 01.08.2023
            return reserve_tokens.mul(40).div(100);
        } else if (block.timestamp < 1714521600) { // 01.05.2024
            return reserve_tokens.mul(45).div(100);
        } else if (block.timestamp < 1719792000) { // 01.07.2024
            return reserve_tokens.mul(55).div(100);
        } else if (block.timestamp < 1727740800) { // 01.10.2024
            return reserve_tokens.mul(60).div(100);
        } else if (block.timestamp < 1733011200) { // 01.12.2024
            return reserve_tokens.mul(65).div(100);
        } else if (block.timestamp < 1746057600) { // 01.05.2025
            return reserve_tokens.mul(70).div(100);
        } else if (block.timestamp < 1756684800) { // 01.09.2025
            return reserve_tokens.mul(80).div(100);
        } else if (block.timestamp < 1764547200) { // 01.12.2025
            return reserve_tokens.mul(90).div(100);
        } else {
            return reserve_tokens;
        }
    }

    function get_available_seed_balance(
        address sender
    )
        public
        view
        returns (uint256)
    {
        if (block.timestamp < 1575158400) { // 01.12.2019
            return 0;
        } else if (block.timestamp < 1583020800) { // 01.03.2020
            return seed_balance[sender].mul(20).div(100);
        } else if (block.timestamp < 1593561600) { // 01.07.2020
            return seed_balance[sender].mul(25).div(100);
        } else if (block.timestamp < 1606780800) { // 01.12.2020
            return seed_balance[sender].mul(30).div(100);
        } else if (block.timestamp < 1617235200) { // 01.04.2021
            return seed_balance[sender].mul(35).div(100);
        } else if (block.timestamp < 1625097600) { // 01.07.2021
            return seed_balance[sender].mul(40).div(100);
        } else if (block.timestamp < 1633046400) { // 01.10.2021
            return seed_balance[sender].mul(45).div(100);
        } else if (block.timestamp < 1638316800) { // 01.12.2021
            return seed_balance[sender].mul(50).div(100);
        } else if (block.timestamp < 1646092800) { // 01.03.2022
            return seed_balance[sender].mul(55).div(100);
        } else if (block.timestamp < 1654041600) { // 01.06.2022
            return seed_balance[sender].mul(60).div(100);
        } else if (block.timestamp < 1661990400) { // 01.09.2022
            return seed_balance[sender].mul(65).div(100);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return seed_balance[sender].mul(70).div(100);
        } else if (block.timestamp < 1677628800) { // 01.03.2023
            return seed_balance[sender].mul(75).div(100);
        } else if (block.timestamp < 1682899200) { // 01.05.2023
            return seed_balance[sender].mul(80).div(100);
        } else if (block.timestamp < 1688169600) { // 01.07.2023
            return seed_balance[sender].mul(85).div(100);
        } else if (block.timestamp < 1696118400) { // 01.10.2023
            return seed_balance[sender].mul(90).div(100);
        } else if (block.timestamp < 1701388800) { // 01.12.2023
            return seed_balance[sender].mul(95).div(100);
        } else {
            return seed_balance[sender];
        }
    }

    function get_available_private_balance(
        address sender
    )
        public
        view
        returns (uint256)
    {
        if (block.timestamp < 1575158400) { // 01.12.2019
            return 0;
        } else if (block.timestamp < 1580515200) { // 01.02.2020
            return private_balance[sender].mul(15).div(100);
        } else if (block.timestamp < 1588291200) { // 01.05.2020
            return private_balance[sender].mul(20).div(100);
        } else if (block.timestamp < 1606780800) { // 01.12.2020
            return private_balance[sender].mul(25).div(100);
        } else if (block.timestamp < 1617235200) { // 01.04.2021
            return private_balance[sender].mul(30).div(100);
        } else if (block.timestamp < 1619827200) { // 01.05.2021
            return private_balance[sender].mul(35).div(100);
        } else if (block.timestamp < 1627776000) { // 01.08.2021
            return private_balance[sender].mul(40).div(100);
        } else if (block.timestamp < 1638316800) { // 01.12.2021
            return private_balance[sender].mul(45).div(100);
        } else if (block.timestamp < 1646092800) { // 01.03.2022
            return private_balance[sender].mul(50).div(100);
        } else if (block.timestamp < 1656633600) { // 01.07.2022
            return private_balance[sender].mul(55).div(100);
        } else if (block.timestamp < 1664582400) { // 01.10.2022
            return private_balance[sender].mul(60).div(100);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return private_balance[sender].mul(65).div(100);
        } else if (block.timestamp < 1680307200) { // 01.04.2023
            return private_balance[sender].mul(70).div(100);
        } else if (block.timestamp < 1688169600) { // 01.07.2023
            return private_balance[sender].mul(75).div(100);
        } else if (block.timestamp < 1696118400) { // 01.10.2023
            return private_balance[sender].mul(80).div(100);
        } else if (block.timestamp < 1701388800) { // 01.12.2023
            return private_balance[sender].mul(85).div(100);
        } else if (block.timestamp < 1709251200) { // 01.03.2024
            return private_balance[sender].mul(90).div(100);
        } else if (block.timestamp < 1719792000) { // 01.07.2024
            return private_balance[sender].mul(95).div(100);
        } else {
            return private_balance[sender];
        }
    }

    function get_available_seed_bonus(
        address sender
    )
        public
        view
        returns (uint256)
    {
        uint256 available_bonus = seed_bonus[sender].div(17);
        if (block.timestamp < 1575158400) { // 01.12.2019
            return 0;
        } else if (block.timestamp < 1583020800) { // 01.03.2020
            return available_bonus;
        } else if (block.timestamp < 1593561600) { // 01.07.2020
            return available_bonus.mul(2);
        } else if (block.timestamp < 1606780800) { // 01.12.2020
            return available_bonus.mul(3);
        } else if (block.timestamp < 1617235200) { // 01.04.2021
            return available_bonus.mul(4);
        } else if (block.timestamp < 1625097600) { // 01.07.2021
            return available_bonus.mul(5);
        } else if (block.timestamp < 1633046400) { // 01.10.2021
            return available_bonus.mul(6);
        } else if (block.timestamp < 1638316800) { // 01.12.2021
            return available_bonus.mul(7);
        } else if (block.timestamp < 1646092800) { // 01.03.2022
            return available_bonus.mul(8);
        } else if (block.timestamp < 1654041600) { // 01.06.2022
            return available_bonus.mul(9);
        } else if (block.timestamp < 1661990400) { // 01.09.2022
            return available_bonus.mul(10);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return available_bonus.mul(11);
        } else if (block.timestamp < 1677628800) { // 01.03.2023
            return available_bonus.mul(12);
        } else if (block.timestamp < 1682899200) { // 01.05.2023
            return available_bonus.mul(13);
        } else if (block.timestamp < 1688169600) { // 01.07.2023
            return available_bonus.mul(14);
        } else if (block.timestamp < 1696118400) { // 01.10.2023
            return available_bonus.mul(15);
        } else if (block.timestamp < 1701388800) { // 01.12.2023
            return available_bonus.mul(16);
        } else {
            return seed_bonus[sender];
        }
    }

    function get_available_private_bonus(
        address sender
    )
        public
        view
        returns (uint256)
    {
        uint256 available_bonus = private_bonus[sender].div(18);
        if (block.timestamp < 1575158400) { // 01.12.2019
            return 0;
        } else if (block.timestamp < 1580515200) { // 01.02.2020
            return available_bonus;
        } else if (block.timestamp < 1588291200) { // 01.05.2020
            return available_bonus.mul(2);
        } else if (block.timestamp < 1606780800) { // 01.12.2020
            return available_bonus.mul(3);
        } else if (block.timestamp < 1617235200) { // 01.04.2021
            return available_bonus.mul(4);
        } else if (block.timestamp < 1619827200) { // 01.05.2021
            return available_bonus.mul(5);
        } else if (block.timestamp < 1627776000) { // 01.08.2021
            return available_bonus.mul(6);
        } else if (block.timestamp < 1638316800) { // 01.12.2021
            return available_bonus.mul(7);
        } else if (block.timestamp < 1646092800) { // 01.03.2022
            return available_bonus.mul(8);
        } else if (block.timestamp < 1656633600) { // 01.07.2022
            return available_bonus.mul(9);
        } else if (block.timestamp < 1664582400) { // 01.10.2022
            return available_bonus.mul(10);
        } else if (block.timestamp < 1669852800) { // 01.12.2022
            return available_bonus.mul(11);
        } else if (block.timestamp < 1680307200) { // 01.04.2023
            return available_bonus.mul(12);
        } else if (block.timestamp < 1688169600) { // 01.07.2023
            return available_bonus.mul(13);
        } else if (block.timestamp < 1696118400) { // 01.10.2023
            return available_bonus.mul(14);
        } else if (block.timestamp < 1701388800) { // 01.12.2023
            return available_bonus.mul(15);
        } else if (block.timestamp < 1709251200) { // 01.03.2024
            return available_bonus.mul(16);
        } else if (block.timestamp < 1719792000) { // 01.07.2024
            return available_bonus.mul(17);
        } else {
            return private_bonus[sender];
        }
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    )
        internal
    {
        if (block.timestamp < STOP_ALL_LOCKS_TIME) {
            if (recipient == address(bank)) {
                require(
                    tokens_for_sell[sender] >= amount,
                    "Tokens must be unlocked"
                );
                require(
                    block.timestamp < STOP_SELL_TIME,
                    "The time must be less than the stop sell time"
                );
                require(
                    bank.send_ether(
                        address(uint160(sender)),
                        amount
                    ),
                    "Bank problem"
                );
                tokens_for_sell[sender] = tokens_for_sell[sender].sub(
                    amount
                );
            } else {
                require(
                    amount <= get_available_balance(sender),
                    "No available balance"
                );
            }
        }
        super._transfer(sender, recipient, amount);
    }
}
