import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

import board from '@/assets/boardGenerator'
import players from '@/assets/playersGenerator'
import gsap from 'gsap'

categoryColors = [
  '#E6B0AA', '#D7BDE2', '#A9CCE3', '#A3E4D7',
  '#A9DFBF', '#FAD7A0', '#E59866', '#EAF0EA'
]

playerColors = ['#EC7063', '#5DADE2', '#45B39D', '#F5B041']
board.forEach (e) => e.color = categoryColors[e.color]
players.forEach (e) => e.color = playerColors[e.color]


start = 0
time = ""
getTime =  ->
  start = start + 1
  minute = Math.floor start/ 60
  seconds = start - ( minute * 60 )
  if minute < 10 then minute = "0" + minute
  if seconds < 10 then seconds = "0" + seconds
  time = minute + ":" + seconds

setInterval getTime, 1000

# Temporary Setup for testing
board[0].onThisTile = [0, 1, 2, 3]

export default new Vuex.Store
  state:
    tiles: board
    players: players,
    logs: [ ]
    currentPlayer: 0

  getters:
  #TODO: Getter Chaining ?
    canBuy: (state, getters) =>
      ( player = state.currentPlayer,
      location = getters.getPos player ) =>
        location = state.tiles[location]
        if location.ownedBy isnt player and
        location.ownedBy is null and
        location.price isnt null and
        state.players[player].money > location.price
        then true else false

    getPos: (state) =>
      (i = state.currentPlayer) => state.players[i].pos

    getCurrent: (state) =>
      state.players[state.currentPlayer]

    getOwner: (state, getters) =>
      (tile = getters.getPos()) => state.tiles[tile].ownedBy

    getRent: (state) => (tile) =>
      if state.tiles[tile].ownedBy is null
        state.tiles[tile].price
      else state.tiles[tile].rent[state.tiles[tile].houses]

  actions:
    tradeProps: ({ dispatch }, { player1, player2, props1, props2 } ) =>
      if props1?
        props1.forEach (prop) =>
          dispatch 'sellProp', { player: player1, tile: prop, price: 0 }
          dispatch 'buyProp', { player: player2, tile: prop, price: 0 }
      if props2?
        props2.forEach (prop) =>
          dispatch 'sellProp', { player: player2, tile: prop, price: 0 }
          dispatch 'buyProp', { player: player1, tile: prop, price: 0 }

    movePlayer: ({ state, commit, getters },
    { player = state.currentPlayer, from, to }) =>
      commit 'removeFromTile', { player, tile: from }
      commit 'addToTile', { player, tile: to }
      commit 'setPos', { player, tile: to }
      commit 'log', """<span style="color: #{getters.getCurrent.color}">#{getters.getCurrent.name}</span> moved to <span style="background:#{state.tiles[to].color};">#{state.tiles[to].name}</span>"""

    buyProp: ({ state, commit },
    { player, tile, price = state.tiles[tile].price, auction = false }) =>
      commit 'deductMoney', { player, money: price}
      commit 'addProp', { player, tile }
      commit 'setOwner', { player, tile }
      if auction
        commit 'log', """<span style="color: #{state.players[player].color}">#{state.players[player].name}</span> won auction for <span style="background: #{state.tiles[tile].color};"> #{state.tiles[tile].name}</span>, difference #{price - state.tiles[tile].price} to original"""
      else
        commit 'log', """<span style="color: #{state.players[player].color}">#{state.players[player].name}</span> bought <span style="background: #{state.tiles[tile].color};"> #{state.tiles[tile].name}</span>"""

    sellProp: ({ state, commit },
    { player, tile, price = state.tiles[tile].price }) =>
      commit 'removeProp', { player, tile }
      commit 'setOwner', { player: null, tile }
      commit 'addMoney', {player, money: price}
      commit 'log', """<span style="color: #{state.players[player].color}">#{state.players[player].name}</span> sold <span style="background: #{state.tiles[tile].color};"> #{state.tiles[tile].name}</span>"""

    pay: ({ state, commit, getters }, { from, to, amt }) =>
      from = if from == null then state.currentPlayer else from
      to = if to == null then getters.getOwner getters.getPos() else to
      amt = if amt == null then getters.getRent getters.getPos() else amt
      commit 'deductMoney', { player: from, money: amt }
      commit 'addMoney', { player: to, money: amt }
      commit 'log', """<span style="color: #{getters.getCurrent.color}">#{state.players[from].name}</span> paid <b>$#{amt}</b> to <span style="color: #{state.players[to].color}">#{state.players[to].name}</span>"""

  mutations:
    removeFromTile: (state, { player, tile }) =>
      state.tiles[tile].onThisTile
        .splice state.tiles[tile].onThisTile.indexOf(player), 1

    addToTile: (state, { player, tile }) =>
      state.tiles[tile].onThisTile.push player

    setPos: (state, { player, tile }) =>
      state.players[player].pos = tile

    nextPlayer: (state) =>
      state.currentPlayer =
        if state.currentPlayer == players.length - 1 then 0
        else state.currentPlayer + 1

    deductMoney: (state, { player, money }) =>
      state.players[player].money -= money

    addMoney: (state, { player, money }) =>
      state.players[player].money += money

    addProp: (state, { player, tile }) =>
      state.players[player].ownedProps.push tile

    removeProp: (state, { player, tile }) =>
      state.players[player].ownedProps
        .splice state.players[player].ownedProps.indexOf(tile), 1
    
    setOwner: (state, {player, tile}) =>
      state.tiles[tile].ownedBy = player

    log: (state, msg) =>
      state.logs.push { time, msg }