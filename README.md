# Caesar-ciphes-in-Asembly
Caesar cipher coded in Assembly

This is an implementation of a variant of Speck with 128-bit block size and key using ARM Assembly. C code for this 
programe can be found in Wikipedea. Here this is the Assembly implementation of the programe. 

Program should behave like the following:

Enter the key:
0f0e0d0c0b0a0908 0706050403020100
Enter the plain text:
6c61766975716520 7469206564616d20
Cipher text is:
a65d985179783265 7860fedf5c570d18

All the inputs and outputs are in hexadecimal. 128-bit version of Speck uses 64-bit unsigned integers
for calculation and hence observe that each input and output above has 2 separate numbers in
hexadecimal.


Facts:
ARM has 32 bit registers but here the operations are done on 64 bit unsigned integers which is a quite challenging tast.
