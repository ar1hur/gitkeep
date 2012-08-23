#gitkeep
=======

create .gitkeep files in all empty directories in your project

##changelog
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
```

##installation
see [https://rubygems.org/gems/gitkeep](https://rubygems.org/gems/gitkeep "Title")