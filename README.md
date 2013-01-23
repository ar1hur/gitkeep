[![Build Status](https://travis-ci.org/ar1hur/gitkeep.png?branch=master)](https://travis-ci.org/ar1hur/gitkeep)
#gitkeep (ruby 1.9.3 required)
=======

People who want to track empty directories in Git, have created the convention of putting files called “.gitkeep” in these directories.
Because Git is not able to track empty directories. oO
For lazy people (like me) i created this tiny gem to create .gitkeep files automatically. JEAH!

##changelog
0.2.4
-       added -h option to show possible options

0.2.3
-		added -a option to execute git add for adding directories which have a .gitkeep file in there	

0.2.2
-		added rspec tests
-		added interactive mode
- 	counting errors
-		refactored code

0.2.1  
-   added checks for read/write permissions  
-   added a counter to show how many files were created  
    
0.2.0  
-   first release


##usage
``` shell
# current path    
$ gitkeep

# with specified path
$ gitkeep /var/www/myproject

# dryrun - doesn't create any files, but you will see in which places gitkeep would create files
$ gitkeep -d
# or
$ gitkeep -d some/path

# interactive mode - ask you everytime when gitkeep wants to create a file
$ gitkeep -i

# after creating .gitkeep files you can add these automatically with -a option to your git index
$ gitkeep -a
```

##installation
see [https://rubygems.org/gems/gitkeep](https://rubygems.org/gems/gitkeep "Title")
