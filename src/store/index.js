import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

import board from '@/assets/boardGenerator'
import players from '@/assets/playersGenerator'
import gsap from 'gsap'
import { _ } from 'core-js'

const categoryColors = ['#E6B0AA', '#D7BDE2', '#A9CCE3', '#A3E4D7', '#A9DFBF', '#FAD7A0', '#E59866', '#EAF0EA'];
const playerColors = ['#EC7063', '#5DADE2', '#45B39D', '#F5B041'];
board.forEach(e => e.color = categoryColors[e.color]);
players.forEach(e => e.color = playerColors[e.color]);


let start = 0;
let time = "";
function getTime() {
  start = start + 1;
  let minute = Math.floor((start/ 60))
  let seconds = start - (minute*60)
  if(minute < 10)
    minute = "0"+minute;
  if(seconds < 10)
    seconds = "0"+seconds;
  time = minute + ":" + seconds;
}
setInterval(getTime, 1000);

board[0].onThisTile = [0, 1, 2, 3];

players[0].ownedProps = [1, 2, 3, 4]
players[1].ownedProps = [5, 6, 7, 8]
players[2].ownedProps = [9, 10, 11, 12]
players[3].ownedProps = [13, 14, 15, 16]

export default new Vuex.Store({
  state: {
    tiles: board,
    players,
    logs: [ ],
    currentPlayer: 0,
  },

  getters: {
    canBuy: state => (player = state.currentPlayer, location = state.tiles[state.players[player].pos]) =>
      location.ownedBy != player &&
        location.ownedBy == null &&
        location.price != null &&
        state.players[player].money >= location.price ?
        true : false,

    getPos: state => (i = state.currentPlayer) => state.players[i].pos,
    getCurrent: state => state.players[state.currentPlayer],
    getOwner: (state, getters) => (tile = getters.getPos()) => state.tiles[tile].ownedBy,
    getRent: state => tile =>
      state.tiles[tile].ownedBy == null ? state.tiles[tile].price : state.tiles[tile].rent[state.tiles[tile].houses]
  },

  actions: {
    tradeProps: ({ dispatch }, { player1, player2, props1, props2 } ) => {
      console.log({player1, player2, props1, props2})
      props1.forEach(prop => {
        dispatch('sellProp', { player: player1, tile: prop, price: 0 })
        dispatch('buyProp', { player: player2, tile: prop, price: 0 })
      });
      props2.forEach(prop => {
        dispatch('sellProp', { player: player2, tile: prop, price: 0 })
        dispatch('buyProp', { player: player1, tile: prop, price: 0 })
      });
    },
    movePlayer: ({ state, commit, getters }, { player = state.currentPlayer, from, to }) => {
      commit('removeFromTile', { player, tile: from })
      commit('addToTile', { player, tile: to })
      commit('setPos', { player, tile: to })
      commit('log', `<span style="color: ${getters.getCurrent.color}">${getters.getCurrent.name}</span> moved to <span style="background:${state.tiles[to].color};">${state.tiles[to].name}</span>`)
    },
    buyProp: ({ state, commit }, { player, tile, price = state.tiles[tile].price, auction = false }) => {
      commit('deductMoney', { player, money: price});
      commit('addProp', { player, tile });
      commit('setOwner', { player, tile })
      if(auction == true)
        commit('log', `<span style="color: ${state.players[player].color}">${state.players[player].name}</span> won auction for <span style="background: ${state.tiles[tile].color};"> ${state.tiles[tile].name}</span>, difference ${price - state.tiles[tile].price} to original`)
      else
        commit('log', `<span style="color: ${state.players[player].color}">${state.players[player].name}</span> bought <span style="background: ${state.tiles[tile].color};"> ${state.tiles[tile].name}</span>`)
    },
    sellProp: ({ state, commit }, { player, tile, price = state.tiles[tile].price }) => {
      commit('removeProp', { player, tile });
      commit('setOwner', { player: null, tile })
      commit('addMoney', {player, money: price})
      commit('log', `<span style="color: ${state.players[player].color}">${state.players[player].name}</span> sold <span style="background: ${state.tiles[tile].color};"> ${state.tiles[tile].name}</span>`)
    },
    pay: ({ state, commit, getters }, { from, to, amt }) => {
      from = from == null ? state.currentPlayer : from;
      to = to == null ? getters.getOwner(getters.getPos()) : to;
      amt = amt == null ? getters.getRent(getters.getPos()) : amt;
      commit('deductMoney', { player: from, money: amt });
      commit('addMoney', { player: to, money: amt })
      commit('log', `<span style="color: ${getters.getCurrent.color}">${state.players[from].name}</span> paid <b>$${amt}</b> to <span style="color: ${state.players[to].color}">${state.players[to].name}</span>`)
    }
  },

  mutations: {
    removeFromTile: (state, { player, tile }) =>
      state.tiles[tile].onThisTile.splice(state.tiles[tile].onThisTile.indexOf(player), 1),

    addToTile: (state, { player, tile }) =>
      state.tiles[tile].onThisTile.push(player),

    setPos: (state, { player, tile }) =>
      state.players[player].pos = tile,

    nextPlayer: state =>
      state.currentPlayer = state.currentPlayer == players.length - 1 ? 0 : state.currentPlayer + 1,

    deductMoney: (state, { player, money }) => {
      player = state.players[player];
      gsap.to(player,
      {
        duration: 2,
        ease: 'power3.out',
        money: player.money - money,
        onUpdate: () => player.money = Math.round(player.money)
      }
    )},

    addMoney: (state, { player, money }) => {
      player = state.players[player];
      gsap.to(player,
      {
        duration: 2,
        ease: 'power3.out',
        money: player.money + money,
        onUpdate: () => player.money = Math.round(player.money)
      },
    )},

    addProp: (state, { player, tile }) => state.players[player].ownedProps.push(tile),
    removeProp: (state, { player, tile }) =>
      state.players[player].ownedProps.splice(state.players[player].ownedProps.indexOf(tile), 1),
    
    setOwner: (state, {player, tile}) => state.tiles[tile].ownedBy = player,

    log: (state, msg) => {
     state.logs.push({ time, msg })
    }

  }
})