# the Miller Shuffle Algorithm in Berry

This is a port of the [Miller Shuffle
Algorithm](https://github.com/RondeSC/Miller_Shuffle_Algo) to the
[Berry scripting language](https://github.com/berry-lang/berry) as
embedded into [Tasmota](https://github.com/arendst/Tasmota).  The port
was performed by sfromis and posted in this [Tasmota discussion
thread](https://github.com/arendst/Tasmota/discussions/19624 ).

## Usage

Upload millershuffle.be into the Tasmota file system under Consoles ->
Manage File Systems, then the import in the code sample below will work.

    import millershuffle
    var ms = millershuffle.create(123,100)  # shuffleID 123, listSize 100
    print(ms.random())                      # next random number in shuffle sequence
    print(ms.random(8))                     # reset index in sequence and get random number

Doing a speed comparison with math.rand(), a simple loop summing 2000
numbers took 160 ms vs 46 ms on an ESP32-C3. The speed of this should
be fine for most purposes.


