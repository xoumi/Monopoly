const name = [
  "GO",
  "Old Kent Road",
  "Whitechapel Road",
  "The Angel, Islington",
  "Pentonville Road",
  "Euston Road",
  "Pall Mall",
  "Jail",
  "Whitehall",
  "Northumberland Avenue",
  "Bow Street",
  "Marlborough Street",
  "Free Parking",
  "Vine Street",
  "Strand",
  "Fleet Street",
  "Trafalgar Square",
  "Leicester Square",
  "Coventry Street",
  "Go To Jail",
  "Piccadilly",
  "Regent Street",
  "Oxford Street",
  "Bond Street",
];

const color = [7, 0, 0, 0, 1, 1, 1, 7, 2, 2, 2, 2, 7, 3, 3, 3, 4, 4, 4,7, 5, 5, 6, 6];

const price = [
 null,  60,  80, 100, 110, 120,
  140, null, 150, 160, 180, 190,
 null, 200, 220, 230, 240, 260,
  280, null, 300, 310, 320, 350
];

const rent = [
  null,
  [2, 10, 30, 90, 160, 250],
  [4, 20, 60, 180, 320, 450],
  [6, 30, 90, 270, 400, 550],
  [6, 30, 90, 270, 400, 550],
  [8, 40, 100, 300, 450, 600],
  [10, 50, 150, 450, 625, 750],
  null,
  [10, 50, 150, 450, 650, 750],
  [12, 60, 180, 500, 700, 900],
  [14, 70, 200, 550, 750, 950],
  [16, 70, 200, 550, 750, 950],
  null,
  [18, 80, 220, 600, 800, 1000],
  [18, 90, 220, 700, 875, 1050],
  [20, 90, 250, 750, 925, 1050],
  [22, 100, 300, 750, 975, 1100],
  [24, 100, 330, 800, 975, 1150],
  [26, 110, 350, 875, 1025, 1225],
  null,
  [26, 110, 390, 925, 1100, 1300],
  [28, 120, 450, 925, 1200, 1475],
  [35, 140, 500, 975, 1500, 1500],
  [50, 150, 600, 1000, 1700, 2000]
];

const mortgage = [null, 30, 30, 50, 50, 60, 70, null, 70, 80, 90, 100, null, 110, 120, 130, 130, 140, 150, null, 160, 160, 190, 200];

function generator() {
  let data = [];
  for (let i = 0; i < name.length; i++) {
    data.push({
      id: i,
      name: name[i],
      color: color[i],
      ownedBy: null,
      houses: 0,
      price: price[i],
      rent: rent[i],
      mortage: mortgage[i],
      isMortgaged: false,
      onThisTile: [],
      canUpgrade: false
    }) 
  }
  return data;
}

const board = generator();
export default board;