const { expect } = require("chai");

const HallOfRoyalsToken = artifacts.require("HallOfRoyals");

require("chai")
  .use(require("chai-as-promised"))
  .should()

contract("HallOfRoyals", (accounts) => {

  let hallOfRoyals;
  before(async () => {
    hallOfRoyals = await HallOfRoyalsToken.new()
  })

  describe("Deployed Hall of royals", async () => {
    it("has an owner", async () => {
      let owner = await hallOfRoyals.owner()
      expect(owner).to.equal(accounts[0])
    })

    it("has a name", async () => {
      let name = await hallOfRoyals.name()
      expect(name).to.equal("Hall Of Royals")
    })

    it("has a symbol", async () => {
      let symbol = await hallOfRoyals.symbol()
      expect(symbol).to.equal("HOR")
    })
  })

  describe("Minting a royal", async () => {
    let ownerBalanceBefore
    let buyerBalanceBefore

    before(async () => {
      ownerBalanceBefore = await web3.eth.getBalance(accounts[0]);
      ownerBalanceBefore = web3.utils.toBN(ownerBalanceBefore)

      buyerBalanceBefore = await web3.eth.getBalance(accounts[1]);
      buyerBalanceBefore = web3.utils.toBN(buyerBalanceBefore)
    })

    let reciept

    it("mints a token", async () => {
      reciept = await hallOfRoyals.mint(1, { from: accounts[1], value: web3.utils.toWei('0.018721227621483') })
      transaction = await web3.eth.getTransaction(reciept.tx);
    })

    it("has correct tokenURI", async () => {
      let tokenURI = await hallOfRoyals.tokenURI(1);
      expect(tokenURI).to.equal("ipfs://QmNXSQPSXkKcyfz1Hv5UfXdnEce8HbPmvRxX9QiKNgaigF/hidden.json")
    })

    it("checking ownership to the token", async () => {
      let owner = await hallOfRoyals.ownerOf(1)
      expect(owner).to.equal(accounts[1])
    })

    it("reveal token image", async () => {
      await hallOfRoyals.reveal()
      let tokenURI = await hallOfRoyals.tokenURI(1);
      expect(tokenURI).to.equal("ipfs://QmfQYSR4gTxx7K4ctnfqEXDr3Hkbpd3btqkYrya5APWTvB/1.json")
    })

    it('change max mintable value', async () => {
      await hallOfRoyals.setmaxMintAmount(5);
      let maxMintable = await hallOfRoyals.maxMintAmount();
      expect(maxMintable.toString()).to.equal('5');
    })
  })

  describe("Clear contract balance", async () => {
    it('clear balance', async () => {
      await hallOfRoyals.mint(1, { from: accounts[1], value: web3.utils.toWei('0.018721227621483') })
      await hallOfRoyals.clearETH();
      let balance = await web3.eth.getBalance(hallOfRoyals.address);
      expect(balance.toString()).to.equal('0');
    })
  })
})
