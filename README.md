#RSA Jazz

##Notes
We were repeatedly kicked off the lab machines in 255 by people restarting computers, arbitrary midnight reboots, and other factors left to the gods. Our detached parallel process cracking 20K keys might not have finished, of that we're not sure, but we are sure it put up a valient effort and returned 10 bad keys before peetering out into the /dev/null ether for a final time.

##How to compile
To compile the serial and parallel executables please run...
`make serial`
`make parallel`

Some make targets will also run the compiled executable... so be prepared for that...

##How to run

Before running either executable the GMP library must be linked. Typically this happens during the compile phase, but if it doesn't, run `LD_LIBRARY_PATH=/home/clupo/gmp/lib` explicitly.

###Serial
`./serialGCD <keyFile>`

###Parallel (CUDA)
`./rsaCuda <keyFile>`

##Times

###Serial
*256:  .574s
*2048: 36.630s
*4096: 2m 26.749s
*20K:  60m 50.192s

###Parallel (CUDA)
*256:  1.642s
*2048: 44s
*4096: 2m 53s
*20K:  2hrs 22m+? (Might not have properly finished)