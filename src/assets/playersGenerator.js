const name = ['Player 1', 'Player 2', 'Player 3', 'Player 4']

const players = name.map((e, index) =>
  ({ id:index, name: e, pos: 0, money: 1500, ownedProps: [], color: index})
)

export default players;