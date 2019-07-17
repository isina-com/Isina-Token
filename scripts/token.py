#!/usr/bin/python3

from brownie import *

def main():
    accounts[0].deploy(
        IsinaToken,
        accounts[0],
        accounts[1],
        accounts[2],
        accounts[3]
    )

def send_seed_tokens(to_address, from_address, amount):
    token = IsinaToken[0]
    token.send_seed_tokens(
        to_address,
        amount,
        {"from": from_address}
    )

def send_private_tokens(to_address, from_address, amount):
    token = IsinaToken[0]
    token.send_private_tokens(
        to_address,
        amount,
        {"from": from_address}
    )

def send_launchpad_tokens(to_address, from_address, amount):
    token = IsinaToken[0]
    token.send_launchpad_tokens(
        to_address,
        amount,
        {"from": from_address}
    )
