const assert = require('assert');
const contracts = require('../compile');
const tether = require('../compiled/tether.json');
const {
  useMethodsOn,
  secondsInTheFuture,
  zeroOrOne,
  newArray,
  timeInSecs,
} = require('../utils/helper');
const { deploy, getAccounts } = require('../utils/useWeb3');

const sideBetContract = contracts['SideBetV3.sol'].SideBetV3;

describe('SideBetV3 tests', () => {
  let accounts, SideBetV3, TetherToken;

  const totalSupply = 100000000;
  const sides = ['Machester', 'Liverpool'];
  const eventCode = 'Man v. Liv';
  const saleDuration = 3;
  const ownerPercent = 5;

  beforeEach(async () => {
    accounts = await getAccounts();
    // Local USDT instance. Address accounts[0] is the
    // owner of the contract and is immediately minted totalSupply
    // amount of tokens on initialization
    TetherToken = await deploy(
      tether,
      [totalSupply, 'Tether', 'USDT', 18],
      accounts[0]
    );
    SideBetV3 = await deploy(
      sideBetContract,
      [TetherToken.options.address, ownerPercent],
      accounts[0]
    );
  });

  describe('SideBetV3', () => {
    it('deploys successfully', () => {
      assert.ok(SideBetV3.options.address);
    });

    it('allows to set side names for event', () =>
      useMethodsOn(SideBetV3, [
        {
          // If the side names haven't been set by the
          // owner, we should see the default name for each side
          method: 'getEventSides',
          args: [eventCode],
          account: accounts[0],
          onReturn: (eventSides) => {
            const [sideA, sideB] = Object.values(eventSides);
            assert.strictEqual(sideA, 'sideA');
            assert.strictEqual(sideB, 'sideB');
          },
        },
        {
          // The owner can set the side names at any time,
          // even if the event hasn't been defined yet
          method: 'setEventSides',
          args: [eventCode, sides[0], sides[1]],
          account: accounts[0],
        },
        {
          // No we can check if the contract
          // has the correct name for each side
          method: 'getEventSides',
          args: [eventCode],
          account: accounts[0],
          onReturn: (eventSides) => {
            Object.values(eventSides).forEach((side, i) => {
              assert.strictEqual(side, sides[i]);
            });
          },
        },
      ]));

    it('allows to set and edit sale start and end time', () => {
      const [inTenS, inTwentyS, inThirtyS] = [10, 20, 30].map(secs => secondsInTheFuture(secs));
      const timestamp = timeInSecs();

      return useMethodsOn(SideBetV3, [
        {
          method: 'setSaleStartEnd',
          args: [eventCode, 0, inTenS],
          account: accounts[0],
        },
        {
          method: 'isSaleOn',
          args: [eventCode],
          account: accounts[0],
          onReturn: (data) => {
            const startTime = parseInt(data.saleStart);
            const endTime = parseInt(data.saleEnd);
            
            assert.strictEqual(startTime, timestamp);
            assert.strictEqual(endTime, inTenS);
          },
        },
        {
          method: 'setSaleStartEnd',
          args: [eventCode, inTwentyS, inThirtyS],
          account: accounts[0],
        },
        {
          method: 'isSaleOn',
          args: [eventCode],
          account: accounts[0],
          onReturn: (data) => {
            const startTime = parseInt(data.saleStart);
            const endTime = parseInt(data.saleEnd);
            
            assert.strictEqual(startTime, inTwentyS);
            assert.strictEqual(endTime, inThirtyS);
          },
        },
      ]);
    });

    it('allows users to deposit, owner to select winning side and distribute rewards', () => {
      const transferAmount = 10000;
      const numOfUsersToDeposit = 7;
      const sideToDepositFor = newArray(numOfUsersToDeposit, () => zeroOrOne());
      const winningSide = zeroOrOne();
      const totalReward = transferAmount * numOfUsersToDeposit;
      const usersVotedForWinner = sideToDepositFor.reduce(
        (totalReward, side) =>
          side === winningSide ? totalReward + 1 : totalReward,
        0
      );
      const rewardPerUser = Math.floor(
        (totalReward * (1 - ownerPercent / 100)) / usersVotedForWinner
      );
      const expectedOwnerCut =
        (transferAmount * numOfUsersToDeposit * ownerPercent) / 100;
      let ownerBalance;

      return useMethodsOn(TetherToken, [
        // We first transfer some amount of USDT to
        // each user participating
        ...newArray(numOfUsersToDeposit, (i) => ({
          method: 'transfer',
          args: [accounts[i + 1], transferAmount],
          account: accounts[0],
        })),
        // Each user must approve the USDT tokens they want
        // to deposit towards the SideBet contract
        ...newArray(numOfUsersToDeposit, (i) => ({
          method: 'approve',
          args: [SideBetV3.options.address, transferAmount],
          account: accounts[i + 1],
        })),
        {
          method: 'balanceOf',
          args: [accounts[0]],
          account: accounts[0],
          onReturn: (amount) => {
            ownerBalance = parseInt(amount);
          },
        },
      ])
        .then(() =>
          useMethodsOn(SideBetV3, [
            {
              // The owner starts the sale immediately
              method: 'setSaleStartEnd',
              args: [eventCode, 0, secondsInTheFuture(saleDuration)],
              account: accounts[0],
            },
            {
              // And sets the name for each side in the event
              method: 'setEventSides',
              args: [eventCode, sides[0], sides[1]],
              account: accounts[0],
            },
            ...newArray(numOfUsersToDeposit, (i) => ({
              // Each user will deposit their USDT and choose
              // which side they are betting on
              method: 'deposit',
              args: [eventCode, sideToDepositFor[i], transferAmount],
              account: accounts[i + 1],
            })),
            ...newArray(numOfUsersToDeposit, (i) => ({
              // We check how much each user deposited
              method: 'getEventUserDepositData',
              args: [eventCode, accounts[i + 1]],
              account: accounts[0],
              onReturn: (amounts) => {
                const side = sideToDepositFor[i];
                const userDeposited = Object.values(amounts)[side];

                // And check if they deposited the right amount
                assert.strictEqual(parseInt(userDeposited), transferAmount);
              },
            })),
            {
              method: 'getEventDepositData',
              args: [eventCode],
              account: accounts[0],
              onReturn: (data) => {
                // We check that the total amount deposited for this event
                // is equal to the expected amount
                const totalDeposited = parseInt(data[0]) + parseInt(data[1]);
                const expectedDeposit = transferAmount * numOfUsersToDeposit;
                assert.strictEqual(totalDeposited, expectedDeposit);
              },
            },
            {
              wait: saleDuration * 1000,
            },
            {
              // After the sale ends, the owner
              // must select the winning side
              method: 'selectWinningSide',
              args: [eventCode, winningSide],
              account: accounts[0],
            },
            {
              // We should be able to read which side
              // won after the winner has been selected
              method: 'getWinningSide',
              args: [eventCode],
              account: accounts[0],
              onReturn: (winner) => {
                assert.strictEqual(winner, sides[winningSide]);
              },
            },
            // Only after the owner has selected the winning side, each user can
            // withdraw the funds they deposited for their bet
            ...newArray(numOfUsersToDeposit, (i) => ({
              method: 'withdraw',
              args: [eventCode],
              account: accounts[i + 1],
            })),
          ])
        )
        .then(() =>
          useMethodsOn(TetherToken, [
            {
              method: 'balanceOf',
              args: [accounts[0]],
              account: accounts[0],
              onReturn: (amount) => {
                assert.strictEqual(
                  parseInt(amount),
                  ownerBalance + expectedOwnerCut
                );
              },
            },
            ...newArray(numOfUsersToDeposit, (i) => ({
              method: 'balanceOf',
              args: [accounts[i + 1]],
              account: accounts[0],
              onReturn: (amount) => {
                // We check if each user has received their expected reward
                const expectedReward =
                  sideToDepositFor[i] === winningSide ? rewardPerUser : 0;
                assert.strictEqual(parseInt(amount), expectedReward);
              },
            })),
          ])
        );
    });

    it('allows owner to cancel event and users to withdraw deposited funds', () => {
      const transferAmount = 10000;
      const numOfUsersToDeposit = 7;
      const sideToDepositFor = newArray(numOfUsersToDeposit, () => zeroOrOne());

      return useMethodsOn(TetherToken, [
        // We first transfer some amount of USDT to
        // each user participating
        ...newArray(numOfUsersToDeposit, (i) => ({
          method: 'transfer',
          args: [accounts[i + 1], transferAmount],
          account: accounts[0],
        })),
        // Each user must approve the USDT tokens they want
        // to deposit towards the SideBet contract
        ...newArray(numOfUsersToDeposit, (i) => ({
          method: 'approve',
          args: [SideBetV3.options.address, transferAmount],
          account: accounts[i + 1],
        })),
      ])
        .then(() =>
          useMethodsOn(SideBetV3, [
            {
              // The owner starts the sale immediately
              method: 'setSaleStartEnd',
              args: [eventCode, 0, secondsInTheFuture(saleDuration)],
              account: accounts[0],
            },
            {
              // And sets the name for each side in the event
              method: 'setEventSides',
              args: [eventCode, sides[0], sides[1]],
              account: accounts[0],
            },
            ...newArray(numOfUsersToDeposit, (i) => ({
              // Each user will deposit their USDT and choose
              // which side they are betting on
              method: 'deposit',
              args: [eventCode, sideToDepositFor[i], transferAmount],
              account: accounts[i + 1],
            })),
            ...newArray(numOfUsersToDeposit, (i) => ({
              // We check how much each user deposited
              method: 'getEventUserDepositData',
              args: [eventCode, accounts[i + 1]],
              account: accounts[0],
              onReturn: (amounts) => {
                const side = sideToDepositFor[i];
                const userDeposited = Object.values(amounts)[side];

                // And check if they deposited the right amount
                assert.strictEqual(parseInt(userDeposited), transferAmount);
              },
            })),
            {
              method: 'getEventDepositData',
              args: [eventCode],
              account: accounts[0],
              onReturn: (data) => {
                // We check that the total amount deposited for this event
                // is equal to the expected amount
                const totalDeposited = parseInt(data[0]) + parseInt(data[1]);
                const expectedDeposit = transferAmount * numOfUsersToDeposit;
                assert.strictEqual(totalDeposited, expectedDeposit);
              },
            },
            {
              wait: saleDuration * 1000,
            },
            {
              // After the sale ends, the cancels the event
              method: 'cancelEvent',
              args: [eventCode],
              account: accounts[0],
            },
            {
              // We should be able to read which side
              // won after the winner has been selected
              method: 'getWinningSide',
              args: [eventCode],
              account: accounts[0],
              catch: (error) => {
                assert.strictEqual(error, 'SideBetV3: event is cancelled, no winning side selected');
              },
            },
            // Only after the owner has cancelled the event, each user can
            // withdraw the funds they deposited for their bet
            ...newArray(numOfUsersToDeposit, (i) => ({
              method: 'withdraw',
              args: [eventCode],
              account: accounts[i + 1],
            })),
          ])
        )
        .then(() =>
          useMethodsOn(TetherToken, [
            ...newArray(numOfUsersToDeposit, (i) => ({
              method: 'balanceOf',
              args: [accounts[i + 1]],
              account: accounts[0],
              onReturn: (amount) => {
                // We check if each user has received their expected reward
                assert.strictEqual(parseInt(amount), transferAmount);
              },
            })),
          ])
        );
    });
  });
});
