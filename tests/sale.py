from brownie import *

import scripts.token

def setup():
    scripts.token.main()
    global token
    token = IsinaToken[0]
    global tokens_holder
    tokens_holder = accounts[0]
    global recipient
    recipient = accounts[4]
    global amount
    amount = 1000000000000000000

def sell_from_wrong_address():
    check.reverts(
        token.send_seed_tokens,
        (recipient, amount, {"from": accounts[5]}),
        "Sender must be a tokens holder"
    )
    check.reverts(
        token.send_private_tokens,
        (recipient, amount, {"from": accounts[5]}),
        "Sender must be a tokens holder"
    )
    check.reverts(
        token.send_launchpad_tokens,
        (recipient, amount, {"from": accounts[5]}),
        "Sender must be a tokens holder"
    )

def sell_more_max_tokens():
    check.reverts(
        token.send_seed_tokens,
        (recipient, 102203100000000000000000001, {"from": tokens_holder}),
        "SafeMath: subtraction overflow"
    )
    check.reverts(
        token.send_private_tokens,
        (recipient, 163524960000000000000000001, {"from": tokens_holder}),
        "SafeMath: subtraction overflow"
    )
    check.reverts(
        token.send_launchpad_tokens,
        (recipient, 81762480000000000000000001, {"from": tokens_holder}),
        "SafeMath: subtraction overflow"
    )

def sell_tokens():
    check.confirms(
        token.send_seed_tokens,
        (recipient, amount, {"from": tokens_holder}),
        "Sender must be a tokens holder"
    )
    check.confirms(
        token.send_private_tokens,
        (recipient, amount, {"from": tokens_holder}),
        "Sender must be a tokens holder"
    )
    check.confirms(
        token.send_launchpad_tokens,
        (recipient, amount, {"from": tokens_holder}),
        "Sender must be a tokens holder"
    )
    check.equal(
        token.balanceOf(tokens_holder),
        347490536751400000000000000,
        "Tokens holder balance is wrong"
    )
    check.equal(
        token.balanceOf(recipient),
        3248600000000000000,
        "Recipient balance is wrong"
    )
    check.equal(
        token.seed_balance(recipient),
        1000000000000000000,
        "Recipient seed balance is wrong"
    )
    check.equal(
        token.private_balance(recipient),
        1000000000000000000,
        "Recipient private balance is wrong"
    )
    check.equal(
        token.seed_bonus(recipient),
        149600000000000000,
        "Recipient seed bonus is wrong"
    )
    check.equal(
        token.private_bonus(recipient),
        99000000000000000,
        "Recipient private bonus is wrong"
    )
    check.true(
        token.seed_locked(recipient),
        "Recipient seed balance is not locked"
    )
    check.true(
        token.private_locked(recipient),
        "Recipient private balance is not locked"
    )

def burn():
    check.reverts(
        token.burn_seed_tokens,
        ({"from": accounts[5]},),
        "Sender must be a tokens holder"
    )
    check.reverts(
        token.burn_private_tokens,
        ({"from": accounts[5]},),
        "Sender must be a tokens holder"
    )
    check.reverts(
        token.burn_launchpad_tokens,
        ({"from": accounts[5]},),
        "Sender must be a tokens holder"
    )
    check.confirms(
        token.burn_seed_tokens,
        ({"from": tokens_holder},),
        "Sender must be a tokens holder"
    )
    check.confirms(
        token.burn_private_tokens,
        ({"from": tokens_holder},),
        "Sender must be a tokens holder"
    )
    check.confirms(
        token.burn_launchpad_tokens,
        ({"from": tokens_holder},),
        "Sender must be a tokens holder"
    )
    check.equal(
        token.seed_tokens(),
        0,
        "Seed tokens amount is wrong"
    )
    check.equal(
        token.private_tokens(),
        0,
        "Private tokens amount is wrong"
    )
    check.equal(
        token.launchpad_tokens(),
        0,
        "Launchpad tokens amount is wrong"
    )
