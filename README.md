# chain-heal

An implementation of chain_heal.c in Swift

This is a [lab](http://web.eecs.utk.edu/~plank/plank/classes/cs360/360/labs/lab0/index.html) from CS360 (systems programming) and I thought it would be fun to see what a Swift version might look like. 

The project needs to be compiled with -lm for rounding with rint — I do this:

`swiftc main.swift Player.swift ChainInfo.swift Point.swift -lm -o chain_heal`
