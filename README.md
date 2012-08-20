#gitkeep
=======

create .gitkeep files in all empty directories in your project

##changelog
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

# dryrun - creating of files is disabled but output is shown
$ gitkeep -d
# or
$ gitkeep -d some/path
```

##installation
see [https://rubygems.org/gems/gitkeep](https://rubygems.org/gems/gitkeep "Title")