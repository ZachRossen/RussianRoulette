players: public(DynArray[address, 100])
losers: public(DynArray[address, 100])
odds: uint256
playersTurn: uint256
creator: address

@external
def __init__():
    self.creator = msg.sender
    self.playersTurn = 0
    self.odds = 0
    self.players = []
    self.losers = []

@external
def setOdds(oneInThisMany: uint256):
    assert oneInThisMany >= 1
    assert msg.sender == self.creator
    self.odds = oneInThisMany

@external
def addPlayer(player: address):
    assert player != empty(address)
    for addr in self.losers:
        assert addr != player
    for addr in self.players:
        assert addr != player
    self.players.append(player)

@internal
def lose(player: address):
    assert player != empty(address)
    self.players = []
    self.losers.append(player)

@internal
def random() -> (uint256):
    return block.number % self.odds + 1

@external
def play():
    if self.random() == 1:
        self.lose(self.players[self.playersTurn])
    else:
        self.playersTurn += 1

@external
def isALoser(person: address) -> (bool):
    assert person != empty(address)
    for addr in self.losers:
        if addr == person:
            return True
    return False
