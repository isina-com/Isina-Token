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

def total_supply():
    check.equal(
        token.totalSupply(),
        408812400000000000000000000,
        "Total supply is wrong"
    )

def balances():
    check.equal(
        token.balanceOf(tokens_holder),
        347490540000000000000000000,
        "Tokens holder balance is wrong"
    )
    check.equal(
        token.balanceOf(team),
        28616868000000000000000000,
        "Team balance is wrong"
    )
    check.equal(
        token.balanceOf(marketing),
        4088124000000000000000000,
        "Marketing balance is wrong"
    )
    check.equal(
        token.balanceOf(reserve),
        28616868000000000000000000,
        "Reserve balance is wrong"
    )
