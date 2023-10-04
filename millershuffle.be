#-

import millershuffle
var ms = millershuffle.create(123,100)  # shuffleID 123, listSize 100
print(ms.random())                      # next random number in shuffle sequence
print(ms.random(8))                     # reset index in sequence and get random number


See the original code for more info:
https://github.com/RondeSC/Miller_Shuffle_Algo/

Discussed in this thread:
https://github.com/arendst/Tasmota/discussions/19624

-#

var millershuffle_module = module("millershuffle")

class MillerShuffle
  var inx, shuffleID, listSize
  def create(shuffleID, listSize)
    self.shuffleID = shuffleID
    self.listSize = listSize
    self.inx = 0
    return self
  end
  def random(inx)
    if inx == nil
      inx = self.inx + 1
    end
    self.inx = inx
    var p1 = 24317, p2 = 32141, p3 = 63629 # for shuffling 60,000+ indexes (only needs 32bit unsigned math)
    var randR = self.shuffleID + 131 * (inx / self.listSize) # have inx overflow effect the mix
    # compute fixed randomizing values once for a given shuffle
    var r1 = randR % p3
    var r2 = randR % p1 # Now, per Chinese remainder theorem,
    var r3 = randR % p2 # (r1,r2,r3) will be a unique set
    var r4 = randR % 2749
    var halfN = self.listSize / 2 + 1
    var rx = (randR / self.listSize) % self.listSize + 1
    var rkey = (randR / (self.listSize * self.listSize)) % self.listSize + 1
    var si = (inx + randR) % self.listSize # cut the deck
    # perform the conditional multi-faceted mathematical mixing (on avg 2 5/6 shuffle ops done + 2 simple Xors)
    if si % 3 == 0
      si = (((si / 3) * p1 + r1) % ((self.listSize + 2) / 3)) * 3 # spin multiples of 3
    end
    if si <= halfN # improves large permu distro
      si = halfN - (si + r3) % (halfN + 1)
    end
    if si % 2 == 0 # spin multiples of 2
      si = (((si / 2) * p2 + r2) % ((self.listSize + 1) / 2)) * 2
    end
    if si < halfN
      si = (si * p3 + r3) % halfN
    end
    if si ^ rx < self.listSize # flip some bits with Xor
      si ^= rx
    end
    si = (si * p3 + r4) % self.listSize # relatively prime gears churning operation
    if si ^ rkey < self.listSize
      si ^= rkey
    end
    return si
  end
end

millershuffle_module.init =
  def (m)
    return MillerShuffle()
  end
return millershuffle_module
