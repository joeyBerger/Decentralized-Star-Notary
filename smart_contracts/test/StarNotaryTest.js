const StarNotary = artifacts.require('StarNotary')

contract('StarNotary', accounts => { 

    beforeEach(async function() { 
        this.contract = await StarNotary.new({from: accounts[0]})
    })
    
    describe('can create a star', () => { 
        it('can create a star and get its name', async function () { 
            let tokenId = 1
            var starMembers = ['Awesome Star!','Story','Ra','Dec','Mag'];
            await this.contract.createStar(starMembers[0], starMembers[1], starMembers[2], starMembers[3], starMembers[4], tokenId, {from: accounts[0]})
            async function testStarInfoArr() {
                var infoArr = await this.contract.tokenIdToStarInfo(tokenId);
                for (var i = 0; i < starMembers.length; i++) {
                    assert.equal(infoArr[i], starMembers[i])
                }
              }       
              testStarInfoArr();
        })

        it ('cannot create new star with same coordinates', async function () {
            let tokenId = 1
            await this.contract.createStar('Awesome Star!',"Story","Ra","Dec","Mag", tokenId, {from: accounts[0]})
            await expectThrow(this.contract.createStar('Awesome Star!',"Story","Ra","Dec","Mag", tokenId+1, {from: accounts[1]}))
            
        })
    })

    describe('buying and selling stars', () => { 

        let user1 = accounts[1]
        let user2 = accounts[2]

        let starId = 1
        let starPrice = web3.toWei(.01, "ether")

        beforeEach(async function () {
            await this.contract.createStar('Awesome Star!',"Story","Ra","Dec","Mag", starId, {from: user1})
        })

        describe('user1 can sell a star', () => { 
            it('user1 can put up their star for sale', async function () { 
                await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
            
                assert.equal(await this.contract.starsForSale(starId), starPrice)
            })

            it('total stars for sale is correct', async function () {
                await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
                let returnObj = await this.contract.allStarsForSale();
                let totalStarsForSale = [];
                totalStarsForSale.push(starId);
                for (var i = 0; i < returnObj.length; i++) {
                    assert.equal(totalStarsForSale[i],returnObj[i].c[0]);
                }              
            })

            it('user1 gets the funds after selling a star', async function () { 
                let starPrice = web3.toWei(.05, 'ether')
                
                await this.contract.putStarUpForSale(starId, starPrice, {from: user1})

                let balanceOfUser1BeforeTransaction = web3.eth.getBalance(user1)
                await this.contract.buyStar(starId, {from: user2, value: starPrice})
                let balanceOfUser1AfterTransaction = web3.eth.getBalance(user1)

                assert.equal(balanceOfUser1BeforeTransaction.add(starPrice).toNumber(), 
                            balanceOfUser1AfterTransaction.toNumber())
            })
        })

        describe('user2 can buy a star that was put up for sale', () => { 
            beforeEach(async function () { 
                await this.contract.putStarUpForSale(starId, starPrice, {from: user1})
            })

            it('user2 is the owner of the star after they buy it', async function () { 
                await this.contract.buyStar(starId, {from: user2, value: starPrice})

                assert.equal(await this.contract.ownerOf(starId), user2)
            })

            it('user2 correctly has their balance changed', async function () { 
                let overpaidAmount = web3.toWei(.05, 'ether')

                const balanceOfUser2BeforeTransaction = web3.eth.getBalance(user2)
                await this.contract.buyStar(starId, {from: user2, value: overpaidAmount, gasPrice:0})
                const balanceAfterUser2BuysStar = web3.eth.getBalance(user2)

                assert.equal(balanceOfUser2BeforeTransaction.sub(balanceAfterUser2BuysStar), starPrice)
            })
        })
    })
})

var expectThrow = async function(promise) { 
    try { 
        await promise
    } catch (error) { 
        assert.exists(error)
        return
    }

    assert.fail('Expected an error but didnt see one!')
}