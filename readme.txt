Revised Hack Assembler
- written in Ruby -

This is an assembler for Hack assembly code for the Hack computer, as presented in the Nand-to-Tetris book.
I have improved a lot since my first attempt at it last year, and felt I can finally share something that may 
actually help other people. With that said, I still have very much to learn, so please let me know if there's anything I can improve!

How to Use This:
In your terminal, execute the `main.rb` file in this directory. Pass in a single file path for your source code before entering the command. The program will assemble your file and write a `.hack` plaintext file using the same path it received as input. That's all there is to it. 

You can verify the assembler's accuracy by comparing its output to the one generated by the official assembler. Included in this folder is a small file for doing just that. You'll have to provide both files yourself but once you have them you can enter something like this:

`$ ruby compare.rb test_file.hack verification_file.hack`

It will output "true" if the two files are exactly the same. Be sure to check for any trailing whitespace. If one file ends with a newline and the other doesn't the result will be false.

While there may be slightly more error checking in this than the project requires, there isn't much. I might come back and fix that in the future, but for now it assumes you are passing in error-free code.

There are a lot of things I wish I had known when I first took up this project. Everything was in a single file, I didn't understand how to use or reference constant values, I was not always clear about what my code was doing (although I could still figure it out without too much trouble while making this revision). Actually, I ran my old version during testing and saw that it was even slower than this new version. I tried to show off some more advanced concepts here, but I still want it to be accessible enough so that someone might still get some insight or inspiration from it, even if they don't understand it much. Please tell me how successful I was. It is my hope that someone may find any of this useful. 

I plan to do a Java version next, although this took almost six hours to do in my main language so that might take a while--or who knows. Maybe all the extra insight I got from this run will make the Java version easier.