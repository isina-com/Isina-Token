from brownie import *

import scripts.token

def setup():
    scripts.token.main()
    global token
    token = IsinaToken[0]
    global tokens_holder
    tokens_holder = accounts[0]
    global team
    team = accounts[1]
    global marketing
    marketing = accounts[2]
    global reserve
    reserve = accounts[3]
    global user
    user = accounts[4]
    global recipient
    recipient = accounts[5]
    global amount
    amount = 1000000000000000000
    global seed_bonus
    seed_bonus = 8800000000000000
    global private_bonus
    private_bonus = 5500000000000000
    scripts.token.send_seed_tokens(user, tokens_holder, amount)
    scripts.token.send_private_tokens(user, tokens_holder, amount)
    scripts.token.send_launchpad_tokens(user, tokens_holder, amount)

def user_transfer():
    rpc.sleep(1575158400 - rpc.time())
    check.reverts(
        token.transfer,
        (
            recipient,
            1350000000000000000 + seed_bonus + private_bonus + 1,
            {"from": user}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            1350000000000000000 + seed_bonus + private_bonus,
            {"from": user}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": user}
        )
    )
    rpc.sleep(1580515200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1583020800 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1588291200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1593561600 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1606780800 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1617235200 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1619827200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1625097600 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1627776000 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1633046400 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1638316800 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1646092800 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1654041600 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1656633600 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1661990400 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1664582400 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1669852800 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1677628800 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1680307200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1682899200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + seed_bonus, user)
    rpc.sleep(1688169600 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1696118400 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1701388800 - rpc.time())
    _op_with_unlocked_tokens(
        100000000000000000 + seed_bonus + private_bonus,
        user
    )
    rpc.sleep(1709251200 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    rpc.sleep(1719792000 - rpc.time())
    _op_with_unlocked_tokens(50000000000000000 + private_bonus, user)
    check.confirms(
        token.transfer,
        (
            recipient,
            token.balanceOf(user),
            {"from": user}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": user}
        )
    )

def team_transfer():
    rpc.sleep(1590969600 - rpc.time())
    check.reverts(
        token.transfer,
        (
            recipient,
            2861686800000000000000001,
            {"from": team}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            2861686800000000000000000,
            {"from": team}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": team}
        )
    )
    rpc.sleep(1614556800 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, team)
    rpc.sleep(1646092800 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, team)
    rpc.sleep(1669852800 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1677628800 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1690848000 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1706745600 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1711929600 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1722470400 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1727740800 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1733011200 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, team)
    rpc.sleep(1740787200 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, team)
    rpc.sleep(1751328000 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, team)
    rpc.sleep(1764547200 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, team)
    check.confirms(
        token.transfer,
        (
            recipient,
            token.balanceOf(team),
            {"from": team}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": team}
        )
    )

def marketing_transfer():
    rpc.sleep(1588291200 - rpc.time())
    check.reverts(
        token.transfer,
        (
            recipient,
            408812400000000000000001,
            {"from": marketing}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            408812400000000000000000,
            {"from": marketing}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": marketing}
        )
    )
    rpc.sleep(1614556800 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    rpc.sleep(1648771200 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    rpc.sleep(1656633600 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1669852800 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1682899200 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    rpc.sleep(1690848000 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1711929600 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1722470400 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1733011200 - rpc.time())
    _op_with_unlocked_tokens(204406200000000000000000, marketing)
    rpc.sleep(1743465600 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    rpc.sleep(1754006400 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    rpc.sleep(1764547200 - rpc.time())
    _op_with_unlocked_tokens(408812400000000000000000, marketing)
    check.confirms(
        token.transfer,
        (
            recipient,
            token.balanceOf(marketing),
            {"from": marketing}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": marketing}
        )
    )

def reserve_transfer():
    rpc.sleep(1598918400 - rpc.time())
    check.reverts(
        token.transfer,
        (
            recipient,
            2861686800000000000000001,
            {"from": reserve}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            2861686800000000000000000,
            {"from": reserve}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": reserve}
        )
    )
    rpc.sleep(1619827200 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1630454400 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1654041600 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1664582400 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1682899200 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, reserve)
    rpc.sleep(1690848000 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1714521600 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, reserve)
    rpc.sleep(1719792000 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1727740800 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1733011200 - rpc.time())
    _op_with_unlocked_tokens(1430843400000000000000000, reserve)
    rpc.sleep(1746057600 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, reserve)
    rpc.sleep(1756684800 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, reserve)
    rpc.sleep(1764547200 - rpc.time())
    _op_with_unlocked_tokens(2861686800000000000000000, reserve)
    check.confirms(
        token.transfer,
        (
            recipient,
            token.balanceOf(reserve),
            {"from": reserve}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": reserve}
        )
    )

def _op_with_unlocked_tokens(up_amount, from_address):
    check.reverts(
        token.transfer,
        (
            recipient,
            up_amount + 1,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            from_address,
            1,
            {"from": recipient}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            up_amount,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            1,
            {"from": from_address}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            1,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            from_address,
            1,
            {"from": recipient}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            2,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            1,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            from_address,
            up_amount,
            {"from": recipient}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            up_amount - 1,
            {"from": from_address}
        )
    )
    check.reverts(
        token.transfer,
        (
            recipient,
            2,
            {"from": from_address}
        )
    )
    check.confirms(
        token.transfer,
        (
            recipient,
            1,
            {"from": from_address}
        )
    )
