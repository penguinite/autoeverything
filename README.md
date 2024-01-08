# autoeverything
Every package ever... Now in one convenient automated package!

`autoeverything` contains tools to automate the installation and upgrade of every nimble package ever.

**Note:** *this project is still in development*

## What?

This project, as strange as it may seem, is quite good at detecting old packages in need of updates.

Yes, downloading every nimble package ever just to sort out a couple of packages isn't very efficient. But the nim ecosystem is small so I can handle running this every week or so.
 
Installing a package may not sound all that much of an advanced test, and sure, it isn't. But installing packages is one of the easiest ways to check for if a package has a valid structure and if it is usable by anyone even.

Bad, outdated and/or stale packages tend to use old ways of installation, rely on dependencies that no longer are there. Or their structure is horribly messed up. These are all things that nimble checks for by default when installing.

You might suggest testing packages, and that does seem like a good idea but testing every package ever would be an enormous, complex operation. And many developers also do not bother with writing tests. Installation is not that expensive computationally (Maybe it is, storage-wise) and *every* nimble package has to be installable. Otherwise, what's the point?

So this project takes the next step of automating everything, so that package errors can be found even quicklier and easier than before. In addition, I've tried to keep everything here as simple as possible.

## How different is this from the regular `everything` project?

Here are the differences between everything and autoeverything:
1. Autoeverything continually installs packages and logs the errors they output.
2. Autoeverything provides a command-line tool (`autoanalyze`) that analyzes the tested output and produces human-readable summaries.
3. Everything simply contains a nimble import statement for every package ever. (No automation whatsoever)
4. There might be a web frontend for autoeverything too!